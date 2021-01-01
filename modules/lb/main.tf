resource "aws_lb" "alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = data.aws_security_groups.for_lb.ids
  subnets            = data.aws_subnet_ids.public.ids

  tags = {
    Name = "lb-ingress"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.lb_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["real"].arn
  }
}

resource "aws_lb_listener_rule" "rule" {
  for_each     = var.domain_name_stage_association
  listener_arn = aws_lb_listener.alb_listener.arn
  # priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.domain_name]
    }
  }
}

resource "aws_lb_target_group" "tg" {
  for_each = var.domain_name_stage_association
  name     = "${each.key}-${substr(uuid(), 0, 3)}"
  port     = var.forward_server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    stage = each.key
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}
