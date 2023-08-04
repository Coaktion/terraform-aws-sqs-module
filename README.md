# Terraform SQS Module

Terraform module which creates SQS resources on AWS.

## Usage

```hcl
module "sqs" {
  source = "github.com/paulo-tinoco/terraform-sqs-module"

  queues = [
    {
      name = "my_queue"
      fifo_queue = false
    },
    {
      name = "my_fifo_queue"
    }
  ]
  resource_prefix = "prefix_queue"
  default_fifo_queue = true
}
```
