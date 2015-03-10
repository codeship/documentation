---
title: Deploy to AWS CodeDeploy
layout: page
tags:
  - deployment
  - amazon
  - codedeploy
categories:
  - continuous-deployment
---

## General
[AWS CodeDeploy](http://aws.amazon.com/codedeploy/) is a service that automates code deployments to Amazon EC2 instances.

## Prerequisites

This deployment method does not create the required configuration on AWS CodeDeploy, neither does it configure the S3 Bucket needed to upload new versions of your application. Please configure those by hand before you deploy for the first time.

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
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::YOUR_S3_BUCKET_NAME/*"
            ]
        }
    ]
}
```

### CodeDeploy

Finally you also need to provide us with the rights to actually create new application revisions, create new deployments, update the deployment configuration and get the status of a deployment. The following snippet for CodeDeploy sets the minimum required rights. Please note, that you need to adapt the snippet to your specific configuration (e.g. setting the proper AWS region, your AWS account id and application name and other deployment configs).

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:RegisterApplicationRevision",
                "codedeploy:GetApplicationRevision"
            ],
            "Resource": [
                "arn:aws:codedeploy:YOUR_AWS_REGION:YOUR_AWS_ACCOUNT_ID:application:CODE_DEPLOY_APPLICATION_NAME"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetDeployment"
            ],
            "Resource": [
                "arn:aws:codedeploy:YOUR_AWS_REGION:YOUR_AWS_ACCOUNT_ID:deploymentgroup:CODE_DEPLOY_APPLICATION_NAME/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:GetDeploymentConfig"
            ],
            "Resource": [
                "arn:aws:codedeploy:YOUR_AWS_REGION:YOUR_AWS_ACCOUNT_ID:deploymentconfig:CodeDeployDefault.OneAtATime",
                "arn:aws:codedeploy:YOUR_AWS_REGION:YOUR_AWS_ACCOUNT_ID:deploymentconfig:CodeDeployDefault.HalfAtATime",
                "arn:aws:codedeploy:YOUR_AWS_REGION:YOUR_AWS_ACCOUNT_ID:deploymentconfig:CodeDeployDefault.AllAtOnce"
            ]
        }
    ]
}
```

You can see an example of a policy in this [gist](https://gist.github.com/flomotlik/b33a5399ba1a3512797d).

## Configuration

Add a new deployment for the branch you want to deploy and choose **AWS CodeDeploy** as the deployment method. You'll then see a form like in the following screenshot.

![AWS CodeDeploy Setup]({{ site.baseurl }}/images/continuous-deployment/aws_codedeploy_setup.png)

Fill out your AWS credentials, the region you want to deploy the application to, as well as the name of your CodeDeploy application, the deployment group and the name (and possible subfolders) of an S3 bucket to use to cache archives of your source code before deploying.

Save the deployment via the green checkmark in the upper right corner and you're good to go.

If you have specific _Deployment Configs_ you can provide one via clicking on _more options_ and providing the name in the appropriate field.

## Further Reading

+ [AWS CodeDeploy](http://aws.amazon.com/codedeploy/)
+ [AWS CodeDeploy Documentation](http://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html)
+ AWS Blog: [New AWS Tools for Code Management and Deployment](https://aws.amazon.com/blogs/aws/code-management-and-deployment/)
+ Codeship Blog: [The AWS CodeDeploy Integration on Codeship](http://blog.codeship.com/aws-codedeploy-codeship/)
