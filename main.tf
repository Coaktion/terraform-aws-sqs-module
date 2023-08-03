locals {
  sqs_queues = {
    for queue in var.queues : var.resource_prefix != "" ?  "${var.resource_prefix}__${queue.name}" : queue.name => queue
  }
}

resource "aws_sqs_queue" "queues" {
  for_each = local.sqs_queues

  name                      = try(each.value.fifo_queue, var.fifo_queue) ? "${each.key}.fifo" : each.key
  fifo_queue                = try(each.value.fifo_queue, var.fifo_queue)
  delay_seconds             = try(each.value.delay_seconds, var.default_delay_seconds)
  max_message_size          = try(each.value.max_message, var.max_message_size_in_bytes)
  message_retention_seconds = try(each.value.message_retention_seconds, var.default_message_retention_in_seconds)
  receive_wait_time_seconds = try(each.value.receive_wait_time_seconds, var.default_receive_wait_time_seconds)

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.name_service_example_dead_queues[each.key].arn,
    maxReceiveCount     = try(each.value.max_receive_count, var.default_max_receive_count),
  })

  depends_on = [
    aws_sqs_queue.name_service_example_dead_queues,
  ]

  tags = var.default_tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_sqs_queue" "name_service_example_dead_queues" {
  for_each = local.sqs_queues

  name                      = try(each.value.fifo_queue, var.fifo_queue) ? "dead__${each.key}.fifo" : "dead__${each.key}"
  fifo_queue                = try(each.value.fifo_queue, var.fifo_queue)
  delay_seconds             = try(each.value.delay_seconds, var.default_delay_seconds)
  max_message_size          = try(each.value.max_message, var.max_message_size_in_bytes)
  message_retention_seconds = try(each.value.message_retention_seconds, var.default_message_retention_in_seconds)
  receive_wait_time_seconds = try(each.value.receive_wait_time_seconds, var.default_receive_wait_time_seconds)

  tags = var.default_tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
