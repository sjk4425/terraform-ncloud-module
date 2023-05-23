resource "ncloud_init_script" "init" {
  name    = var.init_name
  content = file("${var.file_name}")
}