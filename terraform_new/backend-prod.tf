terraform {
  backend "s3" {
    bucket         = "backendtf-prod"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "MY_DB"
  }
}
