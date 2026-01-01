# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "3tier-project-homelab-backend-bucket006"
    key     = "vpc-terraform-github-action.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}