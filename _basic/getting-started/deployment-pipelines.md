---
title: Deployment Pipelines
layout: page
tags:
  - deployment

redirect_from:
  - /continuous-deployment/deployment-pipelines/
  - /basic/getting-started/wildcard-deployment-pipelines/
---

* include a table of contents
{:toc}

## What Are Deployment Pipelines?

On Codeship, you are able to define **deployment pipelines**. A deployment pipeline is a set of deployment commands, or a deployment integration, configured to run whenever code is updated on a specific branch (such as `master`).

Every time you push a new commit or tag to this branch, or merge a pull request into this branch, a build will kick off that will run your deployment pipeline if all other setup and test command steps are successfully. Most projects will have at least one deployment pipeline, for deploying your code after successfully running your tests.

## Using Deployment Pipelines

To set up your deployment pipelines, go to the ***Deployment*** page of your project settings to set up your deployment.

Add a branch that you would like to deploy and save it.
![Create Deployment Branch]({{ site.baseurl }}/images/continuous-deployment/create_branch.png)

Choose your hosting provider or deployment method.
![Choose Deployment]({{ site.baseurl }}/images/continuous-deployment/choose_deployment.png)

Fill out the deployment configuration and click the green checkmark on the top right of your deployment to save it.
![Save Deployment]({{ site.baseurl }}/images/continuous-deployment/save_deployment.png)

On the next push to this branch (in this case 'master') the deployment will be triggered under the condition that all setup and test commands pass successfully.
![Saved Deployment]({{ site.baseurl }}/images/continuous-deployment/saved_deployment.png)

Now you can add additional deployments or configure another deployment pipeline.

### Deployment Integrations

As part of our deployment pipelines, Codeship provides turnkey deployment integrations for many common hosting providers, such as AWS Elastic Beanstalk, Heroku, Google App Engine and more.

To use a deployment integration, just click on the logo of your provider after creating your pipeline and add your authentication and configuration information as required.

![Create Deployment Branch]({{ site.baseurl }}/images/basic/deployment-integration.png)

### Custom Script Deployments

While Codeship does provide many helpful deployment integrations, you may find that you want to run your own commands or your own custom scripts as part of a deployment pipeline.

You can use the [Script Deployment]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %}) to run your custom deployment commands or to execute other tasks right after or before a deployment. These will run as part of a deployment pipeline exactly as any of our deployment integrations would, but will rely on your scripts to provide exit status codes of `0` or any non-zero status code to indicate that they have either passed or failed.

### Multi-Step Deployment Pipelines

You can add **multiple deployments within one deployment pipeline**. One easy example of this type of workflow would be to run your deployment commands and then, if they are successful, run post-deployment notification scripts. This process is easy to fully automated on Codeship. Note, though, that it is **not** possible to run multiple deployments in parallel.
</div>

![Multiple Deployments]({{ site.baseurl }}/images/continuous-deployment/multiple_deployments.png)

### Wildcard Branch Deployment Pipelines

When you add a new branch to be deployed you can choose whether you are specifying an **exact branch name** or if this is a **wildcard deployment**.

For the latter select _Branch starts with_ from the dropdown and then specify the common part of the branches you want to deploy.

![Wildcard Deployment Pipeline Configuration]({{ site.baseurl }}/images/continuous-deployment/wildcard_deployment_pipelines_configuration.png)

Using a wildcard deployment, you can specify it to run a deployment on any branch that _starts with_ a string. For instance:

- Run deployments on builds that _start with_ `features/dev-name-1/`. In this scenario, `features/dev-name-1/test-case` **would** trigger a build, but `features/dev-name-2/test-case` would **not**.

### Creating Additional Deployment Pipelines

It is likely that you will want multiple deployment pipelines, for instance one to deploy to a staging environment from your `staging` branch and another to deploy to your production environment from your `master` branch.

To create separate deployment pipeline for another branch, click on "Add a branch to deploy" and enter the branch name.
![Add additional Branch]({{ site.baseurl }}/images/continuous-deployment/add_additional_branch.png)

After saving the deployment pipeline you can add your deployment methods for that branch.
![Additional Branch]({{ site.baseurl }}/images/continuous-deployment/second_branch.png)


### Editing Branch Specifications

By clicking on "Edit Branch Settings" you can change the branch name or delete that branch.
