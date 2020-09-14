resource "aws_instance" "linux_webserver_01" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  availability_zone = element(var.az_names, 0)

  tags = {
    Name = "linux_webserver_01"
  }

  vpc_security_group_ids = [aws_security_group.linux_servers_sg.id]
  subnet_id              = aws_subnet.us_east_2a_subnet_1.id
}

resource "aws_ami_from_instance" "linux_ami" {
  name               = "linux_ami_apache"
  source_instance_id = aws_instance.linux_webserver_01.id
}
