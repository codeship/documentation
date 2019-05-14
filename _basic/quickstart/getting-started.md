---
title: Getting Started With CodeShip Basic
menus:
  basic/quickstart:
    title: Getting Started
    weight: 1
tags:
  - getting started
  - codeship basic
categories:
  - Quickstart  
  - Guide
  - Configuration
redirect_from:
  - /basic/getting-started/getting-started/
---

* include a table of contents
{:toc}

## Introducing CodeShip Basic

CodeShip Basic makes it easy and simple to get a working CI/CD process running through an easy-to-configure web UI and turnkey deployments.

**CodeShip Basic** is a good place to start if:
- You want out of the box configuration.
- You can use common, pre-installed CI dependencies.
- You would prefer easy, 1-click app integrations.

This article will walk you through setting up a CodeShip Basic project. For a video introduction to CodeShip Basic, you can view our [overview video](https://codeship.com/features/basic).

## Setting up continuous integration with CodeShip Basic

### Prerequisites

CodeShip requires that you set up a CodeShip Account and connect to a Source Content Management (SCM).
See [Setting Up A New CodeShip Account Guide ]({{ site.baseurl }}{% link _general/account/new-user-signup.md %}) for more information.


### Configuring your setup commands

Setup commands are the commands needed to run your tests and deployments. Examples of setup commands include fetching dependencies and seeding the database.

To configure your setup commands:

1. Select the _Tests_ tab in the dashboard.

2. Click the dropdown arrow on the right to see a list of technologies.

3. Either select a technology to pre-populate basic commands or select _I want to create my own custom commands_.

4. If select _I want to create my own custom commands_ then enter setup commands in box. 

5. Either click _Save and go to dashboard_ or _Save Changes_.

![Setup Commands on Codeship Basic]({{ site.baseurl }}/images/basic-guide/setup-commands.png)

**Note** that CodeShip provides a list of popular setup commands for many common languages in the dropdown, but you can enter in your own commands as needed.

### Configuring your test commands

Next, you will enter in your test commands. These are all tests you want to have run in your CI/CD pipeline, and all deployments you configure will be contingent on these tests passing.

![Setup Commands on Codeship Basic]({{ site.baseurl }}/images/basic-guide/test-commands.png)

## Defining your deployment pipeline with CodeShip

Now that you've defined your setup and test commands, you'll want to define your deployment pipelines. Deployment pipelines run only when a build's setup and tests commands have completed successful _and_ only when the branch defined for the deployment is matched. We call them deployment pipelines rather than deployments because you can have different deployment destinations - perhaps staging and master environments - triggered by different branches.

To configure your deployment pipelines:

1. Select the _Deploy_ tab in the dashboard. 

2. Click the dropdown arrow on the right to see a list of ways to configure a branch that triggers the deployment pipeline.

3. Select either _Branch is exactly_ to match a specific branch or select _Branch starts with_ to match any branch that starts with a specific string.

4. Enter branch name in the box.

5. Click the _Save Pipeline Settings_ button.

See [deployment pipeline]({{ site.baseurl }}{% link _basic/builds-and-configuration/deployment-pipelines.md %}) for more information.

![Add New Deployment Pipeline on CodeShip Basic]({{ site.baseurl }}/images/basic-guide/add-new-deployment.png)

### Using pre-configured deployments to deploy to cloud services 

After specifying which branch triggers your new deployment pipeline, you can choose to use one of CodeShip's pre-configured deployment integrations or to use your own custom script deployment.

Click on your host provider and then provide the necessary account credentials to use a pre-configured deployment.

![Add New Deployment Pipeline on CodeShip Basic]({{ site.baseurl }}/images/basic-guide/turnkey-deployments.png)

### Using your own custom deployment scripts to deploy to cloud services

If you don't want to use one of the pre-configured deployment integrations, you can instead use your own custom script deployment.

To use your own custom script deployment:
1. Select the _Custom Script_ button.
![Custom Script Deployment on CodeShip Basic]({{ site.baseurl }}/images/basic-guide/custom-script-deployment.png)
2. Enter your custom deployment script in the box.
![Custom Script Deployment on CodeShip Basic]({{ site.baseurl }}/images/basic-guide/custom-script-deployment-bash.png)
3. Click the _Create Deployment_ button.

### Adding multiple deployment steps

It's worth noting that for each deployment pipeline, you can add multiple deployments or multiple deployment steps. For instance, you can have one deployment on a `master` pipeline that runs your deployment scripts followed by another pipeline that runs notification scripts.

Click on _add new deployment pipeline_ to add multiple steps or deployments to a pipeline.  You can then use the simple drag-and-drop interface to arrange the deployment commands in the order you need them to run in.

![Custom Script Deployment on Codeship Basic]({{ site.baseurl }}/images/basic-guide/multiple-deployments.png)

## Running a build

### Configuring build triggers

You can trigger a build when committing, merging, and pushing tags to your project. This is default behavior. You can also trigger a build when opening, merging, and updating a Pull Request (PR). See [Configuring Build Triggers]({{ site.baseurl }}{% link _general/projects/build_trigger.md %}) for more information.

### Skipping a build

You can skip builds on both CodeShip Basic and CodeShip Pro by using a special commit directive. See [Skipping Builds]({{ site.baseurl }}{% link _general/projects/skipping-builds.md %}) for more information.

## Speeding up a build

### Using the cache to speed up a build

CodeShip Basic has an automatic, built-in dependency cache, meaning we cache the packages directory for the most common dependency management systems, like NPM and Rubygems. You can clear your dependency cache at any time.

To clear your dependency cache:

1. Select _Builds_ from the top-level navigation.

2. Click the drop down arrow from the Build box. 

3. Select _Reset Cache_.

![Reset Dependency Cache]({{ site.baseurl }}/images/basic-guide/reset-dependency-cache.png)

### Creating parallel test pipelines to speed up a build 

CodeShip offers the option to upgrade your Basic account with additional parallel test pipelines, allowing you to run multiple test commands simultaneously as a way to speed up your builds.

You can sign up for a free Parallel Test Pipelines Trial by clicking _Add Pipeline_ or [get in touch with us](mailto:codeship-solutions@cloudbees.com) to discuss configuration options.
![Parallel test pipelines on Codeship Basic]({{ site.baseurl }}/images/basic-guide/two-pipelines.png)

## Troubleshooting 

### Clearing the cache

You can clear the cache to help clear failing builds. 

### Opening a SSH debug session

In order to troubleshoot issues, CodeShip provides command line access to a replicated instance of your build. The SSH debug session will include all configured variables from the original build run.  See [Debugging builds via SSH]({{ site.baseurl }}{% link _basic/builds-and-configuration/ssh-access.md %}) for more information.

### System timeouts

If a command runs for longer than 10 minutes without printing any log output, the command and build will be automatically failed. Additionally, if a build runs for longer than 3 hours, it will be automatically failed.

## Additional information 

### Accessing CodeShip using the API

If you're looking to automate more of your processes, you can access your projects and builds via the CodeShip API. See the [CodeShip API Documentation]({{ site.baseurl }}{% link _general/integrations/api.md %}) for more details and examples.

### Scripts library

We maintain a [scripts library](https://github.com/codeship/scripts) with scripts for common packages, deployments and other useful workflow improvements on CodeShip Basic.

If you're looking for a specific tool or version, the scripts library is a great first place to check.



### CodeShip infrastructure

CodeShip Basic builds run on fresh VMs provisioned on Ubuntu 18.04 (Bionic). You can learn more about our infrastructure setup [here]({{ site.baseurl }}{% link _general/about/vm-and-infrastructure.md %}).

