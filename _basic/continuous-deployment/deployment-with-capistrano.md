---
title: Deploy via Capistrano
layout: page
tags:
  - deployment
  - capistrano

redirect_from:
  - /continuous-deployment/deployment-with-capistrano/
---

* include a table of contents
{:toc}

You can deploy any kind of Application with Capistrano. For detailed information about Capistrano check [capistranorb.com](http://capistranorb.com). Don't forget to [include Capistrano](#capistrano-is-not-installed-by-default) in your projects as it's not preinstalled on our build servers.

## Capistrano on Codeship

When your Capistrano task is ready and working, you just need to add the _Capistrano Deployment_ on Codeship. You simply specify the task we should run for you, which most often is something similar to `production deploy` (or another stage depending on the current branch).

![Capistrano]({{ site.baseurl }}/images/continuous-deployment/capistrano_deployment_setup.png)

Checkout our [Deployment Pipelines]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}) if you want to add multiple Capistrano Deployments.

## Capistrano with a script-based deployment

You don't need to use our Capistrano Integration. If you have a more complex Deployment Setup you can call Capistrano directly.

```bash
gem install capistrano
bundle exec cap $STAGE deploy
```

## Common Errors

### Authentication fails

Usually Capistrano relies on a SSH connection to copy files and execute remote commands. If connecting to your server fails with an error message (e.g. asking for a password), please take a look at our [documentation on authenticating via SSH public keys]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-ftp-sftp-scp.md %}) for more information.

### Capistrano is not installed by default

If you don't have Capistrano in your `Gemfile` you need to install it first. Simply add the following command to a script based deployment which runs before the Capistrano deployment.

```bash
gem install capistrano
```

### Deployment fails because of detached checkout

Because Codeship only fetches the last 50 commits as well as checks out your repository in detached head mode, Capistrano may fail the deployment. If this is the case for your setup, please add the following two commands to your deployment script. They will fetch the full history of the repository and switch to the branch you are currently testing.

```bash
git fetch --unshallow || true
git checkout "${CI_BRANCH}"
```
