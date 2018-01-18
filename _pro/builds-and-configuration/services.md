---
title: Services Configuration
menus:
  pro/builds:
    title: Services Config
    weight: 2
tags:
  - docker
  - jet
  - configuration
  - services
  - images
  - image registry
  - docker compose

categories:
  - Builds and Configuration

redirect_from:
  - /docker/services/
  - /pro/getting-started/services/
  - /docker/getting-started/services/
---

* include a table of contents
{:toc}

<div class="info-block">
This article is about the `codeship-services.yml` file that powers Codeship Pro.

 If you are unfamiliar with Codeship Pro, we recommend our [getting started guide]({{ site.baseurl }}{% link _pro/quickstart/getting-started.md %}) or [the features overview page](http://codeship.com/features/pro).

 Also note that the `codeship-services.yml` file depends on the `codeship-steps.yml` file, which you can [learn more about here]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}).
</div>

## What Is Your Codeship Services File?
Your services file - `codeship-services.yml` - is where you configure each service you need to run your CI/CD builds with Codeship. During the build, these services will be used to run the testing steps you've defined in your `codeship-steps.yml` [file]({% link _pro/builds-and-configuration/steps.md %}). You can have as many services as you'd like, and customize each of them. Each of these services will be run inside a Docker container.

Your services can be built from your own Dockerfiles, or pulled from any registry. Your `codeship-services.yml` will be very similar to a `docker-compose.yml` file, and most of the syntax is compatible.

Running with Docker, your Codeship services allow you to:

* Set up different environments for running your unit, integration, or acceptance tests
* Have control over dependencies and versions of software consumed within the service
* Build specialized deployment images to unify deployment across your company
* Use any Docker image available on an image registry for your builds

**Your Codeship builds run on infrastructure equipped with version {{ site.data.docker.version }} of Docker.**

## Prerequisites
Your services file will require that you have [installed Jet locally]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}) or [set up your project on Codeship.]({{ site.baseurl }}{% link _pro/quickstart/codeship-configuration.md %})

## Services File Setup & Configuration
By default, we look for the filename `codeship-services.yml`. In its absence, Codeship will automatically search for a `docker-compose.yml` file to use in its place.

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

* `args`: build arguments passed to the image at build time. [Learn more about build arguments.]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %})

* `encrypted_args_file`: an encrypted file of build arguments that are passed to the image at build time. [Learn more about build arguments.]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %})


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

[Learn more about using volumes.]({{ site.baseurl }}{% link _pro/builds-and-configuration/docker-volumes.md %})

### Environment Variables
The standard `environment` and `env_file` directives are supported. Additionally, we support encrypted environment variables with `encrypted_environment` and `encrypted_env_file` directives. These are the same format, but they expect encrypted variables.

An example setup explicitly declaring your environment variables in your `codeship-services.yml` file would look like this:

```yaml
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  environment:
    ENV: string
    ENV2: string
```

An example setup providing your encrypted environment variable file in your `codeship-services.yml` file would look like this:

```yaml
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  encrypted_env_file: env.encrypted
```

The way we encrypt our environment variables is by creating a file in our root directory - in this case, a file named `env` and then [downloading our project AES key.]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) to root directory (and adding it to our `.gitignore` file.)

Once the AES key is in our directory, we can run the `jet encrypt` command with an *input* and an *output* filename: `jet encrypt env env.encrypted` ([Learn more about using Jet]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}))

Lastly, we would either delete the unencrypted `env` file or add it to our `.gitignore`.

[Learn more about encrypting your environment variables.]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %})

#### Service-defined Environment Variables

Additionally, environment variables are populated based on services defined in your [codeship-services.yml]({% link _pro/builds-and-configuration/services.md %}), as defined by the images used.

For instance, building a `redis` service would provide the environment variables:

```
REDIS_PORT=
REDIS_NAME=
REDIS_ENV_REDIS_VERSION=3.0.5
REDIS_ENV_REDIS_DOWNLOAD_URL=
```

Note that this is an incomplete list of the variables provided by `redis`, and that all images define their own environment variables to be exported by default during build time.


#### Default Environment Variables

By default, Codeship populates a list of CI/CD related environment variables, such as the branch and the commit ID.

For a full list of globally defined environment variables, see the [Codeship Pro environment variables documentation.]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %})


### Docker Inside Docker
The boolean directive `add_docker` is available. If specified for a service, it will:

* Add the environment variables `DOCKER_HOST`, `DOCKER_TLS_VERIFY` and `DOCKER_CERT_PATH` from the host.
* If `DOCKER_CERT_PATH` is set, it will mount the certificate directory through to the container.
See [add_docker](https://github.com/codeship/codeship-tool-examples/tree/master/14.add_docker) for an example using [Docker-in-Docker](https://registry.hub.docker.com/u/jpetazzo/dind).

### Caching the Docker image

Caching is declared per service. For a service with caching enabled Codeship will push your image out to a secure image registry after the build is finished, and then pull that image in at the start of future builds to use non-breaking layers as a cache rather than rebuilding them.

This prevents the Docker image from building from scratch each time, to save time and speed up your CI/CD process. By default, we will fall back to the latest image that was built on the `master` branch.

An example setup using caching in your `codeship-services.yml` file would look like this:

```yaml
app:
  build:
    image: codeship/app
    dockerfile: Dockerfile
  cached: true
```

There are several specific requirements and considerations when using caching, so it is recommended that you [read our caching documentation.]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %}) before enabling caching on your builds.

### Multi-stage Builds

Docker's multi-stage build feature allows you to build Docker images with multiple build stages in the Dockerfile, ultimately saving an image from just the final stage. This is great for creating "builder" workflows easily, and reducing the image size of your final Docker image.

Because Codeship supports Docker natively, you will not need to do anything to get your multi-stage builds working on Codeship and we will fully support your multi-stage Dockerfiles. If you use the CLI to run builds locally, you must use CLI version 1.18 or above in order to use multi-stage builds. Please note that using multi-stage image builds can impact the way that caching works during your Codeship Pro builds. For more information, refer to our [our caching documentation.]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %})

You can also [read more about Docker multi-stage builds on our blog](https://blog.codeship.com/docker-17-05-on-codeship-pro/).

## Build Flags

There are several Docker build flags, such as `-w`, that are not executable on Codeship because we do not provide the ability for Docker build instructions (other than via Docker in Docker).

These flags should instead be implemented as directives in your Services file, as available. For instance, the `-w` instruction can be replaced with the `working_dir` directive applied to any of your services. Most Compose directives not specifically excluded below should function as expected.

## Container networking

We do not support the top-level `networks` directive (see [unavailable features](#unavailable-features)) - but all containers are started on isolated networks, per step, by default.

Containers are bidirectionally discoverable without requiring any custom setup and should not require custom network creation.

## Unavailable Features

The following features available in Docker Compose are not available on Codeship. If these keys exist in your `codeship-services.yml` file, don't panic -- we'll just ignore them.

  * `cgroup_parent`
  * `container_name`
  * `cpu_quota`
  * [`depends_on`*](#timing-and-waiting) - [Contact us for upcoming beta access!](mailto:solutions@codeship.com)
  * [`healthcheck`*](#timing-and-waiting) - [Contact us for upcoming beta access!](mailto:solutions@codeship.com)
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
  * `volumes` ([we do support volumes]({% link _pro/builds-and-configuration/docker-volumes.md %}), just not as a [top-level key](https://docs.docker.com/compose/compose-file/compose-file-v2/#volumes-volume_driver))
  * `privileged`

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

```shell
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

## Validating Your Files

You can use the `jet validate` command, via our [local CLI]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}), to verify that your files are configured correctly and ready to be used.

## More Resources
* [Docker Compose](https://docs.docker.com/compose/)
* [Build Directive In Compose](https://docs.docker.com/compose/compose-file/#build)
* [Encrypting environment variables and build arguments]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %})
* [Steps File]({% link _pro/builds-and-configuration/steps.md %})
* [Volumes]({{ site.baseurl }}{% link _pro/builds-and-configuration/docker-volumes.md %})
* [Add_Docker Directive in Compose](https://github.com/codeship/codeship-tool-examples/tree/master/14.add_docker)
* [Docker-in-Docker](https://registry.hub.docker.com/u/jpetazzo/dind).
* [Caching]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %})
* [Build Arguments]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %})

## Other Notes
* `link` containers will be newly created for each step.
* `volumes_from` containers will be created exactly once for all services.
