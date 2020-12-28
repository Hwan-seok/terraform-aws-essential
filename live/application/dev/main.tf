provider "aws" {
  region  = var.region
  profile = var.profile
}

module "web_server_cluster" {
  source = "../../../modules/web-servers"

  stage = var.stage
}

module "ecr" {
  source = "../../../modules/ecr"
  stage  = var.stage
}
