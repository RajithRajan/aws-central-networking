# VPC Attachment Module

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.attachment_config.vpc_id
  subnet_ids         = var.attachment_config.subnet_ids

  appliance_mode_support = var.attachment_config.appliance_mode_support
  dns_support             = var.attachment_config.dns_support

  tags = {
    Name = var.attachment_config.name
  }
}

# Associate with the route table for the segment
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = var.route_tables[var.attachment_config.segment]
}

# Propagations
# If segment is "shared", propagate to all other route tables
resource "aws_ec2_transit_gateway_route_table_propagation" "shared_to_others" {
  for_each = var.attachment_config.segment == "shared" ? { for k, v in var.route_tables : k => v if k != "shared" } : {}

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = each.value
}

# If segment is not "shared", propagate to "shared" if it exists
resource "aws_ec2_transit_gateway_route_table_propagation" "others_to_shared" {
  count = var.attachment_config.segment != "shared" && contains(keys(var.route_tables), "shared") ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = var.route_tables["shared"]
}