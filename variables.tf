
###########################################
####### Lambda Function ###################
###########################################
variable "source_path" {
  type        = string
  description = "Path to lambda function .zip deployment package"
}

variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "handler" {
  type        = string
  description = "Name of the handler"
}

variable "runtime" {
  type        = string
  description = "Lambda function runtime, see https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
}

variable "memory_size" {
  type        = number
  default     = 128
  description = "Maximum memory size"
}

variable "timeout" {
  type        = number
  default     = 30
  description = "Lambda function timeout"
}

variable "reserved_concurrent_executions" {
  type        = number
  default     = -1
  description = "How many lambdas can execute concurrently, defaults to unreserved"
}

variable "description" {
  type    = string
  default = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to resources."
}

variable "attached_policies" {
  type        = list(string)
  default     = []
  description = "A list of IAM policy ARNs. Will be attached to execution role"
}

variable "create_role" {
  type        = bool
  default     = true
  description = "if set to 'true' creates default execution role wih policies from 'attached_policies' variable"
}

variable "execution_role" {
  type        = string
  default     = ""
  description = "Execution role ARN, use if 'create_role' is set to 'true'"
}

variable "env_vars" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "layers" {
  type        = list(string)
  default     = []
  description = "Lambda layer ARNs"
}

variable "enable_vpc_config" {
  type        = bool
  default     = false
  description = "enables lambda vpc configuration"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "aws_security_group id list, requires 'enable_vpc_config' set to true"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "aws_subnet id list, requires 'enable_vpc_config' set to true"
}

###########################################
### Async invoke configuration ############
###########################################
variable "create_async_invoke_config" {
  type        = bool
  default     = true
  description = "Controls whether async invoke config needs to be created"
}

variable "maximum_event_age_in_seconds" {
  type    = number
  default = 120
}

variable "maximum_retry_attempts" {
  type        = number
  default     = 0
  description = "0 - 2"
}

variable "destination_on_failure" {
  type        = string
  default     = null
  description = "ARN of the destination resource for failed invocations"
}

variable "destination_on_success" {
  type        = string
  default     = null
  description = "ARN of the destination resource for successful invocations"
}


