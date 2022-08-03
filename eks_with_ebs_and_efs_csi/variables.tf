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

variable "sc_eks_cluster_name" {}
variable "aws_account_number" {}
