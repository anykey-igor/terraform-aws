# Message to Terraform where will be store file of remote backend  "terraform.tfstate".
#This config-file without part backend config
# When you need init backend use next command: terraform init -backend-config=backend.hcl
terraform {
    backend "s3" {
#        # The name of the bucket, which was defined in "aws_s3_bucket"
#        bucket         = "infra-terraform-state-global-270722"
        key            = "infra/global/s3/terraform.tfstate"
#        region         = "eu-central-1"
#        # Table name in DynamoDB, which was defined in "aws_dynamodb_table"
#        dynamodb_table = "infra_terraform_state_global_locks_270722"
#        encrypt        = true
    }
}

# Creating a resource "aws_s3_bucket" with name "infra_terraform_state_global-270722"
# The name of bucket  must be unique throughout the internet.
resource "aws_s3_bucket" "infra_terraform_state_global" {
    bucket = var.aws_s3_bucket_name

    # Protection deletion of S3 bucket
    # it will be impossible to delete this bucket using the terraform destroy command
    # If you need to remove it, just comment out these lines

    #force_destroy = true

    lifecycle {
        prevent_destroy = true
    }
}

# Enable version control for AWS S3 bucket
resource "aws_s3_bucket_versioning" "infra_terraform_state_global_versioning" {
  bucket = var.aws_s3_bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption on side Amazon
resource "aws_s3_bucket_server_side_encryption_configuration" "encription_on_s3_bucket" {
    bucket = aws_s3_bucket.infra_terraform_state_global.bucket

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm     = "AES256"
        }
    }
}


# Amazon DynamoDB is a distributed key and value store. Supports strongly consistent read and conditional
# write operations, which are all the components needed for a distributed locking system
# In DynamoDB to create teable "infra_terraform_locks" with primary key "LockID" to use lock
resource "aws_dynamodb_table" "infra_terraform_locks" {
    name = var.table_dynamodb_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}


#----------------------------------------------------------------#
output "aws_s3_bucket_arn" {
    description = "The ARN of the S3 bucket"
    value       = aws_s3_bucket.infra_terraform_state_global.arn
}

output "aws_s3_bucket_name" {
    description = "AWS S3 Bucket Name"
    value = aws_s3_bucket.infra_terraform_state_global.id
}

output "aws_dynamodb_table" {
    description = "AWS DynamoDB Name"
    value =aws_dynamodb_table.infra_terraform_locks.name
}