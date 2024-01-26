# output "azs" {
#   value = data.aws_availability_zones.roboshop_vpc_az.names
# }

# output "default_vpc_id" {
#   value = data.aws_vpc.default.id
# }

# output "default_routetable_id" {
#   value = data.aws_route_table.default.id
# }

output "vpc_id" {
  value = aws_vpc.roboshop-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.roboshop_public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.roboshop_private_subnets[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.roboshop_database_subnets[*].id
}