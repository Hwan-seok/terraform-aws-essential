provider "aws" {
  region  = "ap-northeast-2"
  profile = "damin"
}


resource "aws_launch_configuration" "instance" {

  image_id        = "ami-007b7745d0725de95"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance-sg.id]
  key_name        = "terratest"


  user_data = <<-EOF
				#!/bin/bash
				echo "hello!!!" > index.html
				nohup busybox httpd -f -p ${var.server_port} &
				EOF

  # associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2_autocaling" {
  launch_configuration = aws_launch_configuration.instance.id
  vpc_zone_identifier  = aws_subnet.public.*.id

  #   availability_zones = data.aws_availability_zones.all.names

  target_group_arns = [aws_lb_target_group.lb_target_group.arn]
  health_check_type = "ELB"

  desired_capacity = 2
  min_size         = 2
  max_size         = 10

  tag {
    key                 = "Name"
    value               = "terraform-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "terra-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb" "alb" {
  name               = "terraform-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

# resource "aws_elb" "elb" {
#   name               = "terraform-elb"
#   availability_zones = data.aws_availability_zones.all.names
#   security_groups    = ["${aws_security_group.lb-sg.id}"]

#   listener {
#     lb_port           = var.lb_listener_port
#     lb_protocol       = "http"
#     instance_port     = var.server_port
#     instance_protocol = "http"
#   }
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     interval            = 30
#     target              = "HTTP:${var.server_port}/"
#   }
# }
