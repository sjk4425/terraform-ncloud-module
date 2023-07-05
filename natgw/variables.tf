// VPC ID
variable "vpc_no" {
  type = string
}

// subnet ID
variable "subnet_no" {
}

// NAT GW 이름
variable "natgw_name" {
  type = string
}

// NAT GW Zone 선택
variable "zone" {
  type = string
}

variable "description" {
  type = string
  default = ""
}