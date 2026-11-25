resource "ibm_resource_group" "lab" {
  name = "${var.basename}-lab"
  tags = var.tags
}