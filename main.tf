#####################################
######일반적인 Server 및 LB 생성 예시#######
#####################################
// VPC 생성
module "vpc" {
  // vpc 모듈 사용
  source = "./vpc"
  vpc_cidr_block = "172.16.0.0/16"
  vpc_name = "ksj-terraform-vpc"
}

/*
// natgw 생성
module "ngw" {
  // ngw 모듈 사용
  source = "./natgw"
  vpc_no = module.vpc.vpc_no
  natgw_name = "ngw-ksj-terraform"
  zone = "KR-2"
}
*/

// Public Subnet(WEB) 생성
module "sub-web-dev" {
  // subnet 모듈 사용
  source = "./subnet"
  vpc_no = module.vpc.vpc_no
  zone = "KR-2"
  subnet_name = "sub-pub-web-dev"
  subnet_type = "public"
  subnet_CIDR = "172.16.200.0/24"
}

module "sub-lb-web-dev" {
  // subnet 모듈 사용
  source = "./subnet"
  vpc_no = module.vpc.vpc_no
  zone = "KR-2"
  subnet_name = "lb-web-dev"
  subnet_type = "private"
  subnet_CIDR = "172.16.230.0/24"
  usage_type = "LOADB"

  // route table 설정(NAT Gateway 라우팅)
  # route_table_no = module.ngw.route_table_no
}


// Application LoadBalancer 생성(HTTPS)
//// Target Group 생성
module "lb-web-dev-tg" {
  // targetgroup 모듈 사용
  source = "./targetgroup"

  vpc_no = module.vpc.vpc_no
  protocol = "HTTP"
  port = 80
  tg_name = "lb-web-dev-tg"

  // health check
  health_check_protocol = "HTTP"
  health_check_port = 80
  algorithm_type = "RR"
  // health check(HTTP,HTTPS) 전용
  http_method = "GET"
  url_path = "/"


  // Target Group 내 Target 서버 추가
  target_no_list_chk = true
  target_no_list = module.sv-web-dev.server_id
}

//// Application Load Balancer 생성(HTTPS)
module "lb-web-dev" {
  // lb 모듈 이용
  source = "./lb"

  // Load Balancer 생성
  lb_name = "lb-web-dev"
  lb_network_type = "public"
  lb_type = "application"
  subnet_no_list = [ module.sub-lb-web-dev.subnet_no ]
  target_group_no = module.lb-web-dev-tg.target_group_no
  lb_description = "개발 WEB 서버용 ALB"
  listener_protocol = "HTTPS"
  listener_port = "443"
  certificate_no = "15127"
}

// Application LoadBalancer 생성(HTTP)
//// Target Group 생성
/*
module "lb-web-dev-tg" {
  // targetgroup 모듈 사용
  source = "./targetgroup"

  // Target Group 설정
  vpc_no = module.vpc.vpc_no
  protocol = "HTTP"
  port = 80
  tg_name = "lb-web-dev-tg"

  // health check
  health_check_protocol = "HTTP"
  health_check_port = 80
  algorithm_type = "RR"
  // health check(HTTP,HTTPS) 전용
  http_method = "GET"
  url_path = "/"

  // Target Group 내 Target 서버 추가
  target_no_list_chk = true
  target_no_list = module.sv-web-dev.server_id
}
*/

//// Application Load Balancer 생성(HTTP)
/*
module "lb-web-dev" {
  // lb 모듈 이용
  source = "./lb"

  // Load Balancer 생성
  lb_name = "lb-web-dev"
  lb_network_type = "public"
  lb_type = "application"
  subnet_no_list = [ module.sub-lb-web-dev.subnet_no ]
  target_group_no = module.lb-web-dev-tg.target_group_no
  lb_description = "개발 WEB 서버용 ALB"
}
*/


// Network LoadBalancer
//// Target Group 생성
module "lb-web-dev-tg" {
  // targetgroup 모듈 사용
  source = "./targetgroup"
  
  // Target Group 설정
  vpc_no = module.vpc.vpc_no
  protocol = "TCP"
  port = 8080
  tg_name = "lb-was-dev-tg"

  // health check
  health_check_protocol = "TCP"
  health_check_port = 8080
  algorithm_type = "RR"


  // Target Group 내 Target 서버 추가
  target_no_list_chk = true
  target_no_list = module.sv-web-dev.server_id
}
*/

//// Network Load Balancer 생성(TCP)
/*
module "lb-was-dev" {
  // lb 모듈 이용
  source = "./lb"

  // Network Load Balancer 생성
  lb_name = "lb-was-dev"
  lb_network_type = "private"
  lb_type = "network"
  subnet_no_list = [ module.sub-lb-was-dev.subnet_no ]
  target_group_no = module.lb-web-dev-tg.target_group_no
  lb_description = "개발 WAS 서버용 NLB"
  listener_protocol = "TCP"
}
*/

// ACG 생성(WEB)
module "acg-web-dev" {
  // ACG 모듈 이용
  source = "./acg"
  vpc_no = module.vpc.vpc_no
  acg_name = "acg-web-dev"
  acg_description = "개발용 WEB 서버용 ACG"
}


// ACG Rule 생성(DB, IPBlock)
module "acg-web-dev-rule-ipblock" {
  source = "./acgrule"
  access_control_group_no = module.acg-web-dev.acg_id
  ipblock_chk = true
  
  acg_rule_inbound = [
    ["TCP", "0.0.0.0/0", "22", "SSH Port"],
    ["TCP", "172.16.230.0/24", "80", "HTTP Port"],
  ]
}

// Login Key 생성
module "loginkey" {
  // pem key 생성
  source = "./loginkey"
  key_name = "ksj-test-key"
}

// Server & NIC 생성
// WEB 서버(개발)
module "sv-web-dev" {
  // Server 모듈 이용
  # source = "./server_img"
  source = "./server"
  server_name = "sv-web-dev-test"
  subnet_id = module.sub-web-dev.subnet_no
  server_description = "개발용 WEB 서버"

  // NIC 생성
  access_control_groups = [ module.acg-web-dev.acg_id ]

  // 서버 사양선택
  product_type = "HICPU"
  product_code = "SSD"
  create_num = "1"
  cpu_count = "2"
  memory_size = "4"
  image_name = "CentOS 7.8 (64-bit)"
  #image_name = "img-web-dev"
  // Login Key 선택
  loginkeyname = module.loginkey.key_name

  // Public IP 장착
  pubip = true

  /*
  // Block Storage 장착
  disk_detail_type = "SSD"
  size = "50"
  */
}

########################################
#######Auto Scaling Group 예시(LB)#######
########################################
//// Public Subnet(LB-auth) 생성
module "lb-auth" {
  // subnet 모듈 사용
  source = "./subnet"
  vpc_no = module.vpc.vpc_no
  zone = "KR-2"
  subnet_name = "lb-auth"
  subnet_type = "private"
  subnet_CIDR = "172.16.20.0/24"
  usage_type = "LOADB"
}

// ACG 설정
//// ACG 생성(Auth)
module "acg-auth" {
  // ACG 모듈 이용
  source = "./acg"
  vpc_no = module.vpc.vpc_no
  acg_name = "acg-test"
  acg_description = "test 서버 용 ACG"
}


// Subnet 생성
//// Private Subnet(auth) 생성(SGN-4)
module "sub-auth-1" {
  // subnet 모듈 사용
  source = "./subnet"
  vpc_no = module.vpc.vpc_no
  zone = "KR-2"
  subnet_name = "sub-auth-1"
  subnet_type = "public"
  subnet_CIDR = "172.16.0.0/24"

  // route table 설정(NAT Gateway 라우팅)
  // route_table_no = module.ngw.route_table_no
}



// Auto Scaling Group 생성
//// Target Group 생성
module "lb-asg-tg" {
  // lb 모듈 이용
  source = "./targetgroup"

  // Target Group 설정
  vpc_no = module.vpc.vpc_no
  protocol = "HTTP"
  port = 80
  tg_name = "lb-web-dev-tg"

  // health check
  health_check_protocol = "HTTP"
  health_check_port = 80
  algorithm_type = "RR"

  // health check(HTTP,HTTPS) 전용
  http_method = "GET"
  url_path = "/"

  // Target Group 내 Target 서버 추가 여부
  target_no_list_chk = false

}


// Auto Scaling Group 생성(정책설정 예시)
module "world1-asg-lb" {
  source = "./asg"
  asg_conf_name = "test-asg-lb-conf"
  image_name = "ksj-test-img"
  login_key_name = "ksj-key-test2"
  product_type = "HICPU"
  cpu_count = "2"
  memory_size = "4"
  product_code = "SSD"
  asg_name = "world1-asg"
  subnet_no = module.sub-auth-1.subnet_no
  access_control_groups = [ module.acg-auth.acg_id ]
  min_size = 1
  max_size = 1
  health_check_type_code = "LOADB"
  server_name_prefix = "test"

  // 정책 설정
  # policy_name = "asg-policy"
  # target_group_list = [ module.lb-asg-tg.target_group_no ]
  # scaling_adjustment = "2"

  // 일정 설정
  policy_chk = false
  policy_name = "asg-schedule"
  schdule_min_size = 1
  schdule_max_size = 1
  # start_time = "2023-04-01T09:00:00+0900"
  # end_time = "2025-04-01T09:00:00+0900"
  recurrence = "0 18 * * 1-5"
  schdule_desired_capacity = 1
  target_group_list = [ module.lb-asg-tg.target_group_no ]
}


// lb 생성
module "lb-asg" {
  source = "./lb"
  lb_name = "lb-web-dev"
  lb_network_type = "public"
  lb_type = "application"
  subnet_no_list = [ module.lb-auth.subnet_no ]
  target_group_no = module.lb-asg-tg.target_group_no
  lb_description = "ASG 테스트용 ALB"
}
