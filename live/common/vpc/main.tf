provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source = "../../../modules/vpc"
}

module "vpn" {
  source = "../../../modules/vpn"

  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.subnet_public_id_list[0]

  depends_on = [module.vpc]
}
