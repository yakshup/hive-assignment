/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
    name = "prod-web-servers-sg"
    description = "Allow traffic to pass from the private subnet to the internet"
	ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = aws_default_vpc.default.id
}


/*
  Private Subnet
*/
resource "aws_subnet" "hive-private" {
    vpc_id = aws_default_vpc.default.id

    cidr_block = var.private_subnet_cidr
    availability_zone = var.aws_availability_zone
}

resource "aws_route_table" "hive-private" {
    vpc_id = aws_default_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
	/*
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = aws_instance.hive_private_1.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = aws_instance.hive_private_2.id
    }*/
}

resource "aws_route_table_association" "hive-private" {
    subnet_id = aws_subnet.hive-private.id
    route_table_id = aws_route_table.hive-private.id
}

resource "aws_internet_gateway" "gw" {
	vpc_id = aws_default_vpc.default.id
}