---
title: VM And Infrastructure Specifics
shortTitle: VM And Infrastructure
menus:
  general/about:
    title: VM & Infrastructure Specifics
    weight: 2
tags:
  - security
  - infrastructure
  - linux
  - firewall
  - virtual machine
  - build machine
redirect_from:
  - /security/vm-and-infrastructure/
---

* include a table of contents
{:toc}

## Build machines

### Codeship Basic

Codeship Basic uses **Ubuntu 14.04 (Trusty Tahr)** on our test machines. To virtualize the test machines we use **Linux Containers**.

**Every build gets a new completely clean virtual machine.** Changes done to the filesystem during the build are stored on a temporary filesystem in memory so your code never touches a harddrive and is completely removed as soon as we shut down the virtual machine.

### Codeship Pro

All Codeship Pro builds run on dedicated, single tenant build machines, on individual EC2 instances, in the **US-East-1** region.

The Codeship Pro build environment is configurable depending on plan and available in the following configurations:

**Small**: 2 CPUs, 3.75gb RAM
**Medium**: 4 CPUs, 7.5gb RAM
**Big**: 8 CPUs, 15gb RAM
**Huge**: 16 CPUs, 30gb RAM
**Massive**: 32 CPUs, 60gb RAM

### Docker Version On Codeship Pro

On Codeship Pro, builds run on infrastructure equipped with version {{ site.data.docker.version }} of Docker.

## Firewall
All incoming ports are rejected by default except port 22, which is open to allow [SSH debug sessions]({{ site.baseurl }}{% link _basic/builds-and-configuration/ssh-access.md %}). Outgoing port 25 (SMTP) is closed by default so Codeship can't be used for spamming.

## Disk Space
All builds on both Codeship Basic and Codeship Pro have 10gb of disk space allocation for the build environment.

## System Timeouts

On **Codeship Basic**, a build can run for up to 3 hours, although builds will time out if there is no log activity for 10 minutes.

On **Codeship Pro**, a build can run for up to 2 hours, although builds will time out if there is no log activity for 15 minutes.
