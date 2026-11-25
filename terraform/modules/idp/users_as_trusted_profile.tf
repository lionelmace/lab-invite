variable "trusted_profile_name" { default = "" }
variable "trusted_profile_description" { default = "" }

# a trusted profile for all users
resource "ibm_iam_trusted_profile" "trusted_profile" {
  count       = local.use_trusted_profile ? 1 : 0
  name        = var.trusted_profile_name == "" ? "${var.basename}-profile" : var.trusted_profile_name
  description = var.trusted_profile_description == "" ? "Attendee" : var.trusted_profile_description
}

resource "ibm_iam_trusted_profile_claim_rule" "trusted_profile_claim" {
  count      = local.use_trusted_profile ? 1 : 0
  profile_id = ibm_iam_trusted_profile.trusted_profile.0.id
  type       = "Profile-SAML"
  name       = "${var.basename}-attendee"
  realm_name = "appid://${local.idp_realm}"
  expiration = 7200
  conditions {
    claim    = "firstName"
    operator = "NOT_EQUALS"
    value    = "\"__not_empty__\""
  }
}

resource "ibm_iam_access_group_members" "trusted_profile" {
  count           = local.use_trusted_profile ? 1 : 0
  access_group_id = ibm_iam_access_group.users.id
  iam_profile_ids = [ibm_iam_trusted_profile.trusted_profile.0.id]
}
