locals {
  name = "${var.project_name}-${var.environment}"
  azones = slice(data.aws_availability_zones.roboshop_vpc_az.names, 0, 2)
}

