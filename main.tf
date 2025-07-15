module "macie_scan" {
  source = "./aws-macie"
  classification_job_name = "macie-scan-weekly"
}