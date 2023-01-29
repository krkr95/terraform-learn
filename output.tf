output "vpc_id" {
    value = aws_vpc.demo_vpc.id
}
output "subnet-1" {
    value = aws_subnet.demo_subnet-1.id
}
output "subnet-2" {
    value = aws_subnet.demo_subnet-2.id
}
