# Terraform configuration
terraform {
  # Backend configuration
  backend "s3" {
    region = "eu-west-2"

    bucket               = "connorgurney-homelab-iac-state"
    key                  = "homelab-dns"
    workspace_key_prefix = ""

    dynamodb_table = "connorgurney-homelab-iac-locks"
  }
}

# AWS provider
provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      "connorgurney:workload"    = "homelab-dns"
      "connorgurney:environment" = var.environment
    }
  }
}
