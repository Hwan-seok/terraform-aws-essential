provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source = "../../modules/vpc"

  subnet_public_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_private_cidr = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  server_port      = 4000
  lb_listener_port = 80
  rds_ingress_port = 3306
}

module "vpn" {
  source = "../../modules/vpn"

  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.subnet_public_id_list[0]

  key_name = "terratest"

  depends_on = [module.vpc]
}


module "ecr" {
  source = "../../modules/ecr"
}
