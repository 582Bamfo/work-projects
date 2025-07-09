#S3 bucket allowing any aws specfic account 449325664824 authenticated identity to have access to the bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-aws-all-principal-bucket-582bamfo" 
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

  policy = data.aws_iam_policy_document.allow_all_aws_principals.json
}

data "aws_iam_policy_document" "allow_all_aws_principals" {
  statement {
    sid = "AllowAllAWSPrincipalsAccess"
    
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
       # "*"
        "arn:aws:iam::449325664824:root",
      #  "arn:aws:iam::449325664824:role/connect-to-instance-with-session-manager"
          ]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::my-aws-all-principal-bucket-582bamfo",
      "arn:aws:s3:::my-aws-all-principal-bucket-582bamfo/*"
    ]
  }
}
