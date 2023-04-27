// VPC CIDR
variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

// VPC 이름
variable "vpc_name" {
  type = string
}