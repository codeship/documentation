---
title: Using Node.js In CI/CD with Docker and Codeship Pro
shortTitle: Node.js
menus:
  pro/languages:
    title: Node.js
    weight: 3
tags:
  - node.js
  - languages
  - docker
  - frameworks
  - nodejs
  - javascript
categories:
  - Languages And Frameworks
redirect_from:
  - /docker-integration/nodejs/
---

<div class="info-block">
We've got [quickstart repos, sample apps and a getting started guide]({% link _pro/quickstart/quickstart-examples.md %}) available to make starting out with Codeship Pro faster and easier.
</div>

* include a table of contents
{:toc}

## Node on Codeship Pro

Any Node tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Node-based Dockerfile with tests.

## Example Repo

We have a sample Node repo that you can clone or take a look at via the GitHub [codeship-library/nodejs-express-todoapp](https://github.com/codeship-library/nodejs-express-todoapp) repository. This may make a good starting point for your Node-based projects.

## Services File

The following is an example of a [Codeship Services file]({% link _pro/builds-and-configuration/services.md %}). Note that it is using a [PostgreSQL image](https://hub.docker.com/_/postgres/) and a [Redis image](https://hub.docker.com/_/redis/) via the Docker Hub as linked services.

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
  image: redis:3
postgres:
  image: postgres:9.6
```

## Steps File

The following is an example of a [Codeship Steps file]({% link _pro/builds-and-configuration/steps.md %}).

Note that every step runs in isolated containers, so changes made on one step do not persist to the next step.  Because of this, any required setup commands, such as migrating a database, should be done via a custom Dockerfile, via a `command` or `entrypoint` on a service or repeated on every step.

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

```dockerfile
# We're starting from the Node 8 image
FROM node:8

# INSTALL any further tools you need here so they are cached in the docker build

# Set the WORKDIR to /app so all following commands run in /app
WORKDIR /app

# COPY the package.json and if you use npm shrinkwrap the npm-shrinkwrap.json and
# install npm dependencies before copying the whole codebase into the image.
COPY package.json ./ && npm-shrinkwrap.json ./
RUN npm install

# After installing dependencies copy the whole codebase into the Container to not invalidate the cache before
COPY . ./
```

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) to debug issues locally via `jet steps`.

### Webpack

You can install webpack via NPM in your services' Dockerfile, as seen below:

```dockerfile
RUN npm install webpack
```

**Note** that you may need to specify a specific version of Node in the Dockerfile to use webpack successfully.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %}).
