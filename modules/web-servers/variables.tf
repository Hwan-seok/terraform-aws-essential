variable "server_port" {
  default = 8080
}
variable "image_version" {
}

variable "stage" {
  type = string
}

variable "aws_region" {}

variable "instance_type" {}

variable "repository_name" {}

variable "target_group_arn" {}
