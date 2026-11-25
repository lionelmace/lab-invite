resource "ibm_resource_instance" "appid" {
  name              = "${var.basename}-appid"
  service           = "appid"
  plan              = "graduated-tier"
  location          = var.region
  resource_group_id = var.resource_group_id
  tags              = var.tags
}

resource "ibm_resource_key" "appid" {
  resource_instance_id = ibm_resource_instance.appid.id
  role                 = "Writer"
  name                 = "${var.basename}-appid-key"
}

resource "ibm_appid_apm" "apm" {
  tenant_id = ibm_resource_instance.appid.guid
  enabled   = true

  password_reuse {
    enabled = false
  }

  password_expiration {
    enabled = false
  }

  lockout_policy {
    enabled          = false
    lockout_time_sec = 2600
    num_of_attempts  = 4
  }

  min_password_change_interval {
    enabled                      = false
    min_hours_to_change_password = 1
  }
}

resource "ibm_appid_idp_google" "g" {
  tenant_id = ibm_resource_instance.appid.guid
  is_active = false
}

resource "ibm_appid_idp_facebook" "f" {
  tenant_id = ibm_resource_instance.appid.guid
  is_active = false
}

resource "ibm_appid_theme_text" "text" {
  tenant_id = ibm_resource_instance.appid.guid
  tab_title = var.title
  footnote  = var.title
}

resource "ibm_appid_theme_color" "theme" {
  tenant_id    = ibm_resource_instance.appid.guid
  header_color = "#5596E6"
}

resource "ibm_appid_idp_cloud_directory" "cd" {
  tenant_id                           = ibm_resource_instance.appid.guid
  is_active                           = true
  identity_field                      = "userName"
  self_service_enabled                = false
  signup_enabled                      = false
  welcome_enabled                     = false
  reset_password_enabled              = false
  reset_password_notification_enabled = false
  identity_confirm_access_mode        = "OFF"
  identity_confirm_methods            = []

  lifecycle {
    ignore_changes = [
      identity_confirm_methods
    ]
  }
}

resource "random_password" "password" {
  count = var.user_count

  length  = 16
  special = false
}

resource "ibm_appid_cloud_directory_user" "user" {
  count = var.user_count

  tenant_id = ibm_appid_idp_cloud_directory.cd.tenant_id

  email {
    value   = "${var.user_prefix}-${format("%02d", count.index + 1)}@example.com"
    primary = true
  }

  active = true
  status = "CONFIRMED"

  user_name = "${var.user_prefix}-${format("%02d", count.index + 1)}"
  password  = var.user_password == "" ? random_password.password[count.index].result : var.user_password
  display_name = "${var.user_prefix}-${format("%02d", count.index + 1)}"
}

# resource "ibm_appid_user_roles" "roles" {
#   count = var.user_count

#   tenant_id = ibm_appid_idp_cloud_directory.cd.tenant_id
#   subject   = ibm_appid_cloud_directory_user.user[count.index].subject
#   role_ids  = [ibm_appid_role.attendee.role_id]
# }

data "ibm_iam_auth_token" "tokendata" {}
data "ibm_iam_account_settings" "iam_account_settings" {}

resource "null_resource" "appid_logo" {
  provisioner "local-exec" {
    command = "curl -X POST -H \"Authorization: ${data.ibm_iam_auth_token.tokendata.iam_access_token}\" -F file=@${path.module}/header.jpg ${ibm_resource_key.appid.credentials.managementUrl}/config/ui/media?mediaType=logo"
  }
}

# https://github.ibm.com/IAM/access-management/blob/master/api/controllers/identity-providers.js
provider "restapi" {
  alias                = "idp"
  uri                  = "https://iam.cloud.ibm.com/v1/loginsettings/${data.ibm_iam_account_settings.iam_account_settings.account_id}"
  debug                = true
  write_returns_object = true
  headers = {
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
  }
}

resource "restapi_object" "idp" {
  provider = restapi.idp
  path     = "/idps"
  data = jsonencode(
    {
      name = "${var.basename}-idp"
      type = "appid"
      properties = {
        crn    = ibm_resource_instance.appid.crn
        iam_id = ibm_resource_instance.appid.created_by
      }
      cloud_user_strategy = var.cloud_user_strategy
    }
  )
  id_attribute = "idp_id"

  lifecycle {
    ignore_changes = [ data ]
  }
}

data "http" "idp_enable" {
  provider = http-full
  url      = "https://iam.cloud.ibm.com/v1/loginsettings/${data.ibm_iam_account_settings.iam_account_settings.account_id}/idps/${restapi_object.idp.api_data.idp_id}/enable"

  method = "PUT"

  request_headers = {
    "Content-Type" : "application/json"
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
  }

  request_body = jsonencode({
    ui_default = false
  })
}

data "http" "idp_settings" {
  provider = http-full
  url      = "https://iam.cloud.ibm.com/v1/loginsettings/${data.ibm_iam_account_settings.iam_account_settings.account_id}"

  method = "GET"

  request_headers = {
    "Content-Type" : "application/json"
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
  }
}

locals {
  idp_realm = restapi_object.idp.api_data.idp_id
}

output "idp_realm" {
  value = local.idp_realm
}

output "idp_url" {
  value = "https://cloud.ibm.com/authorize/${jsondecode(data.http.idp_settings.response_body).alias}/${restapi_object.idp.api_data.idp_id}"
}
