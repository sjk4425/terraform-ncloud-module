// Server 설정
//// ACG 설정
variable "access_control_groups" {
  type = list(string)
}

//// Server name
variable "server_name" {
  type = string
}

//// login key name
variable "loginkeyname" {
  type = string
  default = ""
}

//// 이미지 선택
variable "image_name" {
  type = string
}

//// Server 생성 갯수
variable "create_num" {
  type = number
  default = 1
}

//// Subnet ID
variable "subnet_id" {
  type = string
}

//// Server Storage 타입(SSD,HDD)
variable "product_code" {
  type = string
}

//// Server Type 선택(HICPU, HIMEM, STAND, GPU, CPU)
variable "product_type" {
  type = string
}

//// CPU 갯수
variable "cpu_count" {
  type = string
}

//// Memory 크기
variable "memory_size" {
  type = string
}

//// 서버 설명
variable "server_description" {
  type = string
  default = ""
}

//// 반납보호 설정
variable "is_protect_server_termination" {
  default = false
}

// init script 적용
variable "init_script_no" {
  type = string
  default = ""
}

// Public IP 유무
variable "pubip" {
  type = bool
  default = false
}