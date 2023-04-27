// 사용할 k8s version 입력
variable "k8s_version" {
  type = string
  default = "1.22.9"
}

// VPC ID
variable "vpc_no" {
  type = string
}

// Kubernetes를 생성할 Subnet
variable "subnet_no_list" {
  type = list(string)
}

// Kubernetes에 사용할 LB용 Subnet
variable "lb_private_subnet_id" {
  type = string
}

// login key name
variable "loginkeyname" {
  type = string
  default = ""
}

// Kubernetes를 생성할 Zone 선택(ex:KR-1,KR-2...)
variable "zone" {
  type = string
}

// Kubernetes 이름
variable "k8s_name" {
  type = string
}

// audit 로그 설정
variable "audit" {
  type = bool
  default = false
}

variable "cluster_type" {
  type = string
  default = "10"
}

variable "cluster_type_map" {
  type = map(string)
  default = {
    "10" = "SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002"
    "50" = "SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002"
  }
}

// --------------------------- //
// node pool 변수

// 기본 노드 갯수
variable "node_count" {
  type = number
  default = 1
}

// Subnet 선택
variable "subnet_id" {
  type = string
}

// auto scaling 설정
// 활용여부
variable "auto_scaling_enabled" {
  type = bool
  default = "false"
}
// 범위(최소, 최대)
variable "min" {
  type = number
  default = 10
}
variable "max" {
  type = number
  default = 10
}

// OS 선택
variable "image_name" {
  type = string
  default = "Ubuntu Server 20.04 (64-bit)"
}

// cpu 갯수 선택
variable "cpu_count" {
  type = string
}

// memory 크기 선택
variable "memory_size" {
  type = string
}

variable "product_type" {
  type = string
}
