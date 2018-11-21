terraform {
  required_version = "= 0.11.10"

  backend "s3" {
    bucket = "ecs-workshop-terraform-state-dev"
    key = "ecs-workspace-odin-service-dev.tfstate"
    dynamodb_table = "Terraform-Lock-Table"
    encrypt = true
    region = "us-east-1"
  }
}