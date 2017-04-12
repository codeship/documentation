---
title: Deploy to Elastic Beanstalk
weight: 8
layout: page
tags:
  - deployment
  - elastic beanstalk

redirect_from:
  - /continuous-deployment/deployment-to-elastic-beanstalk/
---

* include a table of contents
{:toc}

## Prerequisites

This deployment method is not yet able to create Elastic Beanstalk environments, neither does it configure the S3 Bucket needed to upload new versions of your application. Please configure your Elastic Beanstalk environment by hand before your first deploy. All later deployments can then be handled by our integreated deployment.

## Configuration

Add a new deployment for the branch you want to deploy and choose **Amazon ElasticBeanstalk** as the deployment method. You'll then see a form like in the following screenshot.

![AWS ElasticBeanstalk Setup]({{ site.baseurl }}/images/continuous-deployment/aws_elasticbeanstalk_setup.png)

Fill out your AWS credentials, the region you want to deploy the application to, as well as the name of your ElasticBeanstalk application, the environment and the name (and possible subfolders) of an S3 bucket to use to cache archives of your source code before deploying.

Save the deployment via the blue button in the lower left corner and you're good to go.

## IAM Policies

It is generally a good idea to create a separate [IAM user](http://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html) for Codeship when deploying to AWS. This allows you to explicitly control which resources Codeship can access during your builds. Please take note of the **Access Key ID** and **Secret Access Key** created during the process, as you'll need this when configuring the deployment.

### S3

To upload new application versions to the S3 bucket specified in the deployment configuration we need at least _Put_ access to the bucket (or a the _appname_ prefix). See the following snippet for an example.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::[s3-bucket]/*"
            ]
        }
    ]
}
```

### ElasticBeanstalk

Please replace `[region]` and `[accountid]` with the respective values for your AWS account / ElasticBeanstalk application.

```json
{
  "Statement": [
    {
      "Action": [
        "elasticbeanstalk:CreateApplicationVersion",
        "elasticbeanstalk:DescribeEnvironments",
        "elasticbeanstalk:DeleteApplicationVersion",
        "elasticbeanstalk:UpdateEnvironment"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "sns:CreateTopic",
        "sns:GetTopicAttributes",
        "sns:ListSubscriptionsByTopic",
        "sns:Subscribe"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sns:[region]:[accountid]:*"
    },
    {
      "Action": [
        "autoscaling:SuspendProcesses",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:ResumeProcesses",
        "autoscaling:DescribeAutoScalingGroups"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "cloudformation:GetTemplate",
        "cloudformation:DescribeStackResource",
        "cloudformation:DescribeStackResources",
        "cloudformation:UpdateStack"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:cloudformation:[region]:[accountid]:*"
    },
    {
      "Action": [
        "ec2:DescribeImages",
        "ec2:DescribeKeyPairs"
      ],
      "Effect": "Allow",
      "Resource": "*"
   },
   {
    "Action": [
     "s3:PutObject",
     "s3:PutObjectAcl",
     "s3:GetObject",
     "s3:GetObjectAcl",
     "s3:ListBucket",
     "s3:DeleteObject",
     "s3:GetBucketPolicy",
     "s3:CreateBucket"
   ],
   "Effect": "Allow",
   "Resource": [
    "arn:aws:s3:::elasticbeanstalk-[region]-[accountid]",
    "arn:aws:s3:::elasticbeanstalk-[region]-[accountid]/*"
   ]
  }
 ]
}
```

If you are using more than once instance for your application you need to add at least the following permissions as well.

```json
{
  "Action": [
    "elasticloadbalancing:DescribeInstanceHealth",
    "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
    "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
  ],
  "Effect": "Allow",
  "Resource": "*"
}
```

## See also

+ [Latest `awscli` documentation](http://docs.aws.amazon.com/cli/latest/reference/)
+ [Latest Elastic Beanstalk documentation](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)
