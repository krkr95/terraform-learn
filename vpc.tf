resource "aws_vpc" "myapp_vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp_subnet-1" {
    vpc_id = aws_vpc.myapp_vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone

    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp_igw" {
    vpc_id = aws_vpc.myapp_vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

# resource "aws_route_table" "myapp_route_table" {
#     vpc_id = aws_vpc.myapp_vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.myapp_igw.id
#     }
#     tags = {
#         Name: "${var.env_prefix}-rtb"
#     }
# }

# resource "aws_route_table_association" "a-rtb-subnet" {
#     subnet_id = aws_subnet.myapp_subnet_1.id
#     route_table_id = aws_route_table.myapp_route_table.id
# }

resource "aws_default_route_table" "main_rtb" {
    default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp_igw.id
    }
    tags = {
        Name: "${var.env_prefix}-main-rtb"
    }
}

resource "aws_default_security_group" "default_sg" {
    vpc_id = aws_vpc.myapp_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-main-sg"
    }
}

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

# resource "aws_key_pair" "ssh_key" {
#     key_name = "test-key"
#     public_key = "${file(var.public_key_loacation)}"
# }

resource "aws_instance" "myapp_server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.myapp_subnet-1.id
    vpc_security_group_ids = [aws_default_security_group.default_sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = var.key_name
    
    
    # user_data = <<EOF
    #                 #!/bin/bash
    #                 sudo yum update -y
    #                 sudo yum install docker -y
    #                 sudo systemctl start docker
    #                 sudo usermod -aG docker ec2-user
    #                 docker run -p 8080:80 nginx
    #             EOF

    user_data = file("entry-script.sh")

    tags = {
        Name: "${var.env_prefix}-server"
    }
}
