terraform {
  backend "s3" {
    bucket = "zaman-terra-state-1"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
