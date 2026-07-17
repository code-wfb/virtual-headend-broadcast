output "vpc_id" { value = aws_vpc.main.id }
output "private_subnets" { value = aws_subnet.private[*].id }
output "public_subnets" { value = aws_subnet.public[*].id }
output "transit_gateway_id" { value = aws_ec2_transit_gateway.tgw.id }