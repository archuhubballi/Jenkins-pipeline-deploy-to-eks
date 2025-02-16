terraform {
    backend "s3" {
      bucket = "mydevops-archuhubballi-s3bucket"
      region = "us-east-1"
      key = "Archu/terraform.tfstate"
    }
}
