// ACG 생성
resource "ncloud_access_control_group" "create_acg" {
  name = var.acg_name
  description = var.acg_description
  vpc_no = var.vpc_no
}