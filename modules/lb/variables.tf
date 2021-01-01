
variable "lb_listener_port" {}

variable "forward_server_port" {}

variable "connect_route53_zone_id" {
  type = string
}

variable "domain_name_stage_association" {
  type = map(map(string))
}
