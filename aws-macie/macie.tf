# Enable Amazon Macie
resource "aws_macie2_account" "example" {
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  status                       = "ENABLED"
}

# Enable automated sensitive data discovery for policy findings
# resource "aws_macie2_automated_discovery_configuration" "example" {
#   status = "ENABLED"
# }

# Create Macie classification job to scan specific bucket
resource "aws_macie2_classification_job" "scan_specific_bucket" {
  schedule_frequency {
    # daily_schedule = {}  # AWS determines time automatically
     weekly_schedule = "WEDNESDAY"   # Run weekly on Sunday
    # monthly_schedule = { day_of_month = 15 }  # Run monthly on 15th
  #  daily_schedule = true
  }
   job_type = var.job_type
  name     = var.classification_job_name
  sampling_percentage = 100

  s3_job_definition {
    bucket_definitions {
      account_id = data.aws_caller_identity.current.account_id
      buckets    = var.bucket_names # Replace with your bucket name
    }
  }
description = "AWS macie to scan s3 buckets."
initial_run = true
  depends_on = [aws_macie2_account.example]
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

