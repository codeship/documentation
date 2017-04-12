---
title: Deploy via Custom Script
weight: 6
layout: page
tags:
  - deployment
  - custom
  - scripts

redirect_from:
  - /continuous-deployment/deployment-with-custom-scripts/
---

* include a table of contents
{:toc}

## Using A Custom Script

A custom script deployment is useful if your deployment requires additional or custom commands that are not available with some of Codeship's integrated deployment options.

A custom script deployment is also useful when you need to execute another task after or prior to a deployment. For example:

```shell
# execute rake tasks
bundle exec rake my_rake_task

# run additional tests
# my_test_script.sh lives in the root folder
./my_test_script.sh

# deploy to Amazon S3 or any other server with ssh access
# you can define your keys in the environment variables
```

Please follow these steps to create a custom deployment script:

#### Step 1

Navigate to your project's deployment configuration page by selecting _Project Settings_ > _Deployment_ on the top right side of the page.

![Project Settings Deployment]({{ site.baseurl }}/images/continuous-deployment/project_configuration.png)

#### Step 2

Edit an existing deployment pipeline or create a new deployment pipeline by selecting + _Add new deployment pipeline_. Create the deployment pipeline to match the exact name of your deployment branch or a [wildcard branch]({{ site.baseurl }}/continuous-deployment/wildcard-deployment-pipelines/).

![Create branch deploy]({{ site.baseurl }}/images/continuous-deployment/create_deploy_branch.png)

#### Step 3

Select _Custom Script_

![Select Custom Script]({{ site.baseurl }}/images/continuous-deployment/custom_deploy_script_select.png)

#### Step 4

Insert your deployment commands in the _Deployment Commands_ box shown below. Then click **Create Deployment** to save your custom deployment script.

![Create Custom Script]({{ site.baseurl }}/images/continuous-deployment/create_custom_deploy_script.png)

### Success!

![Custome Deployment Success]({{ site.baseurl }}/images/continuous-deployment/custom_script_success.png)

You have now successfully created a custom deployment script. Go ahead and push a commit to your configured deploy branch. If you have any further questions, please create a post on the [Codeship Community](https://community.codeship.com/) page.
