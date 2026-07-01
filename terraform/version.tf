terraform {

  required_version = ">= 1.5"

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"   # 6.x exists; 5.x is stable and fine here

    }

  }

}

provider "aws" {

  region = "us-east-1"

}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

