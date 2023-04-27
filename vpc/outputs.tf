// 생성한 VPC ID 값 반환
output "vpc_no" {
  value = ncloud_vpc.create_vpc.id
}