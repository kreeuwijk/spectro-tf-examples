#Palette environment info
variable "sc_host" {
  description = "Spectro Cloud Endpoint"
  default     = "api.spectrocloud.com"
}

variable "sc_api_key" {
  description = "Palette api key"
  sensitive   = true
}

variable "sc_project_name" {
  description = "Spectro Cloud Project (e.g: Default)"
  default     = "Default"
}

variable "aws_region" {
  description = "AWS region to deploy to"
}

variable "aws_profile" {
  description = "AWS profile to use from ~/.aws/credentials"
}

variable "aws_rolearn" {
  description = "AWS IAM Role ARN of the role created for Palette"
}