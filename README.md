# Terraform SQS Module

Terraform module which creates SQS resources on AWS.

## Usage

```hcl
module "sqs" {
  source = "github.com/paulo-tinoco/terraform-sqs-module"

  queues = [
    {
      name = "name_service_example"
    },
  ]
  resource_prefix = "visual_triggers"
  fifo_queue = true
}
```
