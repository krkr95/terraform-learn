resource "aws_vpc" "demo_vpc" {
    cidr_block = var.vpc_sub[0].cidr_block

    tags = {
        Name = var.vpc_sub[0].name
    }
}

resource "aws_subnet" "demo_subnet-1" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = var.vpc_sub[1].cidr_block
    availability_zone = var.azs[0]

    tags = {
        Name: var.vpc_sub[1].name
    }
}

data "aws_vpc" "existing_vpc" {
    id = aws_vpc.demo_vpc.id
}

resource "aws_subnet" "demo_subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = var.vpc_sub[2].cidr_block
    availability_zone = var.azs[1]

    tags = {
        Name: var.vpc_sub[1].name
    }
}

