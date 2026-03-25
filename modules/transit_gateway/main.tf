# Transit Gateway Module

resource "aws_ec2_transit_gateway" "this" {
  description = var.transit_gateway.description

  amazon_side_asn                 = var.transit_gateway.amazon_side_asn
  auto_accept_shared_attachments  = var.transit_gateway.auto_accept_shared_attachments
  default_route_table_association = var.transit_gateway.default_route_table_association
  default_route_table_propagation = var.transit_gateway.default_route_table_propagation
  dns_support                     = var.transit_gateway.dns_support
  vpn_ecmp_support                = var.transit_gateway.vpn_ecmp_support

  tags = {
    Name = var.transit_gateway.name
  }
}

# Route tables for each segment
resource "aws_ec2_transit_gateway_route_table" "segments" {
  for_each = toset(var.segments)

  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.transit_gateway.name}-${each.key}"
  }
}