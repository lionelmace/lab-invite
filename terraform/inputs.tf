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
