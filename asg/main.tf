// Auto Scaling Group Configuration 생성
resource "ncloud_launch_configuration" "lc" {
  name = var.asg_conf_name
  member_server_image_no = data.ncloud_member_server_image.custom_image.id
  server_product_code = data.ncloud_server_product.product.id
  init_script_no = var.init_script_no
  login_key_name = var.login_key_name
}

// Auto Scaling Group 생성
//// Health Check Type이 Server일 경우
resource "ncloud_auto_scaling_group" "auto_svr" {
  count = (var.health_check_type_code == "SVR") ? 1 : 0
  name = var.asg_name
  access_control_group_no_list = var.access_control_groups
  subnet_no = var.subnet_no
  launch_configuration_no = ncloud_launch_configuration.lc.launch_configuration_no
  min_size = var.min_size
  max_size = var.max_size
  health_check_type_code = var.health_check_type_code
  health_check_grace_period = var.health_check_grace_period
  server_name_prefix = var.server_name_prefix
}

//// Health Check Type이 LB일 경우
resource "ncloud_auto_scaling_group" "auto_loadb" {
  count = (var.health_check_type_code == "LOADB") ? 1 : 0
  name = var.asg_name
  access_control_group_no_list = var.access_control_groups
  subnet_no = var.subnet_no
  launch_configuration_no = ncloud_launch_configuration.lc.launch_configuration_no
  min_size = var.min_size
  max_size = var.max_size
  health_check_type_code = var.health_check_type_code
  health_check_grace_period = var.health_check_grace_period
  target_group_list = var.target_group_list
  server_name_prefix = var.server_name_prefix
}

// Auto Scaling Group 정책 설정
//// Server용 ASG 정책 설정
resource "ncloud_auto_scaling_policy" "asg-policy-svr" {
  count = (var.policy_chk == true && var.health_check_type_code == "SVR") ? 1 : 0
  name = var.policy_name
  adjustment_type_code = upper(var.adjustment_type_code)
  scaling_adjustment = var.scaling_adjustment 
  auto_scaling_group_no = ncloud_auto_scaling_group.auto_svr[0].auto_scaling_group_no
}

//// LB용 ASG 정책 설정(HTTP, HTTPS)
resource "ncloud_auto_scaling_policy" "asg-policy" {
  count = (var.policy_chk == true && var.health_check_type_code == "LOADB") ? 1 : 0
  name = var.policy_name
  adjustment_type_code = upper(var.adjustment_type_code)
  scaling_adjustment = var.scaling_adjustment 
  auto_scaling_group_no = ncloud_auto_scaling_group.auto_loadb[0].auto_scaling_group_no
}

// Auto Scaling Group 일정 설정
//// Server용 ASG 일정 설정
resource "ncloud_auto_scaling_schedule" "schedule-svr" {
  count = (var.policy_chk == false && var.health_check_type_code == "SVR") ? 1 : 0
  name = var.policy_name
  min_size = var.schdule_min_size
  max_size = var.schdule_max_size
  desired_capacity = var.schdule_desired_capacity
  start_time = var.start_time # 2021-02-02T15:00:00+0900
  end_time = var.end_time # 2021-02-02T17:00:00+0900
  recurrence = var.recurrence
  auto_scaling_group_no = ncloud_auto_scaling_group.auto_svr[0].auto_scaling_group_no
}

//// LB용 ASG 일정 설정(HTTP, HTTPS)
resource "ncloud_auto_scaling_schedule" "schedule-loadb" {
  count = (var.policy_chk == false && var.health_check_type_code == "LOADB") ? 1 : 0
  name = var.policy_name
  min_size = var.schdule_min_size
  max_size = var.schdule_max_size
  desired_capacity = var.schdule_desired_capacity
  start_time = var.start_time # 2021-02-02T15:00:00+0900
  end_time = var.end_time # 2021-02-02T17:00:00+0900
  recurrence = var.recurrence
  auto_scaling_group_no = ncloud_auto_scaling_group.auto_loadb[0].auto_scaling_group_no
}

// 사용자 이미지 선택
data "ncloud_member_server_image" "custom_image" {
  filter {
    name = "name"
    values = ["${var.image_name}"]
  }
}


// NCloud에서 제공하는 서버 사양 탐색
// 원하는 사양 필터
data "ncloud_server_product" "product" {
  server_image_product_code = data.ncloud_member_server_image.custom_image.original_server_image_product_code
  
  filter {
    name = "product_type"
    values = ["${var.product_type}"]
  }

  filter {
    name   = "product_code"
    values = ["${var.product_code}"]
    regex  = true
  }

  filter {
    name   = "cpu_count"
    values = ["${var.cpu_count}"] 
  }

  filter {
    name   = "memory_size"
    values = ["${var.memory_size}GB"] 
  }

}

