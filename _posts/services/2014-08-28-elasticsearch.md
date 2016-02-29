---
title: ElasticSearch
layout: page
tags:
  - services
  - elasticsearch
categories:
  - services
---
Elasticsearch **1.2.2** is installed on the default port and doesn't require any credentials. However, it is not running by default. To use the Elasticsearch during your builds, start the service via the following command:

```shell
sudo /etc/init.d/elasticsearch start
```

<div class="info-block">
Note, that this is one of the only commands available via `sudo` and root access to run any other commands is not available on the build VMs.
</div>

## Special use cases

If you need to install a later version or use custom configuration, please take a look at the script provided at
[codeship/scripts](https://github.com/codeship/scripts/blob/master/packages/elasticsearch.sh).
