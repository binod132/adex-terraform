terraform {
  backend "s3" {
    bucket         = "terraformstate132"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "MY_DB"
  }
}
