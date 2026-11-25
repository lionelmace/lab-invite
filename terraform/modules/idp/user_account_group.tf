# an access group
variable "access_group_name" { default = "" }
resource "ibm_iam_access_group" "users" {
  name        = var.access_group_name == "" ? "${var.basename}-access-group" : var.access_group_name
  description = local.description
}
