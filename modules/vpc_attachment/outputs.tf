# Outputs for VPC Attachment Module

output "attachment_id" {
  description = "The ID of the VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "attachment_arn" {
  description = "The ARN of the VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.arn
}