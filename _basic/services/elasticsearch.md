---
title: Elasticsearch
layout: page
tags:
  - services
  - elasticsearch
redirect_from:
  - /services/elasticsearch/
  - /classic/getting-started/elasticsearch/
---

* include a table of contents
{:toc}

Elasticsearch **1.2.2** is installed on the default port **9200** and doesn't require any credentials. However, it is not running by default. To use Elasticsearch during your builds, start the service via the following command:

```shell
sudo /etc/init.d/elasticsearch start
```

<div class="info-block">
Note, this is one of the only commands available via `sudo` and root access to run any other commands is not available on the build VMs.
</div>

## Additional Versions

If you need to install a later version or use a custom configuration, please take a look at [this script](https://github.com/codeship/scripts/blob/master/packages/elasticsearch.sh).

For example if you wanted to install **5.2.0** you would set the desired version as an [environment variable]({{ site.baseurl }}{% link _basic/getting-started/set-environment-variables.md %}) in your project.

```shell
ELASTICSEARCH_VERSION=5.2.0
```

Next, make sure the following commands are added to your _Setup Commands_ as Elasticsearch 5.x requires them.

```shell
jdk_switcher home oraclejdk8
jdk_switcher use oraclejdk8
```

Finally add [this command](https://github.com/codeship/scripts/blob/master/packages/elasticsearch.sh#L6) to your _Setup Commands_ and the script will automatically be called at build time. Note, this script will automatically start the Elasticsearch service, so you do not need to call the sudo command mentioned above.
