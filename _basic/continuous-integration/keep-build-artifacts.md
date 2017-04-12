---
title: Keeping Build Artifacts
weight: 60
tags:
  - faq
  - artifacts

redirect_from:
  - /continuous-integration/keep-build-artifacts/
---

* include a table of contents
{:toc}

For security reasons Codeship doesn't keep any artifacts from your builds besides the build log shown on the website. If you want to keep artifacts, you need to push them to a remote server during your builds.

## Upload artifacts to S3

If you want to upload artifacts to S3 during your test steps, you can use the AWS CLI. First add the following environment variables to your project configuration.

```shell
AWS_DEFAULT_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

then add the following commands to the your setup / test steps

```shell
pip install awscli
aws s3 cp artifact.zip s3://mybucket/artifact.zip
```

For more advanced usage of the S3 CLI, please see the [S3 documentation](http://docs.aws.amazon.com/cli/latest/reference/s3/index.html) on amazon.com

**Note** that you can simply add another integrated S3 deployment after your actual deployment if you only want to keep artifacts for specific branches.

## Upload through SFTP

Each project has its own public key which you'll find in your project settings on the *General* page. You can use this key to grant access to your storage provider for Codeship or upload files through SFTP.
