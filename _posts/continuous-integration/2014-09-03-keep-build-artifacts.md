---
title: Keeping Build Artifacts
tags:
  - faq
  - artifacts
categories:
  - continuous-integration
---
You can push artifacts generated during your build to S3 or any other storage provider.

## Upload artifacts to S3

To upload artifacts to S3 you can use the ```awscli```.

~~~shell
# in your test commands or script deployment
pip install awscli
aws s3 cp artifact.zip s3://mybucket/artifact.zip
~~~

Additionally you need to add your AWS keys in your environment variables.

~~~shell
# in your environment variables
AWS_DEFAULT_REGION=us-east-1
AWS_ACCESS_KEY_ID=<access_key_id>
AWS_SECRET_ACCESS_KEY=<secret_access_key>
~~~

Check out the [S3 documentation](http://docs.aws.amazon.com/cli/latest/reference/s3/index.html). for more information.

We don't keep your artifacts on the Codeship: After your build is finished we delete all data for security reasons.

As an example learn [how we deploy our documentation to S3](http://blog.codeship.com/middleman-s3-deploy/).

## Upload through SFTP

Each project has its own public key which you'll find in your project settings on the ***General*** page. You can use this key to grant access to your storage provider for Codeship or upload files through SFTP.
