provider "aws" {
  region  = "ap-northeast-2"
  profile = "damin"
}


module "web_server_cluster" {
  source = "../../../modules/web-servers"

  vpc_id                      = data.aws_vpc.main.id
  security_group_instance_ids = data.aws_security_groups.for_instance.ids
  security_group_lb_ids       = data.aws_security_groups.for_lb.ids
  subnet_private_id_list      = data.aws_subnet_ids.private.ids
  subnet_public_id_list       = data.aws_subnet_ids.public.ids
}

