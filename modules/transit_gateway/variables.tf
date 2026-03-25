# Variables for Transit Gateway Module

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
}

variable "segments" {
  description = "List of network segments"
  type        = list(string)
}