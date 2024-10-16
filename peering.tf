resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_req ? 1 : 0
  peer_vpc_id   = local.vpc_id # requestor
  vpc_id        = data.aws_vpc.default.id
  auto_accept   = true

  tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}"
  }
  )
}

# private route
resource "aws_route" "private_peer_route" {
    count = var.is_peering_req ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}
# public  route
resource "aws_route" "public_peer_route" {
    count = var.is_peering_req ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}
# public  route
resource "aws_route" "default_peer_route" {
    count = var.is_peering_req ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}

