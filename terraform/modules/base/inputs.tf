variable "basename" {}
variable "tags" {}

locals {
  description = "Created by terraform for ${var.basename}"
}