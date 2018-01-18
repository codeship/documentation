---
title: jet run
menus:
  pro/jet:
    title: jet run
    weight: 8
categories:
  - Jet CLI
tags:
  - jet
  - run
  - cli
  - pro
---

## Description
Run a command inside a service container.

## Usage

```
jet run SERVICE [COMMAND [ARGS...]] [flags]
```

## Flags
{% include flags.html flags=site.data.jet.flags.run %}

## Extended description

The `jet run` command will build and execute a service from the [codeship-services.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) file, or run a single command.

This is a good way to debug your services

For instance, you can run `jet run service_app` or `jet run service_app echo "hello"` where `service_app` is one of the services defined in your [codeship-services.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).


## Examples

### Debugging a Build

You can debug your builds locally by first executing `jet run`, then connect to your running containers to manually run the commands from your [codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) file.

As an example, the following will start your service, display the container ID, and then connect to the running container using the container ID.

```shell
$ jet run PRIMARY_SERVICE_NAME
$ docker ps -a
$ docker exec CONTAINERID
```
