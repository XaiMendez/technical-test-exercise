variable "aws_region" {
  type = string
}

variable "iam_access_key" {
  type = string
}

variable "iam_secret_key" {
  type = string
}

variable "az_names" {
  type    = list(string)
  default = [""]
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr_blocks" {
  type    = list(string)
  default = [""]
}

variable "private_subnet_cidr" {
  type = string
}

variable "ubuntu_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}


variable "database_name" {
  type = string
}

variable "database_username" {
  type = string
}

variable "database_password" {
  type = string
}