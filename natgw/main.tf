// NAT GW 생성
resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no = var.vpc_no
  subnet_no = var.subnet_no
  zone = var.zone
  name = var.natgw_name   
  description = var.description
}

// private-route-table 생성
resource "ncloud_route_table" "create_routetable" {
  vpc_no = var.vpc_no
  supported_subnet_type = "PRIVATE"
  name = "private-route-table-${lower(var.zone)}"
  description = "${var.zone}용 Route table"
}

// private-route table NATGW 연결 설정
resource "ncloud_route" "route_setting" {
  route_table_no = ncloud_route_table.create_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  target_type = "NATGW"
  target_name = ncloud_nat_gateway.nat_gateway.name
  target_no = ncloud_nat_gateway.nat_gateway.id
}
