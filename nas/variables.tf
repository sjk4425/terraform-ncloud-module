// NAS Volume 이름 설정
variable "volume_name_postfix" {
    type = string
}

// NAS Volume 크기 설정(GB 단위)
variable "volume_size" {
    type = string
    default = "500"
}


// NAS Volume 타입 지정(NFS, CIFS)
variable "volume_allotment_protocol_type" {
    type = string
    default = "NFS"
}

// NAS 접근제어 설정(허용할 서버 목록 입력)
variable "server_instance_no_list" {
    type = list(string)
}
