
resource "aws_lambda_function" "base_lambda" {
  filename                       = var.source_path
  function_name                  = var.function_name
  source_code_hash               = filebase64sha256(var.source_path)
  description                    = var.description
  handler                        = var.handler
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  layers                         = var.layers
  tags                           = var.tags
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = var.create_role ? aws_iam_role.execution_role.arn : var.execution_role

  dynamic "vpc_config" {
    for_each = var.enable_vpc_config ? [true] : []
    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.env_vars)) == 0 ? [] : [true]
    content {
      variables = var.env_vars
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "lambda_function_invoke_config" {
  count = var.create_async_invoke_config ? 1 : 0

  function_name                = aws_lambda_function.base_lambda.function_name
  maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
  maximum_retry_attempts       = var.maximum_retry_attempts

  dynamic "destination_config" {
    for_each = var.destination_on_failure != null || var.destination_on_success != null ? [true] : []
    content {
      dynamic "on_success" {
        for_each = var.destination_on_success != null ? [true] : []
        content {
          destination = var.destination_on_success
        }
      }

      dynamic "on_failure" {
        for_each = var.destination_on_failure != null ? [true] : []
        content {
          destination = var.destination_on_failure
        }
      }
    }
  }
}

resource "aws_iam_role" "execution_role" {
  count              = var.create_role ? 1 : 0
  name_prefix        = "LambdaExecRole"
  assume_role_policy = data.aws_iam_policy_document.base_lambda.json
}

data "aws_iam_policy_document" "base_lambda" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
      "lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "basic_execution_policy_attachment" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.execution_role[count.index].name
}

# attaches policies provided in 'var.attached_policies' variable to lambda execution role
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count = var.create_role ? length(var.attached_policies) : 0

  policy_arn = var.attached_policies[count.index]
  role       = aws_iam_role.execution_role.name
}
