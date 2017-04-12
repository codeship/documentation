---
title: Running Codeship's Jet Locally for Development
layout: page
weight: 1
tags:
  - docker
  - jet
  - introduction
  - installation
  - running locally

redirect_from:
  - /docker/installation/
  - /pro/installation/
---

<div class="info-block">
Jet is used to locally debug and test builds for Codeship Pro, as well as to assist with several important tasks like encrypting secure credentials. If you are using Codeship Basic, you will not need to use Jet.
</div>

* include a table of contents
{:toc}

## What is Jet?

Jet is a CLI tool designed to make working with Codeship Pro faster and easier, as well as to put more power in a developer's hands so that there is less time spent configuring and debugging projects via a web UI.

## Prerequisites

In order to run the _Jet_ binary on your computer, you need to have Docker installed and configured, with a running Docker host such as [Docker For Mac](https://docs.docker.com/docker-for-mac/).

## Installing Jet

Please follow the steps below for the operating system you are using. See the [Jet Release Notes]({{ site.baseurl }}{% link _pro/getting-started/release-notes.md %}) for the ChangeLog.

See the [sha256sums]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/sha256sums) file for checksums for the latest release. To check the downloaded files on Linux / Unix based systems run the following command.

```bash
shasum -c -a 256 sha256sums
```

### Installing Jet On Mac OS X

The `jet` CLI is now included in [Homebrew Cask](https://caskroom.github.io/). If you already have [Homebrew installed](http://brew.sh/) and the [Caskroom tapped](https://caskroom.github.io/)[^1] you can install `jet` by running the following command

```bash
brew cask install jet
```

The formula will install Docker as well. If you already have Docker installed, but didn't use Homebrew to install it, you will be asked by Homebrew if you want to overwrite the Docker binary. If you don't want to manage Docker via Homebrew, please use the alternative installation method below.

If you don't have Homebrew installed or don't use Homebrew Cask you can install `jet` via the following commands.

```bash
curl -SLO "{{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-darwin_amd64_{{ site.data.jet.version }}.tar.gz"
tar -xC /usr/local/bin/ -f jet-darwin_amd64_{{ site.data.jet.version }}.tar.gz
chmod u+x /usr/local/bin/jet
```

[^1]: Instructions for tapping the _Caskroom_ are at the very bottom of the page.

### Installing Jet On Linux

```bash
curl -SLO "{{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-linux_amd64_{{ site.data.jet.version }}.tar.gz"
sudo tar -xaC /usr/local/bin -f jet-linux_amd64_{{ site.data.jet.version }}.tar.gz
sudo chmod +x /usr/local/bin/jet
```

### Installing Jet On Windows

There is no supported Jet version for Windows machines, although [Windows Subsystem For Linux](https://blogs.msdn.microsoft.com/wsl/) works for many of our customers.

### Dynamically linked version

The above version is statically linked and will work the same way on all platforms. But it doesn't support certain features, e.g. resolving `.local` DNS names. If your builds require this, please use the dynamically linked version instead.

* [Mac OS X]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-darwin_amd64_{{ site.data.jet.version }}-dynamic.tar.gz)
* [Linux]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-linux_amd64_{{ site.data.jet.version }}-dynamic.tar.gz)

### Validating Installation

Once this is done you can check that _Jet_ is working by running `jet help`. This will print output similar to the following.

```bash
$ jet version
{{ site.data.jet.version }}
$ jet help
Usage:
  jet [command]
...
```

### Docker Configuration

`DOCKER_HOST` must be set. `DOCKER_TLS_VERIFY` and `DOCKER_CERT_PATH` are respected in the same way as with the official Docker client. If you installed Docker via [Docker For Mac](https://docs.docker.com/docker-for-mac/) this is typically done by default during installation.

If you installed and configured your Docker environment via [Docker Machine](https://docs.docker.com/machine/) (and you are on OS X or Linux) and named the environment _dev_, running the following command will set those variables.

```bash
eval $(docker-machine env dev)
```

## Using Jet

Now that you have Jet installed and configured, [learn how to use it.]({{ site.baseurl }}{% link _pro/getting-started/cli.md %})

### Jet Steps

The most often used feature of Jet is `jet steps`.

By running `jet steps`, you are running your full CI/CD process on your local machine. This lets you test your builds, configuration files and pipelines locally without having to commit your code.

**Note** that `jet steps` skips [image pushes]({{ site.baseurl }}{% link _pro/getting-started/steps.md %}#push-steps) and any [branch-specific commands]({{ site.baseurl }}{% link _pro/getting-started/steps.md %}#limiting-steps-to-specific-branches--tags) by default, but you can always run `jet steps --help` to see a list of special options you can pass Jet to invoke different CI/CD contexts and behaviors.

### Jet Encrypt

Jet also allows you to encrypt [environment variables]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}), [build arguments]({{ site.baseurl }}{% link _pro/getting-started/build-arguments.md %}) and [registry credentials]({{ site.baseurl }}{% link _pro/getting-started/docker-pull.md %}). This is done with the `jet encrypt` command. Click the links in this paragraph for specific instructions on encrypting different types of secrets.

### Jet Run

While `jet steps` runs your CI/CD pipeline locally, you can also use `jet run` to instead build a single service or run a single command.

For instance, you can run `jet run service_app` or `jet run service_app echo "hello"` where `service_app` is one of the services defined in your [codeship-services.yml]({{ site.baseurl }}{% link _pro/getting-started/services.md %}).

**Note** that you can also run `jet run --help` to see a list of special options you can pass Jet to invoke different CI/CD contexts and behaviors.
