output "azs" {
  value = data.aws_availability_zones.roboshop_vpc_az.names
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_routetable_id" {
  value = data.aws_route_table.default.id
}