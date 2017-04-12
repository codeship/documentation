---
title: Getting Started With Codeship Basic
layout: page
tags:
  - getting started
  - codeship basic

---

* include a table of contents
{:toc}

## About Codeship Basic

Codeship Basic makes it easy and simple to get a working CI/CD process running through an easy-to-configure web UI and turnkey deployments.

This article will walk you through setting up a Codeship Basic project.

## Creating Your Account

To create your account and project, you will just need to connect a repository to Codeship. [We have a guide here]({{ site.baseurl }}{% link _general/account/new-user-signup.md %}) for how to do that.

Since this article is about setting up a Codeship Basic project, you'll want to be sure to select the Basic infrastructure when adding your project.

![Select Basic Infrastructure]({{ site.baseurl }}/images/basic-guide/select-infra.png)

## Configuring Your Setup Commands

After selecting the Basic infrastructure for your project, Codeship will next ask you to configure your setup and test commands.

First, you will configure your setup commands. Setup commands are the commands you need to be able to run your tests and deployments. Typically these are things like fetching dependencies and seeding database.

![Setup Commands on Codeship Basic]({{ site.baseurl }}/images/basic-guide/setup-commands.png)

**Note** that Codeship provides a list of popular setup commands for many common languages in the dropdown, but you can enter in your own commands as needed.

## Configuring Your Test Commands

Next, you will enter in your test commands. These are all tests you want to have run in your CI/CD pipeline, and all deployments you configure will be contingent on these tests passing.

![Setup Commands on Codeship Basic]({{ site.baseurl }}/images/basic-guide/test-commands.png)

## Configuring Your Deployments

Now that you've defined your setup and test commands, you'll want to define your deployment pipelines. Deployment pipelines run only when a build's setup and tests commands have completed successful _and_ only when the branch defined for the deployment is matched. We call them deployment pipelines rather than deployments because you can have different deployment destinations - perhaps staging and master environments - triggered by different branches.

Defining the branches that will trigger your deployment pipelines is the first step. You can either match a specific branch - i.e. `master` - or you can choose to match any branch that _starts with_ a [specific string]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}).

![Add New Deployment Pipeline on Codeship Basic]({{ site.baseurl }}/images/basic-guide/add-new-deployment.png)

### Turnkey Deployments

After specifying which branch triggers your new deployment pipeline, you can choose to use one of Codeship's turnkey deployment integrations or to use your own custom script deployment.

If you want to use one of Codeship's turnkey deployment integrations, just click on your host provider and provide the necessary account credentials as requested.

![Add New Deployment Pipeline on Codeship Basic]({{ site.baseurl }}/images/basic-guide/turnkey-deployments.png)

### Custom Script Deployments

If you don't want to use one of the turnkey deployment integrations, you can instead use your own custom script deployment. From the list of deployment targets, just select the last option - Custom Script.

![Custom Script Deployment on Codeship Basic]({{ site.baseurl }}/images/basic-guide/custom-script-deployment.png)

From there you will be presented with a command window, just like when you entered your setup and test commands, in which you can define what deployment scripts or commands you would like to run.

![Custom Script Deployment on Codeship Basic]({{ site.baseurl }}/images/basic-guide/custom-script-deployment-bash.png)

### Multiple Deployment Steps

It's worth noting that for each deployment pipeline, you can add multiple deployments or multiple deployment steps. For instance, you can have one deployment on a `master` pipeline that runs your deployment scripts followed by another pipeline that runs notification scripts.

To add multiple steps or deployments to a pipeline, just click on an additional deployment target and specify as needed. You can then use the simple drag-and-drop interface to arrange the deployment commands in the order you need them to run in.

![Custom Script Deployment on Codeship Basic]({{ site.baseurl }}/images/basic-guide/multiple-deployments.png)

## Common Questions

### Caching

Codeship Basic has an automatic, built-in dependency cache, meaning we cache the packages directory for the most common dependency management systems, like NPM and Rubygems. You can clear your dependency cache at any time via the sidebar.

![Reset Dependency Cache]({{ site.baseurl }}/images/basic-guide/reset-dependency-cache.png)

### Skipping Builds

By using the string `--skip-ci` in your commit message, you can instruct Codeship not to run a build for a particular commit. You can learn more about this [here]({{ site.baseurl }}{% link _basic/getting-started/skipping-builds.md %})

### Parallelizing

Codeship offers the option to upgrade your Basic account with additional parallel test pipelines, allowing you to run multiple test commands simultaneously as a way to speed up your builds.

![Parallel test pipelines on Codeship Basic]({{ site.baseurl }}/images/basic-guide/two-pipelines.png)

You can sign up for a free ParallelCI trial from the sidebar or [get in touch with us](mailto:solutions@codeship.com) to discuss configuration options.

### Infrastructure

Codeship Basic builds run on fresh VMs provisioned on Ubuntu Trusty. You can learn more about our infrastructure setup [here]({{ site.baseurl }}{% link _general/about/vm-and-infrastructure.md %})
