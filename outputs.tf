output "queue_name" {
    description = "The SQS queues created by this module."
    value       = aws_sqs_queue.queues
}