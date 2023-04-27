// ACG 이름
variable "acg_name" {
  type = string
}

// VPC ID
variable "vpc_no" {
  type = string
}

// ACG 주석
variable "acg_description" {
  type = string
  default = ""
}