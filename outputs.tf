output "queues" {
  description = "The SQS queues created by this module."
  value       = aws_sqs_queue.queues
}

output "local_queues" {
  description = "The SQS queues created by this module."
  value       = local.queues
}
