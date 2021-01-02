resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock-vvs"
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}
