---
title: VM and Infrastructure
layout: page
tags:
  - security
  - infrastructure
categories:
  - general
---
## OS & Virtualization
We use **Ubuntu 14.04 (Trusty Tahr)** on our test machines. To virtualize the test machines we use **Linux Containers**.

**Every build gets a new completely clean virtual machine.** Changes done to the filesystem during the build are stored on a temporary filesystem in memory so your code never touches a harddrive and is completely removed as soon as we shut down the virtual machine.

## Firewall
All incoming ports except for ssh port 22 are rejected by default. Outgoing port 25 (SMTP) is closed by default so Codeship can't be used for spamming.
