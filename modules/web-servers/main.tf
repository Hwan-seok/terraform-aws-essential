resource "aws_launch_configuration" "instance" {

  image_id        = "ami-007b7745d0725de95"
  instance_type   = var.instance_type
  security_groups = data.aws_security_groups.for_instance.ids
  key_name        = "terratest"

  iam_instance_profile = data.aws_iam_instance_profile.ec2_ecr_readonly.name


  user_data = templatefile(
    "${path.module}/start.tmpl",
    {
      region         = var.aws_region,
      server_port    = var.server_port,
      repository_url = data.aws_ecr_repository.repo.repository_url,
      image_version  = var.image_version
    }
  )

  # associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2_autocaling" {
  launch_configuration = aws_launch_configuration.instance.id
  vpc_zone_identifier  = data.aws_subnet_ids.public.ids

  #   availability_zones = data.aws_availability_zones.all.names

  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB"

  desired_capacity = 2
  min_size         = 2
  max_size         = 10
  force_delete     = true

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
