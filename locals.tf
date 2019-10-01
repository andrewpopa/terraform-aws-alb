locals {
  http_tcp_listeners_count = 2

  http_tcp_listeners = [
    {
      "port"               = 8800
      "protocol"           = "HTTPS"
      "target_group_index" = 0
    },
    {
      "port"               = 443
      "protocol"           = "HTTPS"
      "target_group_index" = 1
    },
  ]

  target_groups_count = 2

  target_groups = [
    {
      "name"             = "frontend"
      "backend_protocol" = "HTTPS"
      "backend_port"     = 8800
    },
    {
      "name"             = "backend"
      "backend_protocol" = "HTTPS"
      "backend_port"     = 443
    },
  ]
}