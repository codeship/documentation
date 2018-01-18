---
title: Using the Jet CLI
shortTitle: Using the Jet CLI
description: Technical documentation for Codeship Pro's CLI (Jet) that allows to debug and run builds locally on the development machine
menus:
  pro/jet:
    title: Using the Jet CLI
    weight: 2
tags:
  - docker
  - jet
  - introduction
  - installation
  - running locally
  - debug
  - setup
  - troubleshooting
  - cli
categories:
- Jet CLI
redirect_from:
  - /docker/installation/
  - /pro/installation/
  - /pro/getting-started/installation/
  - /docker/cli/
  - /pro/cli/
  - /jet/
  - /docker/getting-started/installation/
  - /pro/builds-and-configuration/cli/
---

<div class="info-block">
  <p>This article is about the local CLI tool that you can use to test and debug your Codeship Pro builds and configuration files as well as to encrypt your [environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) and [build arguments]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}).</p>

  <p>If you are unfamiliar with Codeship Pro, we recommend our [getting started guide]({{ site.baseurl }}{% link _pro/quickstart/quickstart-examples.md %}) or [the features overview page](http://codeship.com/features/pro).</p>

  <p>Note that if you are using Codeship Basic, you will not be able to use the local CLI.</p>
</div>

## jet

To list available commands, run `jet` with no parameters, `jet -h` or `jet --help`:

```shell
$ jet

Usage:
  jet [command]

Available Commands:
  decrypt
  encrypt
  generate
  load
  run
  steps
  version

Flags:
  -h, --help   help for jet

Use "jet [command] --help" for more information about a command.
```

## Description
By default, Docker will use existing images when running `jet` locally. This may lead to builds passing locally, and failing remotely on Codeship. This is due to the remote environment starting without any prior images. We recommend removing any locally saved Docker images prior to running `jet steps` for a more consistent result to the remote server.

## Examples

### Display help text
To list the help for any command, execute the command followed by the `-h` or `--help` flag.

```shell
$ jet steps -h
Run steps

Usage:
  jet steps [flags]

Flags:
      --ci-branch string                  The name of the branch being built
      --ci-build-id string                The id of the build being run
...
```

### Option types

#### Multi
Some flags like -e=[ ] may be used multiple times in a single command line, for example:

```shell
$ jet steps -e foo=bar -e baz=qux
```

#### String and Integers
Some flags require a string like `--ci-branch` and can only be specified once.

```shell
$ jet steps --ci-branch master
```
