
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

data "aws_security_groups" "sg_rds" {
  tags = {
    Name = "for_rds_mysql"
  }
}
