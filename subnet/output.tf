// 생성한 Subnet ID 값 반환
output "subnet_no" {
  value = ncloud_subnet.create_subnet.id
}

// 생성한 Subnet 대역대 반환
output "subnet_CIDR" {
  value = ncloud_subnet.create_subnet.subnet
}