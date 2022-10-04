output "vpc_id" {
  value = aws_vpc.vpc.id
}


output "private_subnet1" {
  value = aws_subnet.private_subnet1.id
}


output "private_subnet2" {
  value = aws_subnet.private_subnet2.id
}

output "Public_Subnet1" {
  value = aws_subnet.Public_Subnet1.id
}


output "Public_Subnet2" {
  value = aws_subnet.Public_Subnet2.id
}
