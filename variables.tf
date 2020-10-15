variable "enabled" {
  description = "Whether the Cloudflare SG Updater Lambda runs or not"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name value for resources"
  type        = string
  default     = "Cloudflare-SG-Updater"
}

variable "schedule" {
  description = "The cloudwatch schedule used to run the Lambda."
  default     = "cron(0 20 * * ? *)"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
