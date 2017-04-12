---
title: VM and Infrastructure
layout: page
tags:
  - security
  - infrastructure

redirect_from:
  - /security/vm-and-infrastructure/
---

## OS & Virtualization

**Note:** The following information is specific to Codeship Basic. Codeship Pro has several build instance configurations that vary according to account setup.

We use **Ubuntu 14.04 (Trusty Tahr)** on our test machines. To virtualize the test machines we use **Linux Containers**.

**Every build gets a new completely clean virtual machine.** Changes done to the filesystem during the build are stored on a temporary filesystem in memory so your code never touches a harddrive and is completely removed as soon as we shut down the virtual machine.

## Firewall
All incoming ports except for ssh port 22 are rejected by default. Outgoing port 25 (SMTP) is closed by default so Codeship can't be used for spamming.

## Disk Space
All builds on both Codeship Basic and Codeship Pro have 10gb of disk space allocation for the build environment.
