---
title: Deployment with AWS CLI
layout: page
tags:
  - deployment
  - aws
  - cli
  - amazon
categories:
  - classic-infrastructure
---
The AWS CLI tool does NOT come pre-installed on Codeship Classic infrastructure's build machines.

Please add the following command in the Setup Command section of your test settings to install the AWS CLI tool:

```bash
pip install awscli
```

Please visit [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/) for more information including CLI references.

If you would like a simpler way to deploy to AWS, Codeship also offers integrated deployment with [Elastic Beanstalk]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-to-elastic-beanstalk%}), [CodeDeploy]({{ site.baseurl }}{% post_url continuous-deployment/2014-11-10-deployment-to-aws-codedeploy%}), and S3.
