terraform {
  required_version = ">= 1.5"
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 1.16.2"
    }
    http-full = {
      source = "salrashid123/http-full"
    }
  }
}