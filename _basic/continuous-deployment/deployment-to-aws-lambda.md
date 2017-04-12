---
title: Deploy to AWS Lambda
weight: 10
layout: page
tags:
  - deployment
  - amazon
  - lambda

redirect_from:
  - /continuous-deployment/deployment-to-aws-lambda/
---

* include a table of contents
{:toc}

## General
[AWS Lambda](http://aws.amazon.com/lambda/)  is a compute service that runs your code in response to events and automatically manages the compute resources for you, making it easy to build applications that respond quickly to new information.

## Prerequisites

This deployment method does not create the required configuration on AWS Lambda. Please configure this by hand before you deploy for the first time. You can read more about setting up your first function on the [AWS Lambda Documentation](http://docs.aws.amazon.com/lambda/latest/dg/welcome.html).

## IAM Policies

It is generally a good idea to create a separate [IAM user](http://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html) for Codeship when deploying to AWS. This allows you to explicitly control which resources Codeship can access during your builds. Please take note of the **Access Key ID** and **Secret Access Key** created during the process, as you'll need this when configuring the deployment.

### Lambda

To deploy into Lambda we need to make sure you’ve given us the correct permissions to deploy into it. Add the following policy to the AWS account which you use for deploying the Lambda function.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "lambda:InvokeFunction",
                "lambda:GetFunction",
                "lambda:PublishVersion",
                "lambda:UpdateAlias"
            ],
            "Resource": [
                "arn:aws:lambda:YOUR_AWS_REGION:YOUR_AWS_ACCOUNT_ID:function:YOUR_FUNCTION_NAME"
            ]
        }
    ]
}
```

## Environment Variables

You need to add the following environment variables to your project:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION

## Deployment

When you go to the Deploy settings of your repository in your Codeship account you now have to add a Script deployment. In the Script deployment, first put the new code you want to deploy into a zip file and then push it to AWS Lambda.

After pushing to Lambda we're publishing a new version of the function and updating a previously created Lambda alias `PROD`. Through versioning and aliasing of functions you could introduce more complex deployment scenarios. One would be to first setting a `STAGING` alias, invoking it with example data to make sure the function executes properly and only then setting the `PROD` alias to the newly deployed version. For more information on Aliases and Versioning check out the [Lambda documentation](http://docs.aws.amazon.com/lambda/latest/dg/versioning-aliases.html).

To test that the function works we’ll invoke it after the deployment. We're using `PROD` as a qualifier to execute the alias we just set. The same command can also be run from your local machine with the invoke script in the repo you’ve forked. Make sure you have permissions set locally that allow you to invoke a function on AWS Lambda.

Following you can see the list of commands to use and how they’ve been added to a script deployment on Codeship.

```bash
pip install awscli
# Preparing and deploying Function to Lambda
zip -r LambdaTest.zip LambdaTest.js
aws lambda update-function-code --function-name LambdaTest --zip-file fileb://LambdaTest.zip

# Publishing a new Version of the Lambda function
version=`aws lambda publish-version --function-name LambdaTest | jq -r .Version`

# Updating the PROD Lambda Alias so it points to the new function
aws lambda update-alias --function-name LambdaTest --function-version $version --name PROD

aws lambda get-function --function-name “LambdaTest”

# Invoking Lambda function from update PROD alias
aws lambda invoke --function-name LambdaTest --payload "$(cat data.json)" --qualifier PROD lambda_output.txt

cat lambda_output.txt
```


## Further Reading

+ [AWS Lambda](http://aws.amazon.com/lambda/)
+ [AWS Lambda Documentation](http://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
+ [Integrating AWS Lambda with Codeship](https://blog.codeship.com/integrating-aws-lambda-with-codeship/)
