// 생성한 Target Group ID 값 반환
output "target_group_no"{
    value = length(ncloud_lb_target_group.tg_http) > 0 ? ncloud_lb_target_group.tg_http[0].target_group_no : ncloud_lb_target_group.tg_tcp[0].target_group_no
}