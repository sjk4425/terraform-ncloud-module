// 생성한 Server ID 값 반환
output "server_id" {
  value = [ for server_id in ncloud_server.create_server : server_id.id ]
}
