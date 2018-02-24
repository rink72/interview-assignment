provider aws
{
  region = "${var.region}"
}

resource "aws_vpc" "deploy_vpc"
{
  cidr_block = "${var.vpc_cidr}"

  tags
  {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "deploy_elb_subnet" 
{
  vpc_id     = "${aws_vpc.deploy_vpc.id}"
  cidr_block = "${var.elb_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.availability_zone}"

  tags
  {
    "Name" = "${var.elb_subnet_name}"
  }
}

data "aws_route_table" "vpc_route_table" 
{
  vpc_id = "${aws_vpc.deploy_vpc.id}"
}

resource "aws_route" "vpc_route_igw" 
{
  route_table_id            = "${data.aws_route_table.vpc_route_table.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.deploy_igw.id}"
}


resource "aws_subnet" "deploy_instance_subnet" 
{
  vpc_id     = "${aws_vpc.deploy_vpc.id}"
  cidr_block = "${var.instance_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.availability_zone}"

  tags
  {
    "Name" = "${var.instance_subnet_name}"
  }

}

resource "aws_internet_gateway" "deploy_igw" 
{
  vpc_id = "${aws_vpc.deploy_vpc.id}"

  tags {
    Name = "${var.igw_name}"
  }
}

resource "aws_s3_bucket" "deploy_s3" 
{
  bucket = "${var.s3_name}"
}


output "vpc_id"
{
  value = "${aws_vpc.deploy_vpc.id}"
}

output "elb_subnet"
{
  value = "${aws_subnet.deploy_elb_subnet.id}"
}

output "instance_subnet"
{
  value = "${aws_subnet.deploy_instance_subnet.id}"
}

output "s3_bucket"
{
  value = "${aws_s3_bucket.deploy_s3.bucket}"
}
