# AWS Central Networking with Transit Gateway

This Terraform configuration sets up a central networking account with an AWS Transit Gateway (TGW) and supports configurable VPC attachments in the same or different accounts. It also provides segmented networking with a special "shared" segment that can connect to all other segments.

## Features

- **Transit Gateway**: Hosted in the central networking account
- **Configurable Attachments**: Create VPC attachments in the same account or cross-account
- **Segmented Networking**: Route tables for each segment, with "shared" segment connecting to all others
- **Modular Design**: Separate modules for TGW and attachments

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- For cross-account attachments: IAM roles with necessary permissions in target accounts

## Configuration

### Variables

- `region`: AWS region (default: us-east-1)
- `central_account_id`: Account ID where TGW is hosted
- `transit_gateway`: TGW configuration
- `segments`: List of segments (must include "shared" for shared segment)
- `vpc_attachments`: List of VPC attachment configurations
- `create_attachments_in_same_account`: Boolean for same-account attachments
- `cross_account_providers`: Map for cross-account provider configs

### Example Configuration

```hcl
variable "central_account_id" {
  default = "123456789012"
}

variable "segments" {
  default = ["shared", "prod", "dev"]
}

variable "vpc_attachments" {
  default = [
    {
      name       = "prod-vpc-attachment"
      vpc_id     = "vpc-12345"
      subnet_ids = ["subnet-1", "subnet-2"]
      segment    = "prod"
    },
    {
      name       = "shared-vpc-attachment"
      vpc_id     = "vpc-67890"
      subnet_ids = ["subnet-3", "subnet-4"]
      segment    = "shared"
    }
  ]
}
```

## Cross-Account Setup

For cross-account attachments:

1. Add the account configurations to `cross_account_providers` in your `terraform.tfvars`:
   ```hcl
   cross_account_providers = {
     "prod-account" = {
       account_id = "987654321098"
       role_arn   = "arn:aws:iam::987654321098:role/TerraformRole"
     }
     "dev-account" = {
       account_id = "876543210987"
       role_arn   = "arn:aws:iam::876543210987:role/TerraformRole"
     }
   }
   ```

   **Key Points:**
   - Account name (e.g., `prod-account`) is used to create provider alias: `account_prod-account`
   - Account ID is stored for reference and tracking
   - Role ARN is the assume role for cross-account access

2. Run the generation script to create `providers.tf`:
   ```bash
   ./generate_providers.py
   ```
   This reads `cross_account_providers` and generates provider blocks with the correct aliases.

3. In the VPC attachment config, specify the `account_name`:
   ```hcl
   vpc_attachments = [
     {
       name        = "prod-vpc"
       vpc_id      = "vpc-abcdef12"
       subnet_ids  = ["subnet-abcdef12", "subnet-abcdef13"]
       account_name = "prod-account"
       segment     = "prod"
     }
   ]
   ```

The code automatically selects the correct provider based on the `account_name`, which maps to the corresponding provider alias created in `providers.tf`.

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Networking Logic

- Each segment has its own TGW route table
- Attachments are associated with their segment's route table
- The "shared" segment propagates routes to all other segments
- All other segments propagate routes to the "shared" segment
- This allows the shared segment to communicate with all others, while other segments are isolated except through shared

## Outputs

- `transit_gateway_id`: TGW ID
- `route_tables`: Map of segment to route table ID
- `vpc_attachment_ids`: List of attachment IDs
