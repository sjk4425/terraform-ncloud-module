// VPC ID
variable "vpc_no" {
  type = string
}

// Target Group 설정
// Target Group 프로토콜 지정
variable "protocol" {
  type = string
}

// target group 포트 지정
variable "port" {
  type = number
}

// target group 이름 지정
variable "tg_name" {
  type = string
}

// target group 주석
variable "tg_description" {
  type = string
  default = ""
}

// health check에 사용하는 프로토콜 지정
variable "health_check_protocol" {
  type = string
}

// health check에 사용하는 포트 지정
variable "health_check_port" {
  type = number
}

// Target Group 알고리즘 지정
variable "algorithm_type" {
  type = string
}

// Target Group http method 지정 (HTTP,HTTPS)
variable "http_method" {
  type = string
  default = "get"
}

// Target Group URL Path 지정 (HTTP,HTTPS)
variable "url_path" {
  type = string
  default = "/"
}

// Target Group Health Check 주기
variable "cycle" {
  type = number
  default = 30
}

// Target Group Health Check 정상 임계값
variable "up_threshold" {
  type = number
  default = 2
}

// Target Group Health Check 실패 임계값
variable "down_threshold" {
  type = number
  default = 2
}

// Target Group에 할당할 Target 리스트
variable "target_no_list" {
  type = list(string)
  default = [ "" ]
}

// Target Group에 Server 할당 여부
variable "target_no_list_chk" {
  type = bool
  default = true
}
