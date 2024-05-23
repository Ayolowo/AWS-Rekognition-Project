# Create s3 bucket
resource "aws_s3_bucket" "image_bucket" {
  bucket = "ayos-rekognition-bucket2"

  tags = {
    Name    = "My S3 Bucket"
    purpose = "For rekognition access"
  }
}

resource "aws_s3_bucket_ownership_controls" "image_bucket_acl" {
  bucket = aws_s3_bucket.image_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Create Iam role for Rekognition to access s3 bucket
resource "aws_iam_role" "rekognition_role" {
  name = "rekognition_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "rekognition.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# To attach an Iam policy for Rekognition to read from the s3 bucket
resource "aws_iam_policy_attachment" "rekognition_policy_attachment" {
  name       = "rekognition_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionReadOnlyAccess"
  roles      = [aws_iam_role.rekognition_role.name]
}
