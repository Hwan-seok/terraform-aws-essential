
variable "lb_listener_port" {}

variable "forward_server_port" {}

variable "stages" {
  type = list(string)
}
