resource "aws_vpc" "roboshop-vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(
      var.common_tags, 
      var.vpc_tags,
      {
        Name = local.name
      }
    )
}

resource "aws_internet_gateway" "roboshop-igw" { # You can attach only one internet gateway to a VPC at a time
  vpc_id = aws_vpc.roboshop-vpc.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
      Name = local.name
    }
  )
}

resource "aws_subnet" "roboshop_public_subnets" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.roboshop-vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.azones[count.index]
  # map_public_ip_on_launch = true
  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-public-${local.azones[count.index]}"
    }
  )
}

resource "aws_subnet" "roboshop_private_subnets" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.roboshop-vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.azones[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-private-${local.azones[count.index]}"
    }
  )
}

resource "aws_subnet" "roboshop_database_subnets" {
  count = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.roboshop-vpc.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.azones[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-database-${local.azones[count.index]}"
    }
  )
}

# AWS db subnet group?

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id = aws_subnet.roboshop_public_subnets[0].id

  tags = merge(
    var.common_tags,
    {
      Name = local.name
    }
  )

  depends_on = [aws_internet_gateway.roboshop-igw]
}
# creating route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.roboshop-vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.roboshop-vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.roboshop-vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-database"
    }
  )
}
# creating routes
resource "aws_route" "public-rt" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.roboshop-igw.id
}

resource "aws_route" "private-rt" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route" "database-rt" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "pubic" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.roboshop_public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  # subnet_id      = aws_subnet.roboshop_private_subnets[count.index].id  (or)
  subnet_id      = element(aws_subnet.roboshop_private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.roboshop_database_subnets[count.index].id
  route_table_id = aws_route_table.database.id
}