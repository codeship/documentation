---
title: Installing the Jet CLI
menus:
  pro/jet:
    title: Installation
    weight: 1
categories:
  - Jet CLI
tags:
  - jet
  - install
  - cli
  - pro
---

## Prerequisites

In order to run the `jet` binary on your computer, you need to have Docker installed and configured, with a running Docker host such as [Docker For Mac](https://docs.docker.com/docker-for-mac/).

## Installing Jet

Please follow the steps below for the operating system you are using. See the [Jet Release Notes]({{ site.baseurl }}{% link _pro/jet-cli/release-notes.md %}) for the ChangeLog.

See the [sha256sums]({{ site.data.jet.base_url }}/{{ site.data.jet.version }}/sha256sums) file for checksums for the latest release. To check the downloaded files on Linux / Unix based systems run the following command.

```shell
shasum -c -a 256 sha256sums
```

### Installing Jet On Mac OS X

The `jet` CLI is now included in our custom [Homebrew Cask](https://github.com/codeship/homebrew-taps/tree/master/Casks). If you already have [Homebrew installed](http://brew.sh/) you can install `jet` by running the following command

```shell
brew cask install codeship/taps/jet

# If you already have the CLI installed and want to update to the latest version
brew update
brew cask reinstall codeship/taps/jet
```

If you don't have Homebrew installed or don't use Homebrew Cask you can install `jet` via the following commands.

```shell
curl -SLO "{{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-darwin_amd64_{{ site.data.jet.version }}.tar.gz"
tar -xC /usr/local/bin/ -f jet-darwin_amd64_{{ site.data.jet.version }}.tar.gz
chmod u+x /usr/local/bin/jet
```

### Installing Jet On Linux

```shell
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

```shell
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

```shell
eval $(docker-machine env dev)
```
