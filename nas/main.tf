// NAS 생성 및 접근제어 설정
resource "ncloud_nas_volume" "create-nas" {
    volume_name_postfix            = var.volume_name_postfix
    volume_size                    = var.volume_size
    volume_allotment_protocol_type = upper(var.volume_allotment_protocol_type)
    server_instance_no_list = var.server_instance_no_list
}