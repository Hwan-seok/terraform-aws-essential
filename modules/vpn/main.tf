resource "aws_instance" "vpn" {
  ami           = "ami-007b7745d0725de95"
  instance_type = "t2.micro"

  subnet_id              = var.public_subnet
  vpc_security_group_ids = [aws_security_group.sg_vpn.id]

  key_name = var.key_name

  user_data = file("${path.module}/init-vpn.sh")

  tags = {
    Name = "vpn"
  }

  depends_on = [aws_security_group.sg_vpn]
}

resource "aws_eip" "vpn" {
  vpc = true
}

resource "aws_eip_association" "vpn" {
  instance_id   = aws_instance.vpn.id
  allocation_id = aws_eip.vpn.id
}


resource "aws_security_group" "sg_vpn" {
  name   = "sg_vpn"
  vpc_id = var.vpc_id

  ingress {
    description = "UDP for vpn"
    from_port   = var.vpn_udp_port
    to_port     = var.vpn_udp_port
    protocol    = "udp"
    cidr_blocks = [var.iogress_everywhere]
  }

  ingress {
    description = "ssh from admin - only enable when nessesary"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.iogress_everywhere]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = var.protocol_any
    cidr_blocks = [var.iogress_everywhere]
  }

  tags = {
    Name = "sg_vpn"
  }
}
