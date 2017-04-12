---
title: Continuous Delivery to AWS with Docker
weight: 47
tags:
  - deployment
  - aws
  - docker

redirect_from:
  - /docker-integration/aws/
---

<div class="info-block">
You can find a sample repo for deploying to AWS with Codeship Pro on Github [here](https://github.com/codeship-library/aws-utilities).
</div>

* include a table of contents
{:toc}

To make it easy for you to deploy your application to AWS we've built a container that has the AWSCLI installed. We will set up a simple example showing you how to configure any deployment to AWS.

## Codeship AWS deployment container

The AWS deployment container lets you plugin your deployment tools without the need to include that in the testing or even production container. That keeps your containers small and focused on the specific task they need to accomplish in the build. By using the AWS deployment container you get the tools you need to deploy to any AWS service and still have the flexibility to adapt it to your needs.

The container configuration is open source and can be found in the [codeship-library/aws-deployment](https://github.com/codeship-library/aws-deployment) project on GitHub. It includes a working example that uses the AWSCLI as part of an integration test before we push a new container to the Docker Hub.

We will use the `codeship/aws-deployment` container throughout the documentation to interact with various AWS services.

## Using other tools

While the container we provide for interacting with AWS gives you an easy and straight forward way to run your deployments it is not the only way you can interact with AWS services. You can install your own dependencies, write your own deployment scripts, talk to the AWS API directly or bring 3rd party tools to do it for you. By installing those tools into a Docker container and running them you have a lot of flexibility in how to deploy to AWS.

## Authentication

Before setting up the `codeship-services.yml` and `codeship-steps.yml` file we're going to create an encrypted environment file that contains the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

Take a look at our [encrypted environment files documentation]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}) and add a `aws-deployment.env.encrypted` file to your repository. The file needs to contain an encrypted version of the following file:

```bash
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

You can get the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` from the IAM settings in your [AWS Console](https://console.aws.amazon.com/console/home). You can read more about this in the [IAM documentation](http://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html). Do not use the admin keys provided to your main AWS account and make sure to limit the access to what is necessary for your deployment through IAM.

## Service Definition

Before reading through the documentation please take a look at the [Services]({% link _pro/getting-started/services.md %}) and [Steps]({% link _pro/getting-started/steps.md %}) documentation page so you have a good understanding how services and steps on Codeship work.

The `codeship-services.yml` file uses the `codeship/aws-deployment` container and sets the encrypted environment file. Additionally it sets the `AWS_DEFAULT_REGION` through the environment config setting. We set up a volume that shares `./` (the repository folder) to `/deploy`. This gives us access to all files in the repository in `/deploy/...` for the following steps.

```yaml
awsdeployment:
  image: codeship/aws-deployment
  encrypted_env_file: aws-deployment.env.encrypted
  environment:
    - AWS_DEFAULT_REGION=us-east-1
  volumes:
    - ./:/deploy
```

## Deployment examples

To interact with different AWS services you can simply call the `aws` command directly. You can use any AWS service or command provided by the [AWSCLI](https://aws.amazon.com/cli/). You can use environment variables or command arguments to set the AWS Region or other parameters. Take a look at their (environment variable documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment).

Take a look at the [Steps]({% link _pro/getting-started/steps.md %}) documentation page so you have a good understanding how steps on Codeship work and how to set it up in your `codeship-steps.yml`.

### S3

In the following example we're uploading a file to S3 from the source repository which we access through the host volume at `/deploy`. Add the following into your `codeship-steps.yml`.

```yaml
- service: awsdeployment
  command: aws s3 cp /deploy/FILE_TO_DEPLOY s3://SOME_BUCKET
```

### Deploying to EC2 Container Service

To interact with ECS you can simply use the corresponding AWS CLI commands. The following example will register two new task definitions and then update a service and run a batch task. In the following example the deployment is running one after the other, but with our parallelization feature you could start both deployments at the same time as well to gain more speed. Our [Steps]({% link _pro/getting-started/steps.md %}) documentation can give you more information on that.

If you have more complex workflows for deploying your ECS tasks you can put those commands into a script and run the script as part of your workflow. Then you could stop load balancers, gracefully shut down running tasks or anything else you would like to do as part of your deployment.

We're using the task definitions from the [AWSCLI ECS docs](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI.html#AWSCLI_run_task)

Add the following to your `codeship-steps.yml`

```yaml
- service: awsdeployment
  command: aws ecs register-task-definition --cli-input-json file:///deploy/tasks/backend.json
- service: awsdeployment
  command: aws ecs update-service --service my-backend-service --task-definition backend
- service: awsdeployment
  command: aws ecs register-task-definition --cli-input-json file:///deploy/tasks/process_queue.json
- service: awsdeployment
  command: aws ecs run-task --cluster default --task-definition process_queue --count 5
```

### Deploying to AWS Elastic Beanstalk
Deployment to Elastic Beanstalk is very straightforward. We implemented a `codeship_aws eb_deploy` command in the `codeship/aws-deployment` container so you can get started quickly. The arguments you have to set are the path to your deployable folder, the Elastic Beanstalk application and environment name, and the S3 bucket to which to upload the zipped artifact.

The following example can be used in your `codeship-steps.yml` to deploy to Elastic Beanstalk.

```yaml
- service: awsdeployment
  command: codeship_aws eb_deploy PATH_TO_FOLDER_TO_DEPLOY APPLICATION_NAME ENVIRONMENT_NAME S3_BUCKET_NAME
```

The command will zip up the content in the folder, upload it to S3, register a new version with Elastic Beanstalk and then deploy that new version. We're also validating that the environment is fine and that the new version was actually deployed.

If you want to customize the deployment you can also use the [existing Script](https://github.com/codeship-library/aws-utilities/blob/master/deployment/scripts/codeship_aws_eb_deploy) from our open source AWS container and edit it so it fits exactly to your needs. This script can be added to your repository and then called directly as a step, as in the following example:

```yaml
- service: awsdeployment
  command: /deploy/scripts/deploy_to_eb
```

To make sure the AWS credentials you've added before are authorized to deploy to Elastic Beanstalk use the following policies in IAM.

#### S3 Policy

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

#### Elastic Beanstalk Policy

Please replace `[region]` and `[accountid]` with the respective values for your AWS account / Elastic Beanstalk application.

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
     "s3:GetBucketPolicy"
   ],
   "Effect": "Allow",
   "Resource": [
    "arn:aws:s3:::Elastic Beanstalk-[region]-[accountid]",
    "arn:aws:s3:::Elastic Beanstalk-[region]-[accountid]/*"
   ]
  }
 ]
}
```

If you are using more than one instance for your application you need to add at least the following permissions as well.

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

## Deploying to CodeDeploy

To deploy your application to AWS CodeDeploy you can use the integrated `codeship_aws codedeploy_deploy` command. It will zip your application code, upload it to S3 and start a new deployment on CodeDeploy. You can take a look at the [full script](https://github.com/codeship-library/aws-deployment/blob/master/scripts/codeship_aws_codedeploy_deploy) in the [codeship-library/aws-deployment](https://github.com/codeship-library/aws-deployment) repository on Github.

Add the following to your codeship-steps.yml to start deploying.

```yaml
- service: awsdeployment
  command: codeship_aws codedeploy_deploy /PATH/TO/YOUR/CODE APPLICATION_NAME DEPLOYMENT_GROUP_NAME S3_BUCKET_NAME
```

Make sure to add policies to your IAM User used with Codeship that allow to interact with CodeDeploy. Take a look at the [getting started](http://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-setup.html) documentation from AWS to get the full policy template.

## See also

+ [Latest `awscli` documentation](http://docs.aws.amazon.com/cli/latest/reference/)
+ [Latest Elastic Beanstalk documentation](http://docs.aws.amazon.com/Elastic Beanstalk/latest/dg/Welcome.html)


### Combining deployment to various services with a script

If you want to interact with various AWS services in a more complex way you can do this by setting up a deployment script and running it inside the container. The following script will upload different files into S3 buckets and then trigger a redeployment on ECS. The deployment script can access any files in your repository through `/deploy`. In the following example we're putting the script into `scripts/aws_deployment`.

```bash
#!/bin/bash

# Fail the build on any failed command
set -e

aws s3 sync /deploy/assets s3://my_assets_bucket
aws s3 sync /deploy/downloadable_resources s3://my_resources_bucket

# Register a new version of the task defined in tasks/backend.json and update
# the currently running instances
aws ecs register-task-definition --cli-input-json file:///deploy/tasks/backend.json
aws ecs update-service --service my-backend-service --task-definition backend

# Register a task to process a Queue
aws ecs register-task-definition --cli-input-json file:///deploy/tasks/process_queue.json
aws ecs run-task --cluster default --task-definition process_queue --count 5
```

And the corresponding `codeship-steps.yml`:

```yaml
- service: awsdeployment
  command: /deploy/scripts/aws_deployment
```
