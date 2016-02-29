---
title: Apache Cassandra
layout: page
tags:
  - services
  - databases
  - cassandra
categories:
  - databases
---

The latest version from the `2.0.x` release of [Apache Cassandra](http://cassandra.apache.org/) is installed on the build VMs, but not running by default.

To use the service during your builds, start the service via the following command:

```shell
sudo /etc/init.d/cassandra start
```

<div class="info-block">
Note, that this is one of the only commands available via `sudo` and root access to run any other commands is not available on the build VMs.
</div>

If you require a CLI tool to access or Cassandra server, we would recommend [cqlsh](https://pypi.python.org/pypi/cqlsh) available via pip.

```shell
pip install cqlsh
```
