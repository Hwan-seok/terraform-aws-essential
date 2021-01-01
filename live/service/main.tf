provider "aws" {
  region  = local.provider.region
  profile = local.provider.profile
}

locals {
  provider = {
    region  = "ap-northeast-2"
    profile = "terraform"
  }
  route53_zone_id = "Z08511822BCBN7HAEPLU2"
  environment = {
    dev = {
      image_version = "dev-0.0.1",
      domain_name   = "devapi.hwan.tech",
    },
    stage = {
      image_version = "stage-0.0.1",
      domain_name   = "stgapi.hwan.tech",
    },
    real = {
      image_version = "real-0.0.1"
      domain_name   = "api.hwan.tech"
    }
  }
  server_port = 4000
}

module "alb" {
  source = "../../modules/lb"

  lb_listener_port    = 80
  forward_server_port = local.server_port

  connect_route53_zone_id = local.route53_zone_id

  domain_name_stage_association = local.environment
}

module "domain" {
  for_each = local.environment
  source   = "../../modules/route53"

  connect_route53_zone_id = local.route53_zone_id
  domain_name             = each.value.domain_name
  lb_dns_name             = module.alb.alb_dns_name
  lb_zone_id              = module.alb.alb_zone_id
}

module "web_server_cluster" {
  for_each = local.environment
  source   = "../../modules/web-servers"

  instance_type = "t3a.medium"

  server_port      = local.server_port
  repository_name  = "repo"
  image_version    = each.value.image_version
  target_group_arn = module.alb.alb_target_group_arns[each.key].arn

  aws_region = local.provider.region
  stage      = each.key
}
