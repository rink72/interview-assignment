provider aws
{
  region = "${var.region}"
}

# Define beanstalk environment

resource "aws_elastic_beanstalk_application" "deploy_beanstalk_app" 
{
  name        = "${replace("${var.container}-${var.environment}", "/", "-")}"
  description = "Beanstalk deployment for ${var.container}:${var.version} in environment ${var.environment}"
}
 
resource "aws_elastic_beanstalk_environment" "deploy_beanstalk_env" 
{
  name                = "${replace("${var.container}-${var.environment}", "/", "-")}"
  application         = "${aws_elastic_beanstalk_application.deploy_beanstalk_app.name}"
  cname_prefix        = "${replace("${var.container}-${var.environment}", "/", "-")}"
  version_label       = "${aws_elastic_beanstalk_application_version.deploy_beanstalk_app_version.name}"
  
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
 

  # Beanstalk networking configuration
  setting 
  {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting 
  {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${var.elb_subnet_id}"
  }
  
  setting 
  {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.instance_subnet_id}"
  }

  # Autoscaling config - 2 minimum instances and scale based on CPU
  setting
  {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "2"
  }

  setting
  {
    namespace = "aws:autoscaling:trigger"
    name = "MeasureName"
    value = "CPUUtilization"
  }

  setting
  {
    namespace = "aws:autoscaling:trigger"
    name = "Unit"
    value = "Percent"
  }

  setting
  {
    namespace = "aws:autoscaling:trigger"
    name = "LowerThreshold"
    value = "40"
  }

  setting
  {
    namespace = "aws:autoscaling:trigger"
    name = "UpperThreshold"
    value = "70"
  }
}


resource "aws_elastic_beanstalk_application_version" "deploy_beanstalk_app_version" 
{
  name        = "${replace("${var.container}-${var.environment}", "/", "-")}"
  application = "${aws_elastic_beanstalk_application.deploy_beanstalk_app.name}"
  description = "${var.container}:${var.version}-${var.environment}"
  bucket      = "${var.s3_bucket}"
  key         = "${replace("${var.container}-${var.environment}", "/", "-")}/Dockerrun.aws.json"

  depends_on = ["aws_s3_bucket_object.deploy_s3_file"]
}



# Create version dockerrun file for deployment

resource "aws_s3_bucket_object" "deploy_s3_file" 
{
  bucket = "${var.s3_bucket}"
  key = "${replace("${var.container}-${var.environment}", "/", "-")}/Dockerrun.aws.json"
  content = <<DATA
    {
      "AWSEBDockerrunVersion": "1",
      "Image": 
      {
        "Name": "${var.container}:${var.version}",
        "Update": "True"
      },
      "Ports": [{ "ContainerPort": "${var.container_port}" }],
    "Volumes": []
  }
  DATA
}


# Output beanstalk URL for application

output "ApplicationURL"
{
  value = "${aws_elastic_beanstalk_environment.deploy_beanstalk_env.cname}"
}