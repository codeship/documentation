---
title: Deploy to Google App Engine
weight: 3
layout: page
tags:
  - deployment
  - google app engine

redirect_from:
  - /continuous-deployment/deployment-to-google-app-engine/
---

* include a table of contents
{:toc}

You can deploy your [Java]({{ site.baseurl }}{% link _basic/languages-frameworks/java-and-jvm-based-languages.md %}),[Python]({{ site.baseurl }}{% link _basic/languages-frameworks/python.md %}), [NodeJS]({{ site.baseurl }}{% link _basic/languages-frameworks/nodejs.md  %}) , or [Go]({{ site.baseurl }}{% link _basic/languages-frameworks/go.md %}) applications to Google App Engine through Codeship.

## Setup Google App Engine Deployment

### Step 1

Navigate to your project's deployment configuration page by selecting _Project Settings_ > _Deployment_ on the top right side of the page.

![Project Settings Deployment]({{ site.baseurl }}/images/continuous-deployment/project_configuration.png)

### Step 2

Edit an existing deployment pipeline or create a new deployment pipeline by selecting + _Add new deployment pipeline_. Create the deployment pipeline to match the exact name of your deployment branch or a [wildcard branch]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}).

![Create branch deploy]({{ site.baseurl }}/images/continuous-deployment/create_deploy_branch.png)

### Step 3

Select _Google App Engine_

![Select GAE]({{ site.baseurl }}/images/continuous-deployment/select_gae.png)

### Step 4

The first time you want to connect Codeship to Google App Engine we will ask for credentials through OAuth.

![Connect GAE]({{ site.baseurl }}/images/continuous-deployment/connect_gae.png)

You will then be directed to log into your Google account.

### Step 5

Once connected, you will be brought back to your Google App Engine deployment settings page.

#### appcfg Update Path

You can set the path of your `appcfg.*` file in the _Update Path:_ field. If the file exists on the root of your repository, simply leave it blank.

By default we search for a `app.yml` file in the path you've set. If we find it we will use the `appcfg.py` script to upload your application. Otherwise we expect it to be a Java application and use `appcfg.sh`.

#### Application URL

You have the option of adding the URL of your GAE app below to call after the deployment to make sure everything is up and running.

![Configure GAE]({{ site.baseurl }}/images/continuous-deployment/configure_gae.png)

### Success!

![GAE Success]({{ site.baseurl }}/images/continuous-deployment/gae_success.png)

You have now successfully setup deployment to your Google App Engine. Go ahead and push a commit to your configured deploy branch.

## App Engine Authentication Issues

The specific implementation Google App Engines uses to authenticate with other
services like Codeship omits certain information if you re-authenticate.
(Specifically the OAuth [refresh token](https://auth0.com/docs/refresh-token).)

If you encounter authentication problems with your GAE deployments,
please head over to the [Google OAuth Application Settings](https://security.google.com/settings/security/permissions)
page and remove the Codeship application from your account.
Once you've done the above step, disconnecting and reconnecting to App Engine
on [Connected Services](https://codeship.com/authentications) will update your authentication settings
and allow deployments to App Engine.

Please save the deployment settings after reconnecting to GAE to ensure that we use the newly created token.
