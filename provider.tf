provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
}
