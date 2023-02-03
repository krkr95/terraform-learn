output "vpc_id" {
    value = aws_vpc.myapp_vpc.id
}
output "ec2_public_ip" {
    value = module.myapp-server.instance.public_ip
}
