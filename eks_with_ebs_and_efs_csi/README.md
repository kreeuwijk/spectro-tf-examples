# Setup instructions
Pre-work:
* In Palette, create an API key for your user

1. Update `terraform.tfvars`:
  * Set `sc_api_key` to the Palette API key you created earlier
  * Set `aws_region` to AWS region you want to deploy to
  * Set `aws_profile` to a valid profile in ~/.aws/credentials for your AWS account
  * Set `aws_rolearn` to the IAM Role that you're using to allow Spectrocloud Palette to deploy into AWS

2. Review and/or update `module_cluster.tf`:
  * Set `cloudaccount` on line 6 to the name of the cloudaccount for AWS in Palette
  * Set `ssh_key_name` on line 10 to a valid SSH key in this AWS region (or remove this setting altogether if you don't need an SSH key injected)

3. Run `terraform init` in this folder
4. Run `terraform apply` to create the infrastructure