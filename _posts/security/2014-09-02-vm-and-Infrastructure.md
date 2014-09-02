---
title: VM and Infrastructure
layout: page
tags:
  - security
  - infrastructure
categories:
  - security
---
## [OS & Virtualization](#virtualization){:name="virtualization"}
We use **Ubuntu 12.10** as our base image for the host as well as the test machines. To virtualize the test machines we use **Linux Containers**.

**Every build gets a new completely clean virtual machine.** Changes done to the filesystem during the build are stored on a temporary filesystem in memory so your code never touches a harddrive and is completely removed as soon as we shut down the virtual machine.

## [Firewall](#firewall){:name="firewall"}
All incoming ports except for ssh port 22 are rejected by default. Outgoing port 25 (SMTP) is closed by default so Codeship can't be used for spamming.
