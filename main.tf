# Enable Amazon Macie
resource "aws_macie2_account" "example" {
  finding_publishing_frequency = "FIFTEEN_MINUTES"
   status = "ENABLED"
}
# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}


module "macie_scan" {
  source = "./aws-macie"
  classification_job_name = "macie-scan-weekly"
   depends_on = [aws_macie2_account.example] 
}

module "macie" {
  source = "./aws-macie"
  classification_job_name = "macie-scan-2"
  bucket_names = ["cloudwatch-monotoring-dev"]
 
}