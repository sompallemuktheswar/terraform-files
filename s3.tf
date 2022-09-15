resource "aws_s3_bucket" "jenkins" {
  bucket = "cicd-s3-bucket"

  tags = {
    Name        = "jenkins"
    Environment = "Dev"
  }
}
