# Pre-req infrastructure variables
variable "region"
{
  description = "Region to deploy in"
  default = "us-east-1"
}

variable "vpc_id"
{
  description = "The VPC ID that beanstalk will deploy in to"
  default = "vpc-8ba978f0"
}

variable "elb_subnet_id"
{
  description = "The subnet to deploy the ELB in"
  default = "subnet-a4d5cfef"
}

variable "instance_subnet_id"
{
  description = "The subnet to deploy the ELB in"
  default = "subnet-21c5df6a"
}

variable "s3_bucket" 
{
  description = "S3 bucket to deploy config file to"
  default = "sam-eb-testing-72"
}


# Variables that will deploy a sample application if nothing is specified on commandline

variable "environment" 
{
  description = "The name of the environment to deploy. This will be used in some identifiers for the environment."
  default = "development"
}

variable "container"
{
  description = "The docker application to deploy. This will pull from docker hub."
  default = "docwhat/webtest"
}

variable "version"
{
  description = "The verstion of the container to deploy."
  default = "latest"
}

variable "container_port"
{
  description = "The docker container port to be published"
  default = "8080"
}
