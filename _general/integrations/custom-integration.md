---
title: Integrating A Tool Or Service With Codeship
shortTitle: Creating Custom Service Integrations
tags:
  - continuous integration
  - integrations
menus:
  general/integrations:
    title: Custom Integrations
    weight: 16
---

* include a table of contents
{:toc}

## Using Third-Party Tools Services

If you want to use a third-party tool or service with Codeship that we do not currently have examples or documentation set up for, it is usually fairly easy to get an integration working once you understand the necessary concepts for using external services.

## Codeship Pro

### Adding Keys And Tokens

If the service or tool you are integrating requires something like an API key or authentication token to be set as an environment variable, you will do this via a project's [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) that are encrypted and included in the [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

**Note** that environment variables are loaded at runtime, so they are only available after your services have built and become available. If you have a token (such as an SSH key) that instead needs to be available at buildtime for use inside the project's Dockerfile, you will instead need to use [encrypted build arguments]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}) which are available at buildtime.

### Tooling And Environment

The Codeship Pro build environment is defined in a project's [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}). This file uses Docker images, or Dockerfiles included in the repository, to build the containers that run all the commands in the CI/CD pipeline that are specified in the other required file - [codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

Due to the fact that the containers built from the service definitions in the [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) execute all of the commands in the pipeline, any packages or environment-specific setup must be defined via this file as well as the project's Dockerfiles.

As one example of this, if you have a CLI tool that is required to execute the tool's commands, you will need the CLI to be installed via the project's Dockerfile so that when the [codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) passes the necessary command to that service the container has the tooling it needs to execute the command.

### Executing Commands

All commands on Codeship Pro are executed via the project's [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}). If the tool or service you are integrating has commands that must be directly called, you can do that as a new step, such as:

```bash
- name: your_service
  service: service_name
  command: service command here
```

You can also place these types of commands as scripts that you include in the repository instead, if you need to chain multiple commands together in a single step. For example:

```bash
- name: your_service
  service: service_name
  command: command.sh
```

As covered above, all of the steps take place _inside_ the containers you define in the `service` portion of the step. So, as long as that container is capable of executing the script or command you are passing it, it will execute without issue.

The step itself is complete when an exit code is surfaced to Codeship. An exit code `0` means the step is successful, whereas any other exit code means the step has failed and the build will be stopped.

## Codeship Basic

### Adding Keys And Tokens

If the service or tool you are integrating requires something like an API key or authentication token to be set as an environment variable, you will do this via a project's [environment variables]({{ site.baseurl }}{% link _basic/builds-and-configuration/set-environment-variables.md %}).

You can do this by navigating to _Project Settings_ and then clicking on the _Environment_ tab.

### Tooling And Environment

Codeship Basic builds run on shared virtual machines with tooling preinstalled. A user can install any package that they need via the project's [setup commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}), but may not install anything that requires `sudo` or root access.

As an example if your project has a CLI that is required to be installed for the tool's commands to execute, you will need to install the CLI (without `sudo` or root) via the project's [setup commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}) so that you may call the commands you need in the [test commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}) section.

### Executing Commands

All commands on Codeship Basic are executed via the project's [setup and test commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}). Setup commands happen before any tests are run, while test commands happen only after setup is complete.

**Note** that you should consider that tests can run in parallel when determine if a command should be a setup command or a test command, as well as whether it shoudl execute only in one potential test pipeline or if it should execute in multiple test pipelines.
