terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  support_vpc = true                      
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
  site = var.site
}

