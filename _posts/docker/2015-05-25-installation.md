---
title: Running Codeship's Jet Locally for Development
layout: page
weight: 75
tags:
  - docker
  - jet
  - introduction
  - installation
  - running locally
categories:
  - docker
---

<div class="info-block">


Jet is used to locally debug and test builds for Codeship's Docker-based infrastructure, as well as to assist with several important tasks like encrypting secure credentials. If you are using Codeship's hosted (non-Docker) infrastructure, you will not need to use Jet.
</div>

* include a table of contents
{:toc}

## What is Jet?

Jet is a CLI tool designed to make working with Codeship's Docker infrastructure faster and easier, as well as to put more power in a developer's hands so that there is less time spent configuring and debugging projects via a web UI.

Jet allows you to run your CI/CD pipeline on your local machine, making it much faster to test your configuration, troubleshoot errors and discover the best setup for your project. By default, Jet skips image pushes and deployments but you can instruct it not to skip them with special options.

You can also pass a variety of environment and setup variables, making Jet a powerful way to simulate your CI/CD process without having to wait for the full push/run/feedback cycle of a real build.

Jet also allows you to encrypt your project's environment variables and image repository credentials, helping you keep your critical information secure without impacting the flexibility of your CI/CD process.

## Prerequisites

In order to run the _Jet_ binary on your computer, you need to have Docker installed and configured. We recommend you follow the guides regarding [Docker Toolbox](https://www.docker.com/toolbox) to get both Docker Engine and Docker Machine installed, as well as a Docker host configured.

## Jet

Please follow the steps below for the operating system you are using. See the [Jet Release Notes]({{ site.baseurl }}{% post_url docker/jet/2015-07-16-release-notes %}) for the ChangeLog.

See the [sha256sums]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/sha256sums) file for checksums for the latest release. To check the downloaded files on Linux / Unix based systems run the following command.

```bash
shasum -c -a 256 sha256sums
```

### Mac OS X

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

### Linux

```bash
curl -SLO "{{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-linux_amd64_{{ site.data.jet.version }}.tar.gz"
sudo tar -xaC /usr/local/bin -f jet-linux_amd64_{{ site.data.jet.version }}.tar.gz
sudo chmod +x /usr/local/bin/jet
```

### Windows

Please download the version (`{{ site.data.jet.version }}`) from [our download site]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-windows_amd64_{{ site.data.jet.version }}.tar.gz). Once you have done this, you need to extract the archive and copy the binary to your path.

### Dynamically linked version

The above version is statically linked and will work the same way on all platforms. But it doesn't support certain features, e.g. resolving `.local` DNS names. If your builds require this, please use the dynamically linked version instead.

* [Mac OS X]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-darwin_amd64_{{ site.data.jet.version }}-dynamic.tar.gz)
* [Linux]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-linux_amd64_{{ site.data.jet.version }}-dynamic.tar.gz)
* [Windows]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-windows_amd64_{{ site.data.jet.version }}-dynamic.tar.gz)

## Validating Installation

Once this is done you can check that _Jet_ is working by running `jet help`. This will print output similar to the following.

```bash
$ jet version
{{ site.data.jet.version }}
$ jet help
Usage:
  jet [command]
...
```

## Docker Configuration

`DOCKER_HOST` must be set. `DOCKER_TLS_VERIFY` and `DOCKER_CERT_PATH` are respected in the same way as with the official Docker client.

If you installed and configured your Docker environment via [Docker Machine](https://docs.docker.com/machine/) (and you are on OS X or Linux) and named the environment _dev_, running the following command will set those variables.

```bash
eval $(docker-machine env dev)
```

## Using Jet

Now that you have Jet installed and configured, [learn how to use it.]({{ site.baseurl }}{% post_url docker/jet/2015-05-25-cli %})

## Questions
If you have any further questions, please create a post on the [Codeship Community](https://community.codeship.com) page.
