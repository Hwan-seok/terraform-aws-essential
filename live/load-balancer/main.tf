provider "aws" {
  region  = var.region
  profile = var.profile
}

module "alb" {
  source = "../../modules/lb"

  lb_listener_port    = 80
  forward_server_port = 8080

  stages = ["dev", "stage", "real"]
}
