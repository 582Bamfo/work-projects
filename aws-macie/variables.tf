variable "job_type" {
  default = "SCHEDULED"
}

variable "classification_job_name" {
  default = "scan-specific-bucket-job-weekly"
}

variable "bucket_names" {
  default = ["body-425","data-cloud2025","tester-986"]
}