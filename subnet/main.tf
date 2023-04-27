// NACL 생성
resource "ncloud_network_acl" "create_nacl" {
   vpc_no      = var.vpc_no
   name        = "${var.subnet_name}-nacl"
   description = "${var.subnet_name}용 nacl"
 }

// Subnet 생성
resource "ncloud_subnet" "create_subnet" {
  vpc_no = var.vpc_no
  subnet = var.subnet_CIDR
  zone = var.zone
  network_acl_no = ncloud_network_acl.create_nacl.network_acl_no
  subnet_type = upper(var.subnet_type)
  name = var.subnet_name
  usage_type = upper(var.usage_type)
}

// Private Route table 경우
resource "ncloud_route_table_association" "route_table_attach" {
  count = ((upper(var.subnet_type) == "PRIVATE" && upper(var.usage_type) != "LOADB") && natgw_chk == true) ? 1 : 0
  route_table_no = var.route_table_no
  subnet_no = ncloud_subnet.create_subnet.id
}