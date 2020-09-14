resource "aws_launch_configuration" "app_launch_configuration" {
  name_prefix   = "APP-LC"
  image_id      = aws_ami_from_instance.linux_ami.id
  instance_type = var.instance_type

  # user_data                   = ""
  associate_public_ip_address = false
  # iam_instance_profile        = aws_iam_instance_profile.app_instance_profile.name
  security_groups             = [aws_security_group.linux_servers_sg.id]
  key_name                    = var.key_name

  root_block_device {
    volume_size           = "60"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name_prefix          = "APP-SG"
  launch_configuration = aws_launch_configuration.app_launch_configuration.id
  vpc_zone_identifier  = [aws_subnet.us_east_2a_subnet_1.id, aws_subnet.us-east-2b-private_subnet.id]
  min_size             = "2"
  max_size             = "4"
  health_check_type    = "EC2"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  # alb_target_group_arn   = aws_lb_target_group.APP_TG.arn
  elb                    = aws_elb.linux_web_servers_elb.id
  #depends_on = [aws_autoscaling_group.app_asg]  => use when dependency not visible to terraform
}
