# "Almost never changing" meta data to make future Terraform developmernt easier

locals {

  service_ident = {

    common_AWS_SERVICE_IDENTITES = [
      "sts.amazonaws.com",     // Basically means other AWS services can access
      "s3.amazonaws.com",      // Basically means other S3 services can access
      "ec2.amazonaws.com",     // Basically means EC2 services can access
      "lambda.amazonaws.com",  // Basically means Lambda services can access
      "logs.amazonaws.com",    // Means CloudWatch services can access
      "sns.amazonaws.com",     // Means SNS services can access
      "sqs.amazonaws.com",     // Means SQS services can access
      "ses.amazonaws.com",     // Means SES services can access
      "sms.amazonaws.com",     // Means SMS services can access
      "route53.amazonaws.com", // Means Route53 services can access
      "kms.amazonaws.com",     // Means KMS services can access
      "eks.amazonaws.com",     // Means EKS services can access
      "ecr.amazonaws.com",     // Means ECR services can access
      "ecs.amazonaws.com",     // Means ECS services can access
    ]

  }
}