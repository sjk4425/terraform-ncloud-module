// ACG Rule 생성
// IP주소 기준 으로 접근소스 지정 시
resource "ncloud_access_control_group_rule" "acg_rule_ipblock" {
  count = (var.ipblock_chk == true) ? 1 : 0
  access_control_group_no = var.access_control_group_no

  dynamic "inbound" {
    for_each = var.acg_rule_inbound
    content {
      protocol    = inbound.value[0]
      ip_block    = inbound.value[1]    
      port_range  = inbound.value[2]
      description = inbound.value[3]
    }
  } 

  outbound  {
    protocol = "TCP"
    ip_block = "0.0.0.0/0"
    port_range = "1-65535"
    description = "Outbound TCP Open"
  } 

  outbound  {
    protocol = "UDP"
    ip_block = "0.0.0.0/0"
    port_range = "1-65535"
    description = "Outbound UDP Open"
  } 

  outbound  {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
    description = "Outbound ICMP Open"
  }
}


// ACG 명 기준으로 접근 소스 지정 시
resource "ncloud_access_control_group_rule" "acg_rule_acgno" {
  count = (var.ipblock_chk == true) ? 0 : 1
  access_control_group_no = var.access_control_group_no

  dynamic "inbound" {
    for_each = var.acg_rule_inbound
    content {
      protocol    = inbound.value[0]
      source_access_control_group_no = inbound.value[1]
      port_range  = inbound.value[2]
      description = inbound.value[3]
    }
  }

  outbound  {
    protocol = "TCP"
    ip_block = "0.0.0.0/0"
    port_range = "1-65535"
    description = "Outbound TCP Open"
  } 

  outbound  {
    protocol = "UDP"
    ip_block = "0.0.0.0/0"
    port_range = "1-65535"
    description = "Outbound UDP Open"
  } 

  outbound  {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
    description = "Outbound ICMP Open"
  }
}
