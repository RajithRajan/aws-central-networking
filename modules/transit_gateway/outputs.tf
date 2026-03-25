# Outputs for Transit Gateway Module

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}

output "route_tables" {
  description = "Map of segment names to route table IDs"
  value       = { for k, v in aws_ec2_transit_gateway_route_table.segments : k => v.id }
}