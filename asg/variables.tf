// Auto Scaling Group Configuration 변수
//// 이름 설정
variable "asg_conf_name" {}
  

//// 이미지 선택
variable "image_name" {
  type = string
}

//// loginkey 설정
variable "login_key_name" {
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

//// Server Storage 타입(SSD,HDD)
variable "product_code" {
  type = string
}

// Auto Scaling Group 설정
//// 이름 설정
variable "asg_name" { }

//// ASG 생성할 Subnet
variable "subnet_no" { }

//// ACG 설정
variable "access_control_groups" {
  type = list(string)
}

//// Health Check Type 설정
variable "health_check_type_code" {
  type = string
  default = "SVR"
}

//// Health Check 보류 기간 설정
variable "health_check_grace_period" {
  type = number
  default = 300
}
//// 최소 수량
variable "min_size" {
  type = number
  default = 1
}

//// 기대 수량
variable "desired_capacity" {
  type = number
  default = 1
}

//// 최대 수량
variable "max_size" {
  type = number
  default = 1
}

//// ASG에 생성할 서버 이름
variable "server_name_prefix" {
  type = string
  default = ""
}

//// ASG에 적용할 Target Group 목록
variable "target_group_list" {
  type = list
  default = [ "" ]
}

// 정책 및 일정 설정
//// 정책 또는 일정 선택
variable "policy_chk" {
  type = bool
  default = true
}

//// 정책 설정
////// 이름 설정
variable "policy_name" {
  type = string
  default = ""
}

////// Scaling 설정(CHANG=증감변경, EXACT=고정값, PRCNT=비율변경)
variable "adjustment_type_code" {
  type = string
  default = "CHANG"
}

//// 증감 숫자 설정
variable "scaling_adjustment" {
  type = number
  default = 0
}

//// 일정 설정
////// 최소 갯수
variable "schdule_min_size" {
  type = number
  default = 1
}

////// 최대 갯수
variable "schdule_max_size" {
  type = number
  default = 1
}

////// 기대 수량
variable "schdule_desired_capacity" {
  type = number
  default = 1
}

////// 시작날짜 설정
variable "start_time" {
  type = string
  default = ""
}

////// 종료날짜 설정
variable "end_time" {
  type = string
  default = ""
}

////// 반복날짜 설정
variable "recurrence" {
  type = string
  default = ""
}