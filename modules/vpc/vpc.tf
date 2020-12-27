resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "key"   = "Name"
    "value" = "terra-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.subnet_public_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_cidr[count.index]
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "key"   = "Name"
    "value" = "terra-public"
  }
}


resource "aws_internet_gateway" "i_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terra-ig"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.iogress_everywhere
    gateway_id = aws_internet_gateway.i_gw.id
  }

  tags = {
    Name = "terra-ig"
  }
}

resource "aws_main_route_table_association" "vpc_main_route_table" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.route_table.id
}
