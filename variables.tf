variable "shared_credentials_file" {}
variable "my_ip" {}
variable "key_name" {}

variable "profile" {
  default = "default"
}

variable "azs" {
  default = "us-east-1c,us-east-1d"
}

variable "ami" {
  # amazon linux
  default = "ami-c481fad3"
}

variable "route53_zone_id" {
  default = "ZYES1URJNHEX2"
}
