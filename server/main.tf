// NIC 생성
resource "ncloud_network_interface" "nic" {
  count = var.create_num
  name                  = "nic-${var.server_name}-${count.index+1}"
  subnet_no             = var.subnet_id
  access_control_groups = var.access_control_groups
}


// Server 생성(기본 이미지)
resource "ncloud_server" "create_server" {
  count = var.create_num
  subnet_no                 = var.subnet_id
  name                      = "${var.server_name}-${count.index+1}"
  server_image_product_code = data.ncloud_server_image.image.id
  server_product_code       = data.ncloud_server_product.product.id
  description = var.server_description
  login_key_name            = var.loginkeyname
  is_protect_server_termination = var.is_protect_server_termination
  init_script_no = var.init_script_no
  network_interface {
    network_interface_no = ncloud_network_interface.nic[count.index].id
    order = 0
  }
}


// Block Storage 생성 및 장착
resource "ncloud_block_storage" "storage" {
  count = (var.size == "0") ? 0 : var.create_num
  server_instance_no = ncloud_server.create_server[count.index].id
  name = "${ncloud_server.create_server[count.index].name}-bs"
  size = var.size
  disk_detail_type = var.disk_detail_type
}


// Public IP 장착
resource "ncloud_public_ip" "public_ip" {
  count = (var.pubip == true) ? var.create_num : 0
  server_instance_no = ncloud_server.create_server[count.index].id
}


// 사용할 AMI 이미지 탐색
//// 원하는 OS 필터
data "ncloud_server_image" "image" {
  filter {
    name = "os_information"
    values = ["${var.image_name}"]
  }
}

// NCloud에서 제공하는 서버 사양 탐색
// 원하는 사양 필터
data "ncloud_server_product" "product" {
  server_image_product_code = data.ncloud_server_image.image.id 

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

