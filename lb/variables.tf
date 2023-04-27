// Load Balancer 이름
variable "lb_name" {
  type = string
}

// LB 타입(PUBLIC/PRIVATE)
variable "lb_network_type" {
  type = string
  default = "PUBLIC"
}

// LB 종류(ALB, NPLB, NLB)
variable "lb_type" {
  type = string
  default = "APPLICATION"
}

// 크기
variable "throughput_type" {
  type = string
  default = "SMALL"
}

// LB를 생성할 Subnet 지정
variable "subnet_no_list" {
  type = list(string)
}

// LB 주석
variable "lb_description" {
  type = string
  default = ""
}


// LB Listener을 위한 변수
// Protocol 설정
variable "listener_protocol" {
  type = string
  default = "http"
}

// Port 설정
variable "listener_port" {
  type = number
  default = 80
}

// Certificate Manager에 등록한 SSL 인증서 ID 값
variable "certificate_no" {
  type = string
  default = ""
}

// TLS 최소 버전 선택(TSLV10, TSLV11, TSLV12)
variable "tls_min_version_type" {
  type = string
  default = "TLSV12"
}

// LB에 할당할 Target Group no
variable "target_group_no" {
}