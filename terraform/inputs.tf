variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "region" {
  default = "eu-de"
}

variable "basename" {
  default = "rovs-lab"
}

variable "title" {
  default = "ROVS Lab"
}

variable "tags" {
  default = [ "rovs", "lab", "terraform" ]
}

variable "user_count" {
  default = 45
}

variable "user_prefix" {
  default = "rovsuser"
}
