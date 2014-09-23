---
title: Deploy to Elastic Beanstalk
weight: 80
layout: page
tags:
  - deployment
  - elastic beanstalk
categories:
  - continuous-deployment
---
## Prerequisites

This deployment method is not yet able to create Elastic Beanstalk environments, neither does it configure the S3 Bucket needed to upload new versions of your application. Please configure your Elastic Beanstalk environment by hand for your first deploy. All later deployments can than be handled by the scripts provided in this article.

## Configuration

Please add the following variables to the ***Environment*** page in your project configuration.

~~~shell
AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
AWS_DEFAULT_REGION="YOUR_AWS_DEFAULT_REGION"
APP_NAME="YOUR_BEANSTALK_APPLICATION_NAME"
ENV_NAME="YOUR_BEANSTALK_ENVIRONMENT_NAME"
S3_BUCKET="YOUR_S3_BUCKET_FOR_APPLICATION_DEPLOYMENT"
~~~

## Deploy Script

Here is a script (```deploy_beanstalk.sh```) that you can put into your repository. Feel free to adapt and modify it to your specific needs.

Keep in mind that the script resets the working copy to a pristine state. If you precompile assets, be sure to add a build step after the call to ```git clean```.

~~~shell
#!/bin/sh

export APP_VERSION=`git rev-parse --short HEAD`
pip install awscli

# clean build artifacts and create the application archive (also ignore any files named .git* in any folder)
git clean -fd

# precompile assets, ...

# zip the application
zip -x *.git* -r "${APP_NAME}-${APP_VERSION}.zip" .

# delete any version with the same name (based on the short revision)
aws elasticbeanstalk delete-application-version --application-name "${APP_NAME}" --version-label "${APP_VERSION}"  --delete-source-bundle

# upload to S3
aws s3 cp ${APP_NAME}-${APP_VERSION}.zip s3://${S3_BUCKET}/${APP_NAME}-${APP_VERSION}.zip

# create a new version and update the environment to use this version
aws elasticbeanstalk create-application-version --application-name "${APP_NAME}" --version-label "${APP_VERSION}" --source-bundle S3Bucket="${S3_BUCKET}",S3Key="${APP_NAME}-${APP_VERSION}.zip"
aws elasticbeanstalk update-environment --environment-name "${ENV_NAME}" --version-label "${APP_VERSION}"
~~~

Once you added the above script to your repository, you can activate it on the ***Deployment*** page, via the *Custom script* option.

![Beanstalk Deployment Script]({{ site.baseurl }}/images/continuous-deployment/script_beanstalk.png)

## IAM permissions for deploy script
In order to run the deploy script you'll need these IAM permissions, replace the S3 buckets and other names with yours:

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
      "Resource": "arn:aws:sns:us-east-1:334918212912:*"
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
        "cloudformation:UpdateStack"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:cloudformation:us-east-1:334918212912:*"
    },
    {
      "Action": [
        "ec2:DescribeImages",
        "ec2:DescribeKeyPairs"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```
```json
{
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource":"arn:aws:s3:::elasticbeanstalk-us-east-1-334918212912"
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:GetObjectAcl"
      ],
      "Effect": "Allow",
      "Resource":"arn:aws:s3:::elasticbeanstalk-us-east-1-334918212912/*"
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource":"arn:aws:s3:::elasticbeanstalk-env-resources-us-east-1/*"
    },
    {
      "Action": [
        "s3:GetBucketPolicy",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource":"*"
    }
  ]
}
```
## See also

+ [Latest ```awscli``` documentation](http://docs.aws.amazon.com/cli/latest/reference/)
+ [Latest Elastic Beanstalk documentation](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)
