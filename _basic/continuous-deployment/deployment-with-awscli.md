---
title: Deployment with AWS CLI
weight: 7
layout: page
tags:
  - deployment
  - aws
  - cli
  - amazon

redirect_from:
  - /continuous-deployment/deployment-with-awscli/
---

* include a table of contents
{:toc}

## Setup

The AWS CLI tool does NOT come pre-installed on Codeship Basic build machines.

Please add the following command in the Setup Command section of your test settings to install the AWS CLI tool:

```bash
pip install awscli
```

Please visit [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/) for more information including CLI references.

If you would like a simpler way to deploy to AWS, Codeship also offers integrated deployment with [Elastic Beanstalk]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-to-elastic-beanstalk.md %}), [CodeDeploy]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-to-aws-codedeploy.md %}), and S3.
