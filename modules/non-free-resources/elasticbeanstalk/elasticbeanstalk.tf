resource "aws_elastic_beanstalk_application" "privesc-elasticbeanstalk-app" {
  name        = "privesc-elasticbeanstalk-app"
  description = "privesc-elasticbeanstalk-app"
  tags = {
    yor_trace = "97aef38e-29d4-4c45-9468-42169970fb9c"
  }
}

resource "aws_elastic_beanstalk_environment" "privesc-elasticbeanstalk-env" {
  name                = "privesc-elasticbeanstalk-env"
  application         = aws_elastic_beanstalk_application.privesc-elasticbeanstalk-app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.4 running Docker"
  instance_type       = "t2.micro"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.shared_high_priv_servicerole
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.shared_high_priv_servicerole
  }

  tags = {
    yor_trace = "87413fd2-ca00-459d-995e-766f84a65a88"
  }
}

resource "aws_elastic_beanstalk_application_version" "privesc-elasticbeanstalk-app-version" {
  name        = "privesc-elasticbeanstalk-app-version"
  application = aws_elastic_beanstalk_application.privesc-elasticbeanstalk-app.name
  bucket      = "my-test-bucket-for-ebs"
  key         = "latest.zip"
  tags = {
    yor_trace = "e34401f0-da81-4fc4-8e5e-a43901dac8a2"
  }
}