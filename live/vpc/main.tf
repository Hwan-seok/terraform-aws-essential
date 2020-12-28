provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source = "../../modules/vpc"
}

module "vpn" {
  source = "../../modules/vpn"

  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.subnet_public_id_list[0]

  depends_on = [module.vpc]
}

module "web_server_cluster_dev" {
  source = "../../modules/web-servers"

  vpc_id                      = module.vpc.vpc_id
  security_group_instance_ids = [module.vpc.security_group_instance_id]
  security_group_lb_ids       = [module.vpc.security_group_lb_id]

  subnet_public_id_list  = module.vpc.subnet_public_id_list
  subnet_private_id_list = module.vpc.subnet_private_id_list

  stage = "dev"

  depends_on = [module.vpc]
}

module "web_server_cluster_stage" {
  source = "../../modules/web-servers"

  vpc_id                      = module.vpc.vpc_id
  security_group_instance_ids = [module.vpc.security_group_instance_id]
  security_group_lb_ids       = [module.vpc.security_group_lb_id]

  subnet_public_id_list  = module.vpc.subnet_public_id_list
  subnet_private_id_list = module.vpc.subnet_private_id_list

  stage      = "stage"
  depends_on = [module.vpc]
}

module "web_server_cluster_real" {
  source = "../../modules/web-servers"

  vpc_id                      = module.vpc.vpc_id
  security_group_instance_ids = [module.vpc.security_group_instance_id]
  security_group_lb_ids       = [module.vpc.security_group_lb_id]

  subnet_public_id_list  = module.vpc.subnet_public_id_list
  subnet_private_id_list = module.vpc.subnet_private_id_list

  stage      = "real"
  depends_on = [module.vpc]
}

