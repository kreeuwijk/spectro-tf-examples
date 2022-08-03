terraform {
  required_providers {
    spectrocloud = {
      version = "~> 0.8.8"
      source  = "spectrocloud/spectrocloud"
    }
  }
}

provider "spectrocloud" {
  host         = var.sc_host
  api_key      = var.sc_api_key
  project_name = var.sc_project_name
}  

provider "aws" {

  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  region  = "eu-west-3"
  profile = "default"

  assume_role {
    role_arn    = "arn:aws:iam::<account>:role/<role>"
  }
}