/*
Generate Key-pair
*/
resource "aws_key_pair" "deployer" {
  key_name   = var.aws_key_name
  public_key = file(var.aws_key_path)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

/*
	Private Instance
*/
resource "aws_instance" "hive_private_1" {
    ami = data.aws_ami.ubuntu.id
    availability_zone = var.aws_availability_zone
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.nat.id]
    subnet_id = aws_subnet.hive-private.id
    associate_public_ip_address = false
    source_dest_check = false
	tags = {
		Name = "prod-web-server-1"
	}
	user_data     = <<-EOF
			  #!/bin/bash
			  sudo su
			  apt -y install apache2
			  echo "<p>Yakshup Goyal Hive Private - 1</p>" >> /var/www/html/index.html
			  sudo systemctl enable apache2
			  sudo systemctl restart apache2
			  EOF
}
resource "aws_instance" "hive_private_2" {
    ami = data.aws_ami.ubuntu.id
    availability_zone = var.aws_availability_zone
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.nat.id]
    subnet_id = aws_subnet.hive-private.id
    associate_public_ip_address = false
    source_dest_check = false
	tags = {
		Name = "prod-web-server-2"
	}
	user_data     = <<-EOF
			  #!/bin/bash
			  sudo su
			  apt -y install apache2
			  echo "<p>Yakshup Goyal Hive Private - 2</p>" >> /var/www/html/index.html
			  sudo systemctl enable apache2
			  sudo systemctl restart apache2
			  EOF

}