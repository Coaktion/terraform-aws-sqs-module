locals {
  queues = flatten([
    for queue in var.queues :
    {
      name                       = var.resource_prefix != "" ? "${var.resource_prefix}__${queue.name}" : queue.name
      fifo_queue                 = queue.fifo_queue != null ? queue.fifo_queue : var.default_fifo_queue
      delay_seconds              = lookup(queue, "delay_seconds", var.default_delay_seconds)
      max_message                = lookup(queue, "max_message", var.default_max_message)
      visibility_timeout_seconds = queue.visibility_timeout_seconds != null ? queue.visibility_timeout_seconds : var.default_visibility_timeout_seconds
      message_retention_seconds  = lookup(queue, "message_retention_seconds", var.default_retention_seconds)
      receive_wait_time_seconds  = lookup(queue, "receive_wait_time_seconds", var.default_receive_wait_time_seconds)
      max_receive_count          = queue.max_receive_count != null ? queue.max_receive_count : var.default_max_receive_count
      topics_to_subscribe        = queue.topics_to_subscribe
    }
  ])

  sqs_queues = { for queue in local.queues : queue.fifo_queue ? "${queue.name}.fifo" : queue.name => queue }
}

resource "aws_sqs_queue" "queues" {
  for_each = local.sqs_queues

  name                        = each.key
  fifo_queue                  = each.value.fifo_queue
  delay_seconds               = each.value.delay_seconds
  max_message_size            = each.value.max_message
  visibility_timeout_seconds  = each.value.visibility_timeout_seconds
  message_retention_seconds   = each.value.message_retention_seconds
  receive_wait_time_seconds   = each.value.receive_wait_time_seconds
  content_based_deduplication = each.value.fifo_queue ? true : false

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_queues[each.key].arn
    maxReceiveCount     = each.value.max_receive_count
  })
  depends_on = [
    aws_sqs_queue.dead_queues,
  ]

  tags = var.default_tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_sqs_queue" "dead_queues" {
  for_each = local.sqs_queues

  name                        = "dead__${each.key}"
  fifo_queue                  = each.value.fifo_queue
  delay_seconds               = each.value.delay_seconds
  max_message_size            = each.value.max_message
  message_retention_seconds   = each.value.message_retention_seconds
  receive_wait_time_seconds   = each.value.receive_wait_time_seconds
  content_based_deduplication = each.value.fifo_queue ? true : false

  tags = var.default_tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
