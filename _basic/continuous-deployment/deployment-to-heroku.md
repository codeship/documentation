---
title: Deploy to Heroku
weight: 1
layout: page
tags:
  - deployment
  - heroku

redirect_from:
  - /continuous-deployment/deployment-to-heroku/
---

* include a table of contents
{:toc}

Codeship makes makes it easy to deploy your application to Heroku using Codeship's integrated [deployment pipelines]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}).

* include a table of contents
{:toc}

## Setup Heroku Deployment

### Step 1 - Navigate to Deployment Configuration
Navigate to your project's deployment configuration page by selecting _Project Settings_ > _Deployment_ on the top right side of the page.

![Project Settings Deployment]({{ site.baseurl }}/images/continuous-deployment/project_configuration.png)

### Step 2 - Add New Deployment Pipeline
Edit an existing deployment pipeline or create a new deployment pipeline by selecting + _Add new deployment pipeline_. Create the deployment pipeline to match the exact name of your deployment branch or a [wildcard branch]({{ site.baseurl }}/continuous-deployment/wildcard-deployment-pipelines/).

![Create branch deploy]({{ site.baseurl }}/images/continuous-deployment/create_deploy_branch.png)

### Step 3 - Heroku
Select _Heroku_

![Select Heroku]({{ site.baseurl }}/images/continuous-deployment/select_heroku.png)


### Step 4 - Deployment Configuration

![Configure Heroku]({{ site.baseurl }}/images/continuous-deployment/configure_heroku.png)

#### Application URL
Insert the name of the Heroku application you want the pipeline to deploy to.

#### Heroku API Key
In order for you to deploy your app using Codeship, you need to provide the Heroku API key from your Heroku account. You can access your Heroku API key [here](https://dashboard.heroku.com/account).

### Success!

![Heroku Success]({{ site.baseurl }}/images/continuous-deployment/heroku_success.png)

You have now successfully setup deployment to Heroku. Go ahead and push a commit to your configured deploy branch.

## Additonal Configuration Settings (optional)
You can configure additional settings to your Heroku deployment by selecting **More Options**:

![Select Heroku Deploy Options]({{ site.baseurl }}/images/continuous-deployment/select-heroku-deploy-options.png)

![Heroku Deploy Options]({{ site.baseurl }}/images/continuous-deployment/heroku-deploy-options.png)

#### URL
After each deployment, we check your application to make sure that it is up. We will either call the default `*.herokuapp.com` URL or the URL you specified here.

If this URL requires **basic auth** please enter: `http://YOUR_USERNAME:YOUR_PASSWORD@YOUR_URL`

#### Restore
This takes a different Heroku app and will restore the database of the current Heroku application you are deploying to with the main database from the Heroku application posted here.

#### Backup Database
Backup your database before you deploy. See Heroku's [Creating a Backup](https://devcenter.heroku.com/articles/heroku-postgres-backups#creating-a-backup) page for more information.

#### Force Push
This causes git to disable some checks and can cause the remote repository to lose commits. Use this option with care.

See [git push -f](https://git-scm.com/docs/git-push) for more info.

#### Run Migrations (Ruby on Rails only)
You can specify to run the migration during the Heroku deployment. If you want to run your migration after the deployment, you can add a [custom script]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %}) after the Heroku deployment and run the migration.

**Example**:

```shell
heroku run --exit-code --app ${HEROKU_APPLICATION_NAME} -- bundle exec rake db:migrate
```

![Heroku Migration After Deploy]({{ site.baseurl }}/images/continuous-deployment/heroku-migration-after-deploy.png)

#### Check app URL
This will enable your build to check the URL of your application to make sure that it is up.

## Troubleshooting
- [check_url fails when deploying to Heroku]({{ site.baseurl }}{% link _general/projects/check_url-fails-for-heroku-deployment.md %})
