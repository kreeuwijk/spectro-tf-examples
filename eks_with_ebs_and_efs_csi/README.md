# Setup instructions
Pre-work:
* In Palette, create an API key for your user
* In Palette, create a cluster profile called "Dev-EKS" and configure the following layers:
  * OS:         Amazon Linux EKS 1.0.0
  * Kubernetes: Kubernetes EKS 1.22
  * Network:    AWS VPC CNI
  * Storage:    Amazon EBS CSI 1.8.0
  * Add-on:     Amazon EFS CSI 1.4.0 (found in the System App folder)

1. Update `providers.tf`:
  * Update the `region` on line 20 to your preferred region
  * Set the `role_arn` on line 24 to the IAM Role that you're using to allow Spectrocloud Palette to deploy into AWS

2. Update `terraform.tfvars`:
  * Set `sc_api_key` to the Palette API key you created earlier
  * set `aws_account_number` to the number of your AWS account 

3. Run `terraform init` in this folder
4. Run `terraform apply` to create the infrastructure