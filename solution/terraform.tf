terraform {
  required_version = "= 0.11.10"

  backend "s3" {
    bucket = "ecs-workshop-terraform-state-dev"
    key = "${unique}-odin-service-dev.tfstate"
    dynamodb_table = "Terraform-Lock-Table"
    encrypt = true
    region = "us-east-1"
  }
}

provider "aws" {
  region = "${local.region}"
  version = "~> 1.46"
}

provider "template" {
  version = "~> 1.0"
}

locals {

}