---
title: RethinkDB
layout: page
tags:
  - services
  - databases
  - rethinkdb
categories:
  - databases
---

RethinkDB is installed on our test VMs but not running by default. To use the RethinkDB during your builds, start the service via the following command:

```shell
sudo /etc/init.d/rethinkdb start
```

<div class="info-block">
Note, that this is one of the only commands available via `sudo` and root access to run any other commands is not available on the build VMs.
</div>

RethinkDB runs on the default port. Administrative HTTP connections are available via port `50836`.
