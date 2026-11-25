# dynamically add users to the access group if they don't use the trusted profile
resource "ibm_iam_access_group_dynamic_rule" "user_claim" {
  count             = local.use_trusted_profile ? 0 : 1
  name              = "${var.basename}-attendee"
  access_group_id   = ibm_iam_access_group.users.id
  expiration        = 2
  identity_provider = "appid://${local.idp_realm}"

  conditions {
    claim    = "firstName"
    operator = "NOT_EQUALS"
    value    = "__not_empty__"
  }
}
