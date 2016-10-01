variable "shared_credentials_file" {}

variable "profile" {
  default = "default"
}

variable "pub_subnet_az" {
  default = "us-east-1b"
}

variable "priv_subnet_azs" {
  default = "us-east-1c,us-east-1d"
}
