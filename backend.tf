### Backend ###
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "main.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock"
  }
}

### Providers ###
provider "aws" {
  region                  = "${var.region}"
  version = "~> 1.40.0"
}

provider "random" {
  version = "~> 2.0"
}