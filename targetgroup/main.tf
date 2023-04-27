// target group 생성
//// Target Group - ALB(HTTP&HTTPS)
resource "ncloud_lb_target_group" "tg_http" {
  count = (upper(var.protocol) == "HTTP" || upper(var.protocol) == "HTTPS") ? 1 : 0
  vpc_no   = var.vpc_no
  protocol = var.protocol
  name = var.tg_name
  target_type = "VSVR"
  port        = var.port
  description = var.tg_description
  health_check {
    protocol = var.health_check_protocol
    http_method = var.http_method
    port           = var.health_check_port
    url_path       = var.url_path
    cycle          = var.cycle
    up_threshold   = var.up_threshold
    down_threshold = var.down_threshold
  }
  algorithm_type = var.algorithm_type
}

//// Target Group - NLB(TCP), NPLB(Proxy TCP)
resource "ncloud_lb_target_group" "tg_tcp" {
  count = (upper(var.protocol) == "HTTP" || upper(var.protocol) == "HTTPS") ? 0 : 1
  vpc_no   = var.vpc_no
  protocol = var.protocol
  name = var.tg_name
  target_type = "VSVR"
  port        = var.port
  description = var.tg_description
  health_check {
    protocol = var.health_check_protocol
    port           = var.health_check_port
    cycle          = var.cycle
    up_threshold   = var.up_threshold
    down_threshold = var.down_threshold
  }
  algorithm_type = var.algorithm_type
}


// Target Server 지정
//// ALB
resource "ncloud_lb_target_group_attachment" "tg_attach_http" {
  count = ((upper(var.protocol) == "HTTP" || upper(var.protocol) == "HTTPS") && var.target_no_list_chk == true) ? 1 : 0
  target_group_no = ncloud_lb_target_group.tg_http[0].target_group_no
  target_no_list = [for target_no_list in var.target_no_list : target_no_list]
}

//// NLB&NPLB
resource "ncloud_lb_target_group_attachment" "tg_attach_tcp" {
  count = (upper(var.protocol) == "TCP" || upper(var.protocol) == "TLS") && (var.target_no_list_chk == true) ? 1 : 0
  target_group_no = ncloud_lb_target_group.tg_tcp[0].target_group_no
  target_no_list = [for target_no_list in var.target_no_list : target_no_list]
}
