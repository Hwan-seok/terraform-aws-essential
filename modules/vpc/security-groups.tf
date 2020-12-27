resource "aws_security_group" "sg_lb" {

  name   = "sg_lb"
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = [var.iogress_everywhere]
    from_port   = var.lb_listener_port
    to_port     = var.lb_listener_port
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = [var.iogress_everywhere]
    from_port   = 0
    to_port     = 0
    protocol    = var.protocol_any
  }

  depends_on = [aws_vpc.main]
}

resource "aws_security_group" "sg_instance" {
  name   = "sg_instance"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = [var.iogress_everywhere]
  }

  ingress {
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
  depends_on = [aws_vpc.main]

  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# resource "aws_security_group_rule" "sg_rule_egress_everywhere" {
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = [var.iogress_everywhere]
#   security_group_id = aws_security_group.instance_sg.id

#   lifecycle {
#     create_before_destroy = true
#   }
# }
