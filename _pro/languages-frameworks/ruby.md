---
title: Ruby on Docker
weight: 48
tags:
  - ruby
  - languages
  - docker

redirect_from:
  - /docker-integration/ruby/
---

<div class="info-block">
You may want to read the [Codeship Pro Getting Started Guide]({% link _pro/getting-started/getting-started.md %}) to learn more about how Codeship Pro works. You can also [watch a short demo video here](https://codeship.com/features/pro).
</div>

* include a table of contents
{:toc}

## Ruby on Codeship Pro

Any Ruby framework or tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Ruby-based Dockerfile with RSpec and Cucumber tests.

## Example Repo

We have a sample Rails repo that you can clone or take a look at via the GitHub [codeship-library/ruby-rails-todoapp](https://github.com/codeship-library/ruby-rails-todoapp) repository. This may make a good starting point for your Rails or Ruby-based projects.

## Services File

The following is an example of a [Codeship Services file]({% link _pro/getting-started/services.md %}). Note that it is using a [PostgreSQL container](https://hub.docker.com/_/postgres/) and a [Redis container](https://hub.docker.com/_/redis/) via the Dockerhub as linked services.

When accessing other containers please be aware that those services do not run on `localhost`, but on a different host, e.g. `postgres` or `mysql`. If you reference `localhost` in any of your configuration files you will have to change that to point to the service name of the service you want to access. Setting them through environment variables and using those inside of your configuration files is the cleanest approach to setting up your build environment.

```yaml
project_name:
  build:
    image: organisation_name/project_name
    dockerfile: Dockerfile
  links:
    - redis
    - postgres
  environment:
    - DATABASE_URL=postgres://postgres@postgres/YOUR_DATABASE_NAME
    - REDIS_URL=redis://redis
redis:
  image: redis:2.8
postgres:
  image: postgres:9.4
```

## Steps File

The following is an example of a [Codeship Steps file]({% link _pro/getting-started/steps.md %}).

Note that every step runs on isolated containers, so changes made on one step do not persist to the next step.  Because of this, any required setup commands, such as migrating a database, should be done via a custom Dockerfile, via a `command` or `entrypoint` on a service or repeated on every step.

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

Following is an example Dockerfile with inline comments describing each step in the file. The Dockerfile shows the different ways you can install extensions or dependencies so you can extend it to fit exactly what you need. Also take a look at the Ruby image documentation on [the Docker Hub](https://hub.docker.com/_/ruby/).

```Dockerfile
# Article for Dockerfile at ADD_URL_FOR_THIS
# We're using the Ruby 2.2 base container and extend it
FROM ruby:latest

# We install certain OS packages necessary for running our build
# Node.js needs to be installed for compiling assets
# libpq-dev is necessary for installing the pg gem
# libmysqlclient-dev is necessary for installing the mysql2 gem
RUN apt-get update && \
    apt-get install -yq \
      libmysqlclient-dev \
      libpq-dev \
      nodejs

# INSTALL any further tools you need here so they are cached in the docker build

# Create a directory for your application code and set it as the WORKDIR. All following commands will be run in this directory.
RUN mkdir /app
WORKDIR /app

# Set the Rails Environment to test
ENV RAILS_ENV test

# COPY Gemfile and Gemfile.lock and install dependencies before adding the full code so the cache only
# gets invalidated when dependencies are changed
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install -j20

# Copy the whole repository into the container
COPY . ./
```

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/getting-started/cli.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/getting-started/caching.md %}).
