# Main Terraform configuration for AWS Central Networking

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider for central account
provider "aws" {
  region = var.region
}

# Cross-account providers are generated in providers.tf by the generate_providers.sh script

# Transit Gateway module
module "transit_gateway" {
  source = "./modules/transit_gateway"

  transit_gateway = var.transit_gateway
  segments        = var.segments
}

# VPC Attachments
module "vpc_attachments" {
  source = "./modules/vpc_attachment"
  count  = length(var.vpc_attachments)

  attachment_config = var.vpc_attachments[count.index]
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  route_tables      = module.transit_gateway.route_tables

  # For cross-account, use the appropriate provider alias
  providers = {
    aws = var.vpc_attachments[count.index].account_name != null ? aws["account_${var.vpc_attachments[count.index].account_name}"] : aws
  }
}