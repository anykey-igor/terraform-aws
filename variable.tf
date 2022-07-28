variable "aws_s3_bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "infra-terraform-state-global-270722"
}

variable "table_dynamodb_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "infra_terraform_state_global_locks_270722"
}
