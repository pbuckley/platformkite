variable "project" {
  description = "An identifier for this project. Used for prefixing resource names and tagging resources."
  type        = string
  validation {
    condition     = length(var.project) <= 6
    error_message = "The project variable must 6 characters or less."
  }
}

variable "environment" {
  description = "An identifier for this environment (dev, tst, stg, prd). Used for prefixing resource names and tagging resources."
  type        = string
  validation {
    condition     = contains(["dev", "tst", "stg", "prd"], var.environment)
    error_message = "The environment variable must be one of 'dev', 'tst', 'stg', 'prd'."
  }
}
