variable "server_port" {
}

variable "lb_listener_port" {
}

variable "ssh_port" {
  default = 22
}

variable "iogress_everywhere" {
  default = "0.0.0.0/0"
}


variable "subnet_public_cidr" {
}

variable "subnet_private_cidr" {
}

variable "protocol_any" {
  default = "-1"
}

variable "rds_ingress_port" {
}

variable "enable_nat" {
  type = bool
}
