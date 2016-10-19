---
title: Deployment Pipelines
layout: page
tags:
  - deployment
categories:
  - classic-infrastructure
---
On Codeship, you are able to define **deployment pipelines**. A deployment pipeline is bound to a branch. Every time a build runs for this branch, it kicks off your deployment pipeline.

Additionally, you can add multiple deployments within one deployment pipeline. This way, you can deploy for example to a staging environment first and only if that succeeds, to the production environment. This process is fully automated on Codeship and in case of errors you'll immediately get notified.

## Set up a deployment pipeline
Go to your the ***Deployment*** page of your project settings to set up your deployment.

Add a branch you want to deploy and save it.
![Create Deployment Branch]({{ site.baseurl }}/images/continuous-deployment/create_branch.png)

Choose your hosting provider or deployment method.
![Choose Deployment]({{ site.baseurl }}/images/continuous-deployment/choose_deployment.png)

Fill in the deployment configuration and click the green checkmark on the top right of your deployment to save it."
![Save Deployment]({{ site.baseurl }}/images/continuous-deployment/save_deployment.png)

On the next push to this branch (in this case 'master') and if all tests pass the deployment will be triggered.
![Saved Deployment]({{ site.baseurl }}/images/continuous-deployment/saved_deployment.png)

Now you can add additional deployments or configure another deployment pipeline.

## Add additional deployment methods

You can add multiple deployments to one deployment pipeline. They will run sequentially and can be ordered by dragging the deployment symbol.
![Multiple Deployments]({{ site.baseurl }}/images/continuous-deployment/multiple_deployments.png)

## Deploy another branch
If you want to create a deployment pipeline for another branch, click on "Add a branch to deploy" and enter the branch name.
![Add additional Branch]({{ site.baseurl }}/images/continuous-deployment/add_additional_branch.png)

After saving the deployment pipeline you can add your deployment methods for that branch.
![Additional Branch]({{ site.baseurl }}/images/continuous-deployment/second_branch.png)

## Edit Branch Settings
By clicking on "Edit Branch Settings" you can change the branch name or delete that branch.

## Use Script Deployment for custom deployments / commands

You can use the [Script Deployment]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-with-custom-scripts %}) to run your custom deployment commands or to execute other tasks right after or before a deployment.
