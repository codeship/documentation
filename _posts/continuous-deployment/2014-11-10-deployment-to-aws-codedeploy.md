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

This deployment method is not yet able to create the required configuration on AWS CodeDeploy, neither does it configure the S3 Bucket needed to upload new versions of your application. Please configure those by hand before you deploy for the first time.

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
