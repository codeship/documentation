---
title: Services Configuration
layout: page
weight: 32
tags:
  - docker
  - jet
  - configuration
  - services

redirect_from:
  - /docker/services/
---

* include a table of contents
{:toc}

## What Is Your Codeship Services File?
Your services file - `codeship-services.yml` - is where you configure each service you need to run your CI/CD builds with Codeship. During the build, these services will be used to run the testing steps you've defined in your `codeship-steps.yml` [file]({% link _pro/getting-started/steps.md %}). You can have as many services as you'd like, and customize each of them. Each of these services will be run inside a Docker container.

Your services can be built from your own Dockerfiles, or pulled from any registry. Your `codeship-services.yml` will be very similar to a `docker-compose.yml` file, and most of the syntax is compatible.

Running with Docker, your Codeship services allow you to:

* Set up different environments for running your unit, integration, or acceptance tests
* Have control over dependencies and versions of software consumed within the service
* Build specialized deployment images to unify deployment across your company
* Use any Docker image available on an image registry for your builds

Your Codeship builds run on infrastucture equipped with version {{ site.data.docker.version }} of the Docker Engine.

## Prerequisites
Your services file will require that you have [installed Jet locally]({{ site.baseurl }}{% link _pro/getting-started/cli.md %}) or [set up your project on Codeship.]({{ site.baseurl }}{% link _pro/getting-started/codeship-configuration.md %})

## Services File Setup & Configuration
By default, we look for the filename `codeship-services.yml`. In its absense, Codeship will automatically search for a `docker-compose.yml` file to use in its place.

Your services file is written in YAML and is structured similarly to a [Docker Compose](https://docs.docker.com/compose/) file, with each service declared in a block. You may choose to nest your services under a top-level services key, or declare each service in a top-level block. Both examples below are valid:

```yaml
app:
  build: .
  environment:
    ENV: my-var
data:
  image: busybox
  volumes:
    - ./tmp/data:/data
```  


```yaml
version: '2'

services:
  app:
    build: .
    environment:
      ENV: my-var
  data:
    image: busybox
    volumes:
      - ./tmp/data:/data
```

If your file includes a `version`, Codeship will ignore the value, as the features supported by Codeship are version independent.

### Build
Use the `build` directive to build your service's image from a Dockerfile. You [specify a build](https://docs.docker.com/compose/compose-file/#build) in the same way as is standard with Docker Compose, although you can also use an extended version as needed. You can also mix `build` and `image` between services, but not for a single service - i.e. you can build some of your services from one or more Dockerfiles while other services simply download existing images from registries.

```yaml
app:
  build:
    image: codeship/app
    context: app
    dockerfile: Dockerfile
    args:
      build_env: production
```

* `image` specifies the output image name, as opposed to generating one by default.

* `context` is a custom directory that contains a Dockerfile. It also serves as the root directory for any ADD or COPY instructions. If you don't specify a `context`, it will default to the directory of the services file.

* `dockerfile` allows you to specify a specific Dockerfile to use, rather than inheriting one from the build context. It does not, however, change the build context or override the root directory.

* `args`: build arguments passed to the image at build time. [Learn more about build arguments.]({{ site.baseurl }}{% link _pro/getting-started/build-arguments.md %})

* `encrypted_args_file`: an encrypted file of build arguments that are passed to the image at build time. [Learn more about build arguments.]({{ site.baseurl }}{% link _pro/getting-started/build-arguments.md %})


#### Deprecated keys
The functionality of these keys still exists, but the keys themselves have been renamed.
* `path` sets the build context, essentially defining a custom root directory for any ADD or COPY directives (as well as specifying where to look for the Dockerfile). It's important to note that the _Dockerfile_ is searched for relative to that directory. If you don't specify a custom `path`, it will default to the directory of the services file. *Use `context` instead*.
* `dockerfile_path` allows you to specify a specific Dockerfile to use, rather than inheriting one from the build context. It does not, however, change the build context or override the root directory. *Use `dockerfile` instead*.


### Image
Some services are available on the Docker Hub or other registry, and you may want to use those images instead of building your own. To start a service with a Docker image available on a registry, use the `image` key.

```yaml
database:
  image: postgres:latest
```

### Volumes
You can use `volumes` in your `codeship-services.yml` file to persist data between services and steps in your CI/CD process.

An example setup using volumes in your `codeship-services.yml` file would look like this:

```yaml
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  volumes_from:
    - data
data:
  image: busybox
  volumes:
    - ./tmp/data:/data
```

**Note**: volumes should only be mounted from a relative path, as the hosts are ephemeral, and you should not rely on existence of certain directories. Although absolute paths are possible at the moment, we will remove support for them soon.

[Learn more about using volumes.]({{ site.baseurl }}{% link _pro/getting-started/docker-volumes.md %})

### Environment Variables
The standard `environment` and `env_file` directives are supported. Additionally, we support encrypted environment variables with `encrypted_environment` and `encrypted_env_file` directives. These are the same format, but they expect encrypted variables.

An example setup explicitly declaring your environment variables in your `codeship-services.yml` file would look like this:

```
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  environment:
    ENV: string
    ENV2: string
```

An example setup providing your encrypted environment variable file in your `codeship-services.yml` file would look like this:

```
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  encrypted_env_file: env.encrypted
```

The way we encrypt our environment variables is by creating a file in our root directory - in this case, a file named `env` and then [downloading our project AES key.]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}) to root directory (and adding it to our `.gitignore` file.)

Once the AES key is in our directory, we can run the `jet encrypt` command with an *input* and an *output* filename: `jet encrypt env env.encrypted` ([Learn more about using Jet]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}))

Lastly, we would either delete the unencrypted `env` file or add it to our `.gitignore`.

[Learn more about encrypting your environment variables.]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %})

### Docker Inside Docker
The boolean directive `add_docker` is available. If specified for a service, it will:

* Add the environment variables `DOCKER_HOST`, `DOCKER_TLS_VERIFY` and `DOCKER_CERT_PATH` from the host.
* If `DOCKER_CERT_PATH` is set, it will mount the certificate directory through to the container.
See [add_docker](https://github.com/codeship/codeship-tool-examples/tree/master/14.add_docker) for an example using [Docker-in-Docker](https://registry.hub.docker.com/u/jpetazzo/dind).

### Caching the Docker image
Caching is declared per service. For a service with caching enabled, Codeship will store your image remotely in an encrypted S3 bucket, and then use that image to repopulate the local build cache on future build runs. This prevents the Docker image from building from scratch each time, to save time and speed up your CI/CD process. By default, we will fall back to the latest image that was built on the `master` branch.

An example setup using caching in your `codeship-services.yml` file would look like this:

```yml
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  cached: true
```

There are several specific requirements and considerations when using caching, so it is recommended that you [read our caching documentation.]({{ site.baseurl }}{% link _pro/getting-started/caching.md %}) before enabling caching on your builds.

## Unavailable Features
The following features available in Docker Compose are not available on Codeship. If these keys exist in your `codeship-services.yml` file, don't panic -- we'll just ignore them.

  * `cgroup_parent`
  * `container_name`
  * `cpu_quota`
  * [`depends_on`*](#timing-and-waiting)
  * [`healthcheck`*](#timing-and-waiting)
  * `devices`
  * `extends`
  * `group_add`
  * `ipc`
  * `isolation`
  * `logging`, `log_driver`, `log_opt`
  * `mac_address`
  * `memswap_limit`, `mem_swappiness`
  * `networks`, `network_mode`
  * `oom_scope_adj`
  * `pid`
  * `stop_signal`, `stop_grace_period`
  * `tty`
  * `tmpfs`
  * `ulimits`
  * `volume_driver`
  * `volumes` (top-level key)

All linking to the host is not allowed. This means the following directives are excluded:
  * `external_links`
  * `ports`
  * `stdin_open`

Labels as they relate to images are supported by Codeship and should be [declared in the Dockerfile](https://docs.docker.com/engine/reference/builder/#/label) using the `LABEL` instruction. `labels` as a key in the services file (to label the running container) is not supported.

## Timing And Waiting

One common issue Docker users encounter is around the `links` directive, outlined above and used to orchestrate dependent containers. A container orchestrated via `links` does not force the primary container to wait until it is ready to proceed.

This means that often your commands may begin executing before your dependent containers are ready. This is particularly problematic and common with databases.

There are two common solutions to this problem:

- Adding a short `sleep` command before your tests, giving the dependent service slightly more time to start up before proceeding.

- Writing a simple health poll script to check for service uptime before proceeding.

An example of a health poll script may look something like this:

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

Or, a health check poll could look like [this script](https://github.com/codeship/scripts/blob/master/utilities/check_port.sh) for checking to see if a port is available.

**Note** that the above scripts require tools like `bash`, `pg_isready` and `redics-cli` that need to be running on the container running these scripts.

## More Resources
* [Docker Compose](https://docs.docker.com/compose/)
* [Build Directive In Compose](https://docs.docker.com/compose/compose-file/#build)
* [Encrypting environment variables and build arguments]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %})
* [Steps File]({% link _pro/getting-started/steps.md %})
* [Volumes]({{ site.baseurl }}{% link _pro/getting-started/docker-volumes.md %})
* [Add_Docker Directive in Compose](https://github.com/codeship/codeship-tool-examples/tree/master/14.add_docker)
* [Docker-in-Docker](https://registry.hub.docker.com/u/jpetazzo/dind).
* [Caching]({{ site.baseurl }}{% link _pro/getting-started/caching.md %})
* [Build Arguments]({{ site.baseurl }}{% link _pro/getting-started/build-arguments.md %})

## Other Notes
* `link` containers will be newly created for each step.
* `volumes_from` containers will be created exactly once for all services.
