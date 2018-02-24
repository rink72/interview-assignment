# Overview

This is the result of my attempt at completing the assignment task. I have focused on the deployment side of the assignment and have used the following technologies:

- Terraform
- AWS
- Elastic Beanstalk

## Assumptions

- I have assumed there is a shared AWS account that is used to deploy all applications in to. This means that a VPC and the required subnets would already be in place for the Beanstalk deployment. If this was not the case or the underlying infrastructure was not yet deployed then there is terraform configuration in the repo to deploy that as well.
- I initially considered an approach to deploy a VPC and subnets for each application deployment but this would severely limit the number of deployments as you are only allowed 5 VPC's per region in AWS.
- Authentication to AWS will be done using environment variables (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY). This could be changed to use Terraform parameters or AWS profile if required.


## Getting Started

To deploy infrastructure if not already done (This will support multiple applications so only needs to be done once):

1. Set AWS environment variables for authentication
2. Navigate to the deploy-infrastructure folder
3. Run `terraform init` to download required modules
4. Run `terraform plan` to preview changes that will be made.
5. Run `terraform apply -auto-approve` to make changes.
6. Required values will be output. Use these to update deploy-application\variables.tf


To deploy applications once pre-requisite infrasructure is present:

1. Set AWS environment variables for authentication
2. Navigate to the deploy-application folder.
3. Run `terraform init` to download required modules
4. Run `terraform plan` to preview changes that will be made.
5. Run `terraform apply -auto-approve` to make changes.
6. The URL for the environment will be output and can be used to browse the application.

NOTE:

The variable file has a test docker container it will deploy if no override variables are specified. If you wish to change the container deployed, version or port number for the container then you can use a command similar to below:

```
terraform apply -auto-approve -var "container=yeasy/simple-web" -var "version=latest" -var "container_port=80" -var "environment=demo-env"
```

Approximate time to deploy each application is 5-6 minutes.


## Cleanup

Once you are finished with an environment, you can run `terraform destroy -force` to tear down the environment. This will leave the underlying VPC and subnets available for other deployments.
