---
title: Using Elixir In CI/CD with Docker and Codeship Pro
shortTitle: Elixir
menus:
  pro/languages:
    title: Elixir
    weight: 7
tags:
  - elixir
  - languages
  - docker
categories:
  - Languages And Frameworks
redirect_from:
  - /docker-integration/elixir/
---

<div class="info-block">
We've got [quickstart repos, sample apps and a getting started guide]({% link _pro/quickstart/quickstart-examples.md %}) available to make starting out with Codeship Pro faster and easier.
</div>

* include a table of contents
{:toc}

## Elixir on Codeship Pro

Any Elixir framework or tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Elixir-based Dockerfile with ExUnit tests.

## Example Repo

We have a sample Phoenix project that you can clone or take a look at via the GitHub [Phoenix Quickstart with Codeship Pro](https://github.com/codeship-library/elixir-phoenix-quickstart) repository. This may make a good starting point for your Phoenix or Elixir-based projects.

## Services File

The following is an example of a [Codeship Services file]({% link _pro/builds-and-configuration/services.md %}). Note that it is using a [PostgreSQL image](https://hub.docker.com/_/postgres/) and a [Redis image](https://hub.docker.com/_/redis/) via the Docker Hub as linked services.

When accessing other running containers, please be aware that those services do not run on `localhost`, but on a different host, e.g. `postgres` or `mysql`. If you reference `localhost` in any of your configuration files you will have to change that to point to the service name of the service you want to access. Setting them through environment variables and using those inside of your configuration files is the cleanest approach to setting up your build environment.

```yaml
project_name:
  build:
    image: organisation_name/project_name
    dockerfile: Dockerfile
  links:
    - redis
    - postgres
  environment:
    - MIX_ENV=test
    - DATABASE_URL=postgres://postgres@postgres/YOUR_DATABASE_NAME
    - REDIS_URL=redis://redis
redis:
  image: redis:2.8
postgres:
  image: postgres:9.4
```

## Steps File

The following is an example of a [Codeship Steps file]({% link _pro/builds-and-configuration/steps.md %}).

Note that every step runs in isolated containers, so changes made on one step do not persist to the next step.  Because of this, any required setup commands, such as migrating a database, should be done via a custom Dockerfile, via a `command` or `entrypoint` on a service or repeated on every step.

```yaml
- name: ci
  type: parallel
  steps:
  - name: features
    service: project_name
    command: script/ci features
  - name: specs
    service: project_name
    command: script/ci specs
  - name: brakeman
    service: project_name
    command: script/ci brakeman
  - name: seeds
    service: project_name
    command: script/ci seed
```

## Dockerfile

Following is an example Dockerfile with inline comments describing each step in the file. The Dockerfile shows the different ways you can install extensions or dependencies so you can extend it to fit exactly what you need. Also take a look at the Elixir image documentation on [the Docker Hub](https://hub.docker.com/_/elixir/).

```dockerfile
# We're using the Elixir 1.5.2 base image and extending it
FROM elixir:1.5.2

# Create a directory for your application code and set it as the WORKDIR. All following commands will be run in this directory.
RUN mkdir /app
WORKDIR /app

# COPY mix.exs and mix.lock and install dependencies before adding the full code so the cache only
# gets invalidated when dependencies are changed
COPY app/mix.exs app/mix.lock ./
RUN mix deps.get

# Copy the app source code into the image
COPY . ./
```

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %}).
