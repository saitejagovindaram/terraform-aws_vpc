resource "aws_vpc_peering_connection" "peering" {
    count = var.isPeeringRequired ? 1 : 0
    vpc_id = aws_vpc.roboshop-vpc.id
    peer_vpc_id = data.aws_vpc.default.id
    auto_accept = true

    tags = merge(
        var.common_tags,
        {
            Name = "${local.name}-peering"
        }
    )
}


resource "aws_route" "acceptor_route" {
    count = (var.isPeeringRequired && var.acceptor_vpc_id == "") ? 1 : 0
    route_table_id = data.aws_route_table.default.id
    destination_cidr_block = aws_vpc.roboshop-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "public" {
    count = (var.isPeeringRequired && var.acceptor_vpc_id == "") ? 1 : 0
    route_table_id = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "private" {
    count = (var.isPeeringRequired && var.acceptor_vpc_id == "") ? 1 : 0
    route_table_id = aws_route_table.private.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "database" {
    count = (var.isPeeringRequired && var.acceptor_vpc_id == "") ? 1 : 0
    route_table_id = aws_route_table.database.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}