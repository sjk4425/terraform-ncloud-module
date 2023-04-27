
// Naver Kubernetes Cluster 생성
resource "ncloud_nks_cluster" "cluster" {
  cluster_type                = var.cluster_type_map[var.cluster_type]
  k8s_version                 = data.ncloud_nks_versions.version.versions.0.value
  login_key_name              = var.loginkeyname
  name                        = var.k8s_name
  lb_private_subnet_no        = var.lb_private_subnet_id
  kube_network_plugin         = "cilium"
  subnet_no_list              = var.subnet_no_list
  vpc_no                      = var.vpc_no
  zone                        = var.zone
  log {
    audit = var.audit
  }
}

// Naver Kubernetes Node Pool 설정
resource "ncloud_nks_node_pool" "node_pool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_pool_name = "${var.k8s_name}-node"
  node_count     = var.node_count
  product_code   = data.ncloud_server_product.product.id
  subnet_no      = var.subnet_id
  autoscale {
    enabled = var.auto_scaling_enabled
    min = var.max
    max = var.min
  }
}



// 사용할 Naver Kubernetes Service 버전 확인
data "ncloud_nks_versions" "version" {
  filter {
    name = "value"
    values = ["${var.k8s_version}"]
    regex = true
  }
}


// NCloud에서 제공하는 서버 사양 탐색(Node Pool의 서버)

// 사용할 AMI 이미지 탐색
// 원하는 OS 필터
data "ncloud_server_image" "image" {
  filter {
    name = "os_information"
    values = ["${var.image_name}"]
  }
}

// 원하는 사양 필터
data "ncloud_server_product" "product" {
  server_image_product_code = data.ncloud_server_image.image.id 

  filter {
    name   = "product_code"
    values = ["SSD"]
    regex  = true
  }


  filter {
    name = "product_type"
    values = ["${var.product_type}"]
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