// Access Key 입력
variable "access_key" {
  default = ""
}

// Secret Key 입력
variable "secret_key" {
  default = ""
}

// 생성할 Region 입력
variable "region" {
    default = "KR"
}

// 공공, 민간, 금융 선택
// gov, pub, fin
variable "site" {
  default = "pub"
}
