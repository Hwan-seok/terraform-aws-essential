provider "aws" {
  region  = "ap-northeast-2"
  profile = "damin"
}


module "vpc" {
  source = "../../../modules/vpc"
}

module "web_server_cluster" {
  source = "../../../modules/web-servers"

  vpc_id                     = module.vpc.vpc_id
  security_group_instance_id = module.vpc.security_group_instance_id
  security_group_lb_id       = module.vpc.security_group_lb_id
  subnet_public_id_list      = module.vpc.subnet_public_id_list
}


