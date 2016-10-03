variable "shared_credentials_file" {}
variable "my_ip" {}

variable "profile" {
  default = "default"
}

variable "pub_subnet_az" {
  default = "us-east-1b"
}

variable "priv_subnet_azs" {
  default = "us-east-1c,us-east-1d"
}

variable "ami" {
  # amazon linux
  default = "ami-c481fad3"
}
