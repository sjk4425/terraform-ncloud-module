// Load Balancer 생성
resource "ncloud_lb" "create_lb" {
  name = var.lb_name
  network_type = upper(var.lb_network_type)
  type = upper(var.lb_type)
  subnet_no_list = var.subnet_no_list
  throughput_type = var.throughput_type
  description = var.lb_description
}


// Load Balancer Listener 설정(SSL 인증서 미사용)
//// ALB용 Listener(HTTP)
resource "ncloud_lb_listener" "set_lb_listener_http" {
  count = (upper(var.listener_protocol) == "HTTP") ? 1 : 0
  load_balancer_no = ncloud_lb.create_lb.load_balancer_no
  protocol = upper(var.listener_protocol)
  port = var.listener_port
  target_group_no = var.target_group_no
}

//// NPLB&NLB용 Listener
resource "ncloud_lb_listener" "set_lb_listener_tcp" {
  count = (upper(var.listener_protocol) == "TCP") ? 1 : 0
  load_balancer_no = ncloud_lb.create_lb.load_balancer_no
  protocol = upper(var.listener_protocol)
  port = var.listener_port
  target_group_no = var.target_group_no
}


//// ALB용 Listener(HTTPS)
resource "ncloud_lb_listener" "set_lb_listener_https" {
  count = (upper(var.listener_protocol) == "HTTPS") ? 1 : 0
  load_balancer_no = ncloud_lb.create_lb.load_balancer_no
  protocol = upper(var.listener_protocol)
  port = var.listener_port
  target_group_no = var.target_group_no
  ssl_certificate_no = var.certificate_no
  tls_min_version_type = var.tls_min_version_type
}


//// NPLB용 Listener(TLS)
resource "ncloud_lb_listener" "set_lb_listener_nplbs" {
  count = (upper(var.listener_protocol) == "TLS") ? 1 : 0
  load_balancer_no = ncloud_lb.create_lb.load_balancer_no
  protocol = upper(var.listener_protocol)
  port = var.listener_port
  target_group_no = var.target_group_no
  ssl_certificate_no = var.certificate_no
  tls_min_version_type = var.tls_min_version_type
}
