resource "aws_launch_configuration" "instance" {

  image_id        = "ami-007b7745d0725de95"
  instance_type   = "t2.micro"
  security_groups = var.security_group_instance_ids
  key_name        = "terratest"


  user_data = templatefile(
    "${path.module}/start.tmpl",
    { server_port = var.server_port }
  )

  # associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2_autocaling" {
  launch_configuration = aws_launch_configuration.instance.id
  vpc_zone_identifier  = var.subnet_private_id_list

  #   availability_zones = data.aws_availability_zones.all.names

  target_group_arns = [aws_lb_target_group.lb_target_group.arn]
  health_check_type = "ELB"

  desired_capacity = 2
  min_size         = 2
  max_size         = 10

  tag {
    key                 = "Name"
    value               = "terraform-instance-${var.stage}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg_policy" {
  name = "asg_policy"
  # scaling_adjustment = 2
  policy_type     = "TargetTrackingScaling"
  adjustment_type = "ChangeInCapacity"
  # cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.ec2_autocaling.name


  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "terra-target-group-${var.stage}"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb" "alb" {
  name               = "terraform-alb-${var.stage}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_lb_ids
  subnets            = var.subnet_public_id_list

  tags = {
    Name = "lb-${var.stage}"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.lb_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
