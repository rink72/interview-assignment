variable "region"
{
  description = "Region to deploy components in"
  default = "us-east-1"
}

variable "vpc_name"
{
  description = "Name of the VPC"
  default = "Beanstalk testing VPC"
}

variable "igw_name"
{
  description = "Name of Internet Gateway"
  default = "Beanstalk testing IGW"
}

variable "vpc_cidr"
{
  description = "CIDR for VPC where Beanstalk will be deployed"
  default = "10.0.0.0/16"
}

variable "elb_cidr"
{
  description = "CIDR for subnet where Beanstalk ELB's will be deployed"
  default = "10.0.1.0/24"
}

variable "elb_subnet_name"
{
  description = "Name tag for ELB subnet"
  default = "Beanstalk ELB Subnet"
}

variable "instance_cidr"
{
	description = "CIDR for subnet where Beanstalk Instances will be deployed"
  default = "10.0.2.0/24"
}

variable "instance_subnet_name"
{
  description = "Name tag for Instance subnet"
  default = "Beanstalk Instance Subnet"
}

variable "availability_zone"
{
  description = "Availability zone to deploy subnet in."
  default = "us-east-1a"
}

variable "s3_name"
{
  description = "Name of S3 bucket"
  default = "sam-eb-testing-72"
}