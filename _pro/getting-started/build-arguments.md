---
title: "Tutorial: Build Arguments"
layout: page
weight: 46
tags:
  - docker
  - tutorial

---

* include a table of contents
{:toc}

## Overview: Build Arguments
For each service, you can declare [build arguments](https://docs.docker.com/compose/compose-file/#/args), which are values available to the image only at build time. For example, if you must pass the image a set of credentials in order to access an asset or repository when the image is built, you would pass that value to the image as a build argument.

## Build Arguments vs. Environment Variables
During a build on Codeship's Docker platform, there are three ways to pass custom values to your services:

* Build arguments or encrypted build arguments: available only at image build time
* ENV variable declared in Dockerfile: available at build time and runtime
* environment or encrypted environment: available only at runtime

Build arguments are unique in that they are available only at build time. They are not persisted in the image. However, you may assign a build argument to an environment variable during the build process, and that environment variable will be available.

## Using Unencrypted Build Arguments with Codeship
Declaring build arguments in your services file requires updates in two places: the service's Dockerfile and the `codeship-services.yml` file.

### Dockerfile ARG instruction
The service's Dockerfile must include the `ARG` [instruction](https://docs.docker.com/engine/reference/builder/#/arg), which declares the name of the argument you will pass at build time. You may also declare a default here.

```bash
FROM ubuntu:latest

ARG build_env # build_env=test would make test the default value

RUN script-requiring-build-env.sh "$build_env"
```

### Passing build args in the services file
Now that the Dockerfile knows to expect an argument, you can pass the argument to the image via the service configuration in `codeship-services.yml`.

```bash
app:
  build:
    dockerfile: Dockerfile
    args:
      build_env: staging
```

When the `app` service is built, the value of `build_env` becomes `staging`. If no value was set, `build_env` would remain `test`. You are not required to declare a default, but you must add an `ARG` instruction to the Dockerfile for each build argument you pass in via `codeship-services.yml`.

Note: YAML boolean values (true, false, yes, no, on, off) must be enclosed in quotes, so that the parser interprets them as strings.

## Encrypted Build Arguments
In a lot of cases, the values needed by the image at build time are secrets -- credentials, passwords, and other things that you don't want to check in to source control in plain text. Because of this, Codeship supports encrypted build arguments. You can either encrypt a build argument individually, or encrypt an entire file containing all of the build arguments you need.

First, create a file in the root directory - in this case, a file named `build_args`. You will also need to [download the project AES key]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}) to root directory (and add it to the `.gitignore` file.)

```bash
GEM_SERVER_TOKEN=XXXXXXXXXXXX
SECRET_BUILDTIME_PASSWORD=XXXXXXXXXXXX
```

Take care to use `KEY=value` syntax and not `key: value`.

Once the AES key is in the root directory, run the `jet encrypt` command with an *input* and an *output* filename: `jet encrypt build_args build_args.encrypted` ([Learn more about using Jet]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}))

Pass that file to your service's build directive.

```yaml
app:
  build:
    dockerfile: Dockerfile
    encrypted_args_file: build_args.encrypted
```

If your use case is simple enough, you may want to pass in encrypted values directly instead of requiring Codeship to read them from a file. The following syntax is also supported:

```yaml
app:
  build:
    dockerfile: Dockerfile
    encrypted_args: 8rD1P1xO1CwB4L99JBqnvoSOX+1wimf9qwHXATf9foasPtU6Sw==
```

Codeship will decrypt your build arguments and pass them to the image when it is built.

## Impact on Docker Image Caching
Docker will attempt to reuse layers of your image if there are no changes. Although the values of a build argument are not persisted to the image, they do impact the build cache in a similar way. Refer to Docker's [notes on cache invalidation](https://docs.docker.com/engine/reference/builder/#/impact-on-build-caching) when using build arguments.

## Common Error Messages
`One or more build-args [XXX] were not consumed`

If you pass a build argument to an image at build time, but do not have a corresponding `ARG` instruction in the Dockerfile, Docker (versions < 1.13) will fail the image build.

As of 1.13, unused build args will not fail the build, but will generate a warning message.
