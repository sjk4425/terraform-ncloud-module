// Subnet을 생성할 VPC 지정
variable "vpc_no" {
  type = string
}

// Subnet을 생성할 Zone 선택(ex:KR-1,KR-2...)
variable "zone" {
  type = string
}

// Subnet 사용 대역
variable "subnet_CIDR" {
  type = string
}

// Subnet 타입(공인,사설)
variable "subnet_type" {
  type = string
}

// Subnet 이름
variable "subnet_name" {
  type = string
}

// Subnet 종류(일반 or LB)
variable "usage_type" {
  type = string
  default = "GEN"
}

// NATGW 여부
variable "natgw_chk" {
  type = bool
  default = false
}

// Route table ID
variable "route_table_no" {
  type = string
  default = ""
}