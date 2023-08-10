variable "default_message_retention_in_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default is 345600 (4 days)."
  type        = number
  default     = 345600
}

variable "default_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default is 345600 (4 days)."
  type        = number
  default     = 1209600
}

variable "default_max_message" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. Integer representing bytes, from 1024 (1 KiB) to 262144 (256 KiB). The default is 262144 (256 KiB)."
  type        = number
  default     = 262144
}

variable "default_receive_wait_time_seconds" {
  description = "The number of seconds for which a ReceiveMessage action waits for a message to arrive. An integer from 0 to 20 (seconds). The default is 0 (zero)."
  type        = number
  default     = 20
}

variable "default_delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue is delayed. An integer from 0 to 900 (15 minutes). The default is 0 (zero)."
  type        = number
  default     = 0
}

variable "default_max_receive_count" {
  description = "The number of times a message is delivered to the source queue before being moved to the dead-letter queue. An integer from 1 to 1000. The default is 5."
  type        = number
  default     = 5
}

variable "queues" {
  description = "A list of maps describing the queues to create. Each map must contain a name key. The following keys are optional: delay_seconds, max_message, message_retention_seconds, receive_wait_time_seconds, max_receive_count, topics_to_subscribe."
  type = list(object({
    name                      = string
    delay_seconds             = optional(number)
    max_message               = optional(number)
    message_retention_seconds = optional(number)
    receive_wait_time_seconds = optional(number)
    max_receive_count         = optional(number)
    fifo_queue                = optional(bool)
    topics_to_subscribe = optional(list(object({
      name          = string
      filter_policy = optional(map(string))
    })), [])
  }))
  default = []
}

variable "default_tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "resource_prefix" {
  description = "A prefix to add to all resource names."
  type        = string
  default     = ""
}

variable "default_fifo_queue" {
  description = "Boolean designating a FIFO queue. If not set, it defaults to false making it standard."
  type        = bool
  default     = false
}
