terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws   = ">=5.69.0"
    local = ">=2.5.2"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  config_path = var.kubeconfig
}
