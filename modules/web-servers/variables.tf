variable "server_port" {
  default = 8080
}


variable "lb_listener_port" {
  default = 80
}

variable "vpc_id" {

}

variable "security_group_instance_ids" {

}

variable "security_group_lb_ids" {
  type = list(string)
}

variable "subnet_public_id_list" {

}
variable "subnet_private_id_list" {

}
