provider "aws" {
    profile = "default"
    region = "us-east-1"
}

resource "aws_s3_bucket" "tf_deneme_muratcan" {
    bucket = "tf_deneme_bucket_muratcan"
    acl = "private"
}