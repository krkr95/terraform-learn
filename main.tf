resource "aws_vpc" "myapp_vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp_vpc.id
    default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}

module "myapp-server" {
    source = "./modules/webserver"
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp_vpc.id
    image_name = var.image_name
    my_ip = var.my_ip
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = module.myapp-subnet.subnet.id
}
