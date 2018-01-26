---
title: Deployment With AWS CLI
menus:
  basic/cd:
    title: AWS CLI
    weight: 7
tags:
  - deployment
  - aws
  - cli
  - amazon
categories:
  - Continuous Deployment    
redirect_from:
  - /continuous-deployment/deployment-with-awscli/
---

* include a table of contents
{:toc}

## AWS Deployments

Codeship Basic offers a variety of turnkey deployment integrations for AWS, including:


- [CodeDeploy]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-to-aws-codedeploy.md %})
- [Lambda]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-to-aws-lambda.md %})
- [Elastic Beanstalk]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-to-elastic-beanstalk.md %})
- [S3]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-to-aws-codedeploy.md %})

These are the simplest ways to deploy to AWS via Codeship Basic.

## Using The CLI

If the deployment integrations do not work for you due to additional need for flexibility or need to use an undocumented AWS service, you can always install and use the AWS CLI directly onto a Codeship Basic build machine similar to how you might use the CLI locally.

You will need to install the CLI, configure your authentication via environment variables and then define the CLI commands you want to run as a [custom-script deployment pipeline]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %}).

### Installing The CLI

The AWS CLI tool does NOT come pre-installed on Codeship Basic build machines.

Please add the following command in the Setup Command section of your test settings to install the AWS CLI tool:

```shell
pip install awscli
```

### Configuring Authentication

Once the CLI is installed, you will need to run the appropriate AWS CLI login commands via your project's [setup commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}) or at the start of your [custom-script deployment pipeline]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %}).

The easiest way to keep these authentication secure would be to use [environment variables]({{ site.baseurl }}{% link _basic/builds-and-configuration/set-environment-variables.md %}) to store the username and password, and to pass those through to your AWS CLI login commands.

### Deployment Scripting

You will need to create a new [custom-script deployment pipeline]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %}) to run the AWS CLI commands you need for your deployment.

These commands will be run every time the branch the deployment pipeline is associated with is updated. They are not Codeship specific and will be standard AWS CLI input.

## AWS CLI Information

Please visit [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/) for more information on using the AWS CLI as well as complete documentation on what commands can be run with it.
