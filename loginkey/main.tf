// Pem Key 생성
resource "ncloud_login_key" "loginkey" {
  key_name = var.key_name
}

// Pem Key 다운로드
resource "local_file" "ssh_key" {
  filename = "${var.key_name}.pem"
  content = ncloud_login_key.loginkey.private_key
}
