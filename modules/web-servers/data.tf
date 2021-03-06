data "aws_vpc" "main" {
  tags = {
    Name = "terra_vpc"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "private"
  }
}
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "public"
  }
}

data "aws_security_groups" "for_lb" {
  tags = {
    Name = "for_lb"
  }
}

data "aws_security_groups" "for_instance" {
  tags = {
    Name = "for_instance"
  }
}

# data "aws_lb_target_group" "lb_target_group" {
#   name = "terra-target-group-${var.stage}"
# }


data "aws_ecr_repository" "repo" {
  name = var.repository_name
}

data "aws_iam_instance_profile" "ec2_ecr_readonly" {
  name = "ec2_ecr_readonly"
}
