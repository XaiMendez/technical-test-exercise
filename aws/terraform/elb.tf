resource "aws_elb" "linux_web_servers_elb" {
  name               = "webserverselb"

  security_groups = [
    "${aws_security_group.linux_servers_sg.id}"
  ]

   subnets = [aws_subnet.us_east_2a_subnet_1.id]


  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = [aws_instance.linux_webserver_01.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "linux_web_servers_elb"
  }
}
