terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14"
    }
  }
  required_version = ">= 1.2"
  backend "s3" {
    bucket = "rhbtfstate"
    key    = "terraform/basic/env/state"
    region = "us-east-2"
  }

}
