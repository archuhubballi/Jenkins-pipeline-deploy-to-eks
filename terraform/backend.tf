terraform {
    backend "s3" {
      bucket = "mydevops-s3-bucket"
      region = "us-east-1"
      key = "eks/terraform.tfstate"
    }
}