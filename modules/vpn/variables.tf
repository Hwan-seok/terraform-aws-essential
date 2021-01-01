
variable "protocol_any" {
  default = "-1"
}

variable "iogress_everywhere" {
  default = "0.0.0.0/0"
}

variable "ssh_port" {
  default = 22
}

variable "vpn_udp_port" {
  default = 10068
}

variable "public_subnet" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  type = string
}
