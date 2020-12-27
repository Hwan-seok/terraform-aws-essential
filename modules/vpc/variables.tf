variable "server_port" {
  default = 8080
}


variable "ssh_port" {
  default = 22
}

variable "iogress_everywhere" {
  default = "0.0.0.0/0"
}

variable "lb_listener_port" {
  default = 80
}

variable "subnet_public_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "protocol_any" {
  default = "-1"
}
