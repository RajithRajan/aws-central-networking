# Outputs

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_id
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_arn
}

output "route_tables" {
  description = "Map of segment names to route table IDs"
  value       = module.transit_gateway.route_tables
}

output "vpc_attachment_ids" {
  description = "List of VPC attachment IDs"
  value       = module.vpc_attachments[*].attachment_id
}

output "cross_account_info" {
  description = "Information about cross-account providers"
  value = {
    for name, config in var.cross_account_providers : name => {
      account_id = config.account_id
      provider_alias = "account_${name}"
    }
  }
}