---
title: Installing the Jet CLI
shortTitle: Installing the Jet CLI
menus:
  pro/jet:
    title: Installation
    weight: 2
tags:
  - jet
  - usage
  - cli
  - pro
---

## Requirements

In order to run the _Jet_ binary on your computer, you need Docker installed and configured, with a running Docker host.

### Mac OS X

If you have [Homebrew](http://brew.sh/) and [Homebrew-Cask ](https://caskroom.github.io/) installed, you can run the following command to install `jet`:

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

### Linux

```bash
curl -SLO "{{ site.data.jet.base_url }}/{{ site.data.jet.version }}/jet-linux_amd64_{{ site.data.jet.version }}.tar.gz"
sudo tar -xaC /usr/local/bin -f jet-linux_amd64_{{ site.data.jet.version }}.tar.gz
sudo chmod +x /usr/local/bin/jet
```

### Windows

There is no supported Jet version for Windows machines, although [Windows Subsystem For Linux](https://blogs.msdn.microsoft.com/wsl/) works for many of our customers.

### Validating Installation

Once installed, check that _Jet_ is working by running `jet version`:

```bash
$ jet version
{{ site.data.jet.version }}
```

### Docker Configuration
<!-- TODO add details to this section -->
`DOCKER_HOST` must be set.

`DOCKER_TLS_VERIFY` and `DOCKER_CERT_PATH` are respected in the same way as with the official Docker client.

If you installed Docker via [Docker For Mac](https://docs.docker.com/docker-for-mac/) this is typically done by default during installation.

If you installed and configured your Docker environment via [Docker Machine](https://docs.docker.com/machine/) (and you are on OS X or Linux) and named the environment _dev_, running the following command will set those variables.

```bash
eval $(docker-machine env dev)
```
