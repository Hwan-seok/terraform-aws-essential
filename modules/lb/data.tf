data "aws_vpc" "main" {
  tags = {
    Name = "terra_vpc"
  }
}

data "aws_security_groups" "for_lb" {
  tags = {
    Name = "for_lb"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "public"
  }
}
