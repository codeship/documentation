---
title: Node.js on Docker
weight: 48
tags:
  - node.js
  - languages
  - docker

redirect_from:
  - /docker-integration/nodejs/
---

<div class="info-block">
You may want to read the [Codeship Pro Getting Started Guide]({% link _pro/getting-started/getting-started.md %}) to learn more about how Codeship Pro works. You can also [watch a short demo video here](https://codeship.com/features/pro).
</div>

* include a table of contents
{:toc}

## Node on Codeship Pro

Any Node tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Node-based Dockerfile with tests.

## Example Repo

We have a sample Node repo that you can clone or take a look at via the GitHub [codeship-library/nodejs-express-todoapp](https://github.com/codeship-library/nodejs-express-todoapp) repository. This may make a good starting point for your Node-based projects.


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
  - service: project_name
    command: npm run-script test-acceptance
  - service: project_name
    command: npm run-script test-unit
```

## Dockerfile

Following is an example Dockerfile with inline comments describing each step in the file. The Dockerfile shows the different ways you can install extensions or dependencies so you can extend it to fit exactly what you need. Also take a look at the Node image documentation on [the Docker Hub](https://hub.docker.com/_/node/).

```Dockerfile
# We're starting from the Node.js 0.12.7 container
FROM node:latest

# INSTALL any further tools you need here so they are cached in the docker build

# Set the WORKDIR to /app so all following commands run in /app
WORKDIR /app

# COPY the package.json and if you use npm shrinkwrap the npm-shrinkwrap.json and
# install npm dependencies before copying the whole code into the container.
COPY package.json ./ && npm-shrinkwrap.json ./
RUN npm install

# After installing dependencies copy the whole codebase into the Container to not invalidate the cache before
COPY . ./
```

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/getting-started/cli.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/getting-started/caching.md %}).
