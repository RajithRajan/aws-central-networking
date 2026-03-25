# Variables for AWS Central Networking with Transit Gateway

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "create_attachments_in_same_account" {
  description = "Whether to create VPC attachments in the same account as the transit gateway"
  type        = bool
  default     = true
}

variable "cross_account_providers" {
  description = "Map of account names to account configuration for cross-account attachments"
  type = map(object({
    account_id = string
    role_arn   = string
  }))
  default = {}
}

variable "transit_gateway" {
  description = "Transit Gateway configuration"
  type = object({
    name                     = string
    description              = optional(string)
    amazon_side_asn          = optional(number, 64512)
    auto_accept_shared_attachments = optional(string, "disable")
    default_route_table_association = optional(string, "enable")
    default_route_table_propagation = optional(string, "enable")
    dns_support               = optional(string, "enable")
    vpn_ecmp_support          = optional(string, "enable")
  })
  default = {
    name = "central-tgw"
  }
}

variable "segments" {
  description = "List of network segments, including 'shared' for the shared segment"
  type        = list(string)
  default     = ["shared", "segment1", "segment2"]
}

variable "vpc_attachments" {
  description = "List of VPC attachments"
  type = list(object({
    name          = string
    vpc_id        = string
    subnet_ids    = list(string)
    account_name  = optional(string)  # Name/key from cross_account_providers for cross-account
    segment       = string
    appliance_mode_support = optional(string, "disable")
    dns_support             = optional(string, "enable")
  }))
  default = []
}

variable "central_account_id" {
  description = "The account ID where the transit gateway is hosted"
  type        = string
}