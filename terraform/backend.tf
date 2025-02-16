terraform {
    backend "s3" {
      bucket = "mydevops-s3-bucket"
      region = "us-east-2"
      key = "Archu/terraform.tfstate"
    }
}
