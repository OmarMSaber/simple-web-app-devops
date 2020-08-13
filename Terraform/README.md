# Kubernetes cluster in AWS using kops and Terraform

## Requirements
* [Terraform](https://www.terraform.io/downloads.html)
* [Kops](https://github.com/kubernetes/kops#installing)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

## Deploy the environment

1. Download needed tools as listed above

2. Create an s3 bucket to hold KOPS_STATE_STORE variable and export 
   `export KOPS_STATE_STORE=s3://<kops_state_bucket>` # Get this values from test.tfvars

3. Execute `terraform init` to initialize terraform configurations and download dependencies

4. Execute `terraform plan -var-file=test.tfvars`

5. Execute `terraform apply -var-file=config/${env}.tfvars` and answer `yes` when prompted.

6. Once terraform is done you can check the state of the cluster with: `kops validate cluster`

8. For example `kubectl get nodes` 

9. To destroy the environment simply run `terraform destroy -var-file=config/${env}.tfvars` and answer `yes` when prompted.
