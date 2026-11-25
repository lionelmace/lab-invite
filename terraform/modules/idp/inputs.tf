variable "basename" {}
variable "resource_group_id" {}
variable "tags" {}
variable "region" {}
variable "title" {}
variable "user_count" {}
variable "user_prefix" {
  validation {
    condition = length(var.user_prefix) >= 5
    error_message = "user_prefix must be at least 5 characters"
  }
}
variable "user_password" {
  default = ""
  description = "Sets to a password used by all users. Leave empty to use a unique password per user."
}
variable "cloud_user_strategy" {
  default = "NEVER"
  description = "NEVER for Trusted Profile, STATIC for regular users."
}

locals {
  description = "Created by terraform for ${var.basename}"
  use_trusted_profile = var.cloud_user_strategy == "NEVER"
}
