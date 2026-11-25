terraform {
  required_version = ">= 1.14"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 2.10.0"
    }
  }
}

provider "ibm" {
  region = var.region
}
