# resource "aws_s3_bucket" "remote_backend" {
#   bucket = "s3remote01"
#   tags = {
#     Name = "s3-statebackend"
#   }

# }

# resource "aws_dynamodb_table" "statebackend-db" {
#   name         = "db-for-statefile"
#    billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"

#   }
# }