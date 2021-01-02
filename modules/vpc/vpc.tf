resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terra_vpc"
  }
}

# --- 서브넷

resource "aws_subnet" "public" {
  count                   = length(var.subnet_public_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_cidr[count.index]
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}


resource "aws_subnet" "private" {
  count             = length(var.subnet_private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private_cidr[count.index]
  availability_zone = data.aws_availability_zones.all.names[count.index]

  tags = {
    Name = "private"
  }
}

# --- 퍼블릭 전용 라우팅 테이블

resource "aws_default_route_table" "for_public" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = var.iogress_everywhere
    gateway_id = aws_internet_gateway.i_gw.id
  }

  tags = {
    Name = "for-public"
  }
}

resource "aws_route_table_association" "for_public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_default_route_table.for_public.id
}

# --- 프라이빗 전용 라우팅 테이블

resource "aws_route_table" "for_private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.enable_nat ? [true] : []

    content {
      cidr_block     = var.iogress_everywhere
      nat_gateway_id = aws_nat_gateway.nat_gateway_for_private[0].id
    }
  }

  tags = {
    Name = "for-private"
  }
}

resource "aws_route_table_association" "for_private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.for_private.id
}

# --- 인터넷 게이트웨이
resource "aws_internet_gateway" "i_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terra-ig"
  }
}

# --- NAT 게이트웨이
resource "aws_nat_gateway" "nat_gateway_for_private" {
  count         = var.enable_nat ? 1 : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.private.0.id
}

resource "aws_eip" "nat_eip" {
  count = var.enable_nat ? 1 : 0
  vpc   = true
}
