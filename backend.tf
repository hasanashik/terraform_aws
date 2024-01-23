terraform {
  backend "s3" {
    bucket = "zaman-terra-state"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
