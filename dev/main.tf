# Message to Terraform where the remote backend is stored  file "terraform.tfstate"
#terraform {
#    backend "s3" {
#        # The name of the bucket, which was defined in "aws_s3_bucket"
#        bucket = "infra-terraform-state-global-270722"
#        # Terraform state file path
#        key = "infra/dev/terraform.tfstate"
#        region = "eu-central-1"

#        # Table name in DynamoDB, which was defined in "aws_dynamodb_table"
#        dynamodb_table = "infra_terraform_state_global_locks_270722"
#        encrypt = true
#    }
#}

# Creating a resource "aws_s3_bucket" with name "infra_terraform_state_global-270722"
# The name of bucket  must be unique throughout the internet.
resource "aws_s3_bucket" "infra_terraform_state_global" {
    bucket = "infra-terraform-state-global-270722"

    # Protection against accidental deletion of S3 bucket
    # it will be impossible to delete this bucket using the terraform destroy command
    # If you need to remove it, just comment out these lines
#    lifecycle {
#        prevent_destroy = true
#    }
}

# Enable version control for AWS S3 bucket
resource "aws_s3_bucket_versioning" "infra_terraform_state_global_versioning" {
  bucket = aws_s3_bucket.infra_terraform_state_global.id
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
    name = "infra_terraform_state_global_locks_270722"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}


#----------------------------------------------------------------#
output "aws_s3_bucket" {
    description = "AWS S3 Bucket Name"
    value = aws_s3_bucket.infra_terraform_state_global.id
}

output "aws_dynamodb_table" {
    description = "AWS DynamoDB Name"
    value =aws_dynamodb_table.infra_terraform_locks.name
}