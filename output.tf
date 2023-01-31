output "vpc_id" {
    value = aws_vpc.myapp_vpc.id
}
output "subnet-1" {
    value = aws_subnet.myapp_subnet-1.id
}
output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}
output "ec2_public_ip" {
    value = aws_instance.myapp_server.public_ip
}
