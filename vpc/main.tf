// VPC 생성
resource "ncloud_vpc" "create_vpc" {
    name = var.vpc_name
    ipv4_cidr_block = var.vpc_cidr_block
}