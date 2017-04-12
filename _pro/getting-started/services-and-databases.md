---
title: Supported Services and Databases
layout: page
weight: 33
tags:
  - docker
  - jet
  - configuration
  - services
  - databases

redirect_from:
  - /docker/services-and-databases/
---

* include a table of contents
{:toc}

Through Docker we support many different databases and services you can use for your build. By adding them to your `codeship-services.yml` file you have a lot of control on how to set up your build environment.

Before reading through the documentation please take a look at the [Services]({% link _pro/getting-started/services.md %}) and [Steps]({% link _pro/getting-started/steps.md %}) documentation page so you have a good understanding how services and steps on Codeship work. At first we want to show you how to customize a service or database container so it has the exact configuration you need for your build.

## Customizing a service container

The following example will start a Ruby and Elasticsearch container and make Elasticsearch available to the Ruby container. The Elasticsearch container will get a customized configuration file that is added by building it with a `Dockerfile.elasticsearch` Dockerfile.

At first the configuration file we want to use in our Elasticsearch container. It makes sure that the Elasticsearch container does not build a cluster with other containers. Store this in for example `config/elasticsearch.yml` in your repository.

```yaml
node:
  local: true
  name: ci
```

Now we create a Dockerfile that starts from an Elasticsearch base container and adds our configuration file.

```
FROM elasticsearch:1.7

ADD config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
RUN chown elasticsearch:elasticsearch /usr/share/elasticsearch/config/elasticsearch.yml
```

The following `codeship-services.yml` uses the `Dockerfile.elasticsearch` we just created to build our container and link it to a ruby container.

```yaml
ruby:
  image: ruby:2.2
  links:
    - elasticsearch
elasticsearch:
  build:
    name: my_project/elasticsearch
    dockerfile: Dockerfile.elasticsearch
```

Now we have a fully customized instance of Elasticsearch running. This same process applies to any other service or database you might be using. To see how to customize them take a look at the specific Dockerfiles that are used to create the service you want to use.

## Waiting for a service to start

Before starting your tests you want to make sure that your service is up and running. The following script will check for Postgres and Redis to be ready and accept connections. You can use this script to add any further checks for other services. You can connect checks with `&&`. The list of supported containers below has tools that help you to test your service for availability. Make sure to set all necessary environment variables used in the commands.

```bash
#!/usr/bin/env bash

function test_postgresql {
  pg_isready -h "${POSTGRESQL_HOST}" -U "${POSTGRESQL_USER}"
}

function test_redis {
  redis-cli -h "${REDIS_HOST}" PING
}

count=0
# Chain tests together by using &&
until ( test_postgresql && test_redis )
do
  ((count++))
  if [ ${count} -gt 50 ]
  then
    echo "Services didn't become ready in time"
    exit 1
  fi
  sleep 0.1
done
```

## Selection of supported containers

Here is a list of containers customers typically use to set up their environment. For further software you want to use during your build you can explore the [Docker Hub](https://hub.docker.com/) or send us an email to [our support team](mailto:support@codeship.com).

### PostgreSQL
Use the [official Postgres container](https://hub.docker.com/_/postgres/).

#### Postgis
For Postgis the [Postgis community contributed container](https://hub.docker.com/r/mdillon/postgis/) can be used.

#### Availability

Addition to your Dockerfile:

```
RUN apt-get update && apt-get install -y postgresql-common postgresql-client
```

Command to run:

```bash
pg_isready -h "${POSTGRESQL_HOST}" -U "${POSTGRESQL_USER}"
```

### MySQL and MariaDB
Use the [official MySQL container](https://hub.docker.com/_/mysql/).

Use the [official MariaDB container](https://hub.docker.com/_/mariadb/).

#### Availability

Addition to your Dockerfile:

```
RUN apt-get update && apt-get install -y mysql-client
```

Command to run:

```bash
mysqladmin -h "${MYSQL_HOST}" ping
```

### Redis
Use the [official Redis container](https://hub.docker.com/_/redis/).

#### Availability

Addition to your Dockerfile:

```
RUN apt-get update && apt-get install -y redis-tools
```

Command to run:

```bash
redis-cli -h "${REDIS_HOST}" PING
```

### MongoDB
Use the [official MongoDB container](https://hub.docker.com/_/mongo/).

#### Availability

Addition to your Dockerfile:

```
RUN apt-get update && apt-get install -y curl
```

Command to run:

```bash
curl "http://${MONGO_HOST}:${MONGO_PORT}"
```

### Memcached
Use the [official Memcached container](https://hub.docker.com/_/memcached/).

#### Availability

Addition to your Dockerfile:

```
RUN apt-get update && apt-get install -y netcat
```

Command to run:

```bash
echo "flush_all" | nc -w1 "${MEMCACHE_HOST}" "${MEMCACHE_PORT}"
```
