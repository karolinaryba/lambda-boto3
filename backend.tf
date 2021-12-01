terraform {
  backend "s3" {
    bucket         = "talent-academy-439272626435-tfstates"
    key            = "04/lambda-practice-1/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}