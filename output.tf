# Output variable definitions
output "tags" {
  value = local.tags
}
output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet1" {
  value = aws_subnet.private1.cidr_block
}

output "private_subnet2" {
  value = aws_subnet.private2.cidr_block
}

output "public_subnet1" {
  value = aws_subnet.public1.cidr_block
}

output "public_subnet2" {
  value = aws_subnet.public2.cidr_block
}
