# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "5.33.0"

#     }
#   }
# }
# provider "aws" {
#   region  = "ap-south-1"
#   profile = "terraform-user"

# }
# terraform {
#   backend "s3" {
#   bucket         = "s3remote01"
#   key            = "terraform.tfstate"
#   region         = "ap-south-1"
#   dynamodb_table = "db-for-statefile"
# }
# }