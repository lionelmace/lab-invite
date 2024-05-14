terraform {
  required_version = "< 1.6"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.65"
    }
  }
}

variable "region" {
  default = "us-south"
}

provider "ibm" {
  region = var.region
}
