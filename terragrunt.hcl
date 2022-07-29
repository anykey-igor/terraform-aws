#include "root" {
#  path = find_in_parent_folders()
#}

# Remote backend configurations for all envirnments dirs
remote_state {
  backend = "s3"
  config = {
    bucket         = "infra-terraform-state-global-270722"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "infra_terraform_state_global_locks_270722"
  }
}