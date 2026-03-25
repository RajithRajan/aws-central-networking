# Variables for VPC Attachment Module

variable "attachment_config" {
  description = "Configuration for the VPC attachment"
  type = object({
    name          = string
    vpc_id        = string
    subnet_ids    = list(string)
    account_name  = optional(string)
    segment       = string
    appliance_mode_support = optional(string, "disable")
    dns_support             = optional(string, "enable")
  })
}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  type        = string
}

variable "route_tables" {
  description = "Map of segment names to route table IDs"
  type        = map(string)
}