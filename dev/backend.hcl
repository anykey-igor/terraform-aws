# backend.hcl
# The name of the bucket, which was defined in "aws_s3_bucket"
bucket = "infra-terraform-state-global-270722"
# Terraform state file path
region = "eu-central-1"
# Table name in DynamoDB, which was defined in "aws_dynamodb_table"
dynamodb_table = "infra_terraform_state_global_locks_270722"
encrypt = true