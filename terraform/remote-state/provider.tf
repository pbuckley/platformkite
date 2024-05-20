terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
  required_version = ">= 1.8.3"
}

provider "aws" {
  region = var.aws_region
}
