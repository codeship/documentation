---
title: Using Go In CI/CD with Docker and Codeship Pro
shortTitle: Go
menus:
  pro/languages:
    title: Go
    weight: 4
tags:
  - go
  - languages
  - docker
categories:
  - Languages And Frameworks
redirect_from:
  - /docker-integration/go/
---

<div class="info-block">
We've got [quickstart repos, sample apps and a getting started guide]({% link _pro/quickstart/quickstart-examples.md %}) available to make starting out with Codeship Pro faster and easier.
</div>

* include a table of contents
{:toc}

## Go on Codeship Pro

Any Go service or tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Go-based Dockerfile and project.

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
  image: redis:2.8
postgres:
  image: postgres:9.4
```

## Steps File

The following is an example of a [Codeship Steps file]({% link _pro/builds-and-configuration/steps.md %}).

Note that every step runs in isolated containers, so changes made on one step do not persist to the next step.  Because of this, any required setup commands, such as migrating a database, should be done via a custom Dockerfile, via a `command` or `entrypoint` on a service or repeated on every step.

```yaml
- service: project_name
  command: bash -c "go build ./... && go test ./..."
```

## Dockerfile

Following is an example Dockerfile with inline comments describing each step in the file. The Dockerfile shows the different ways you can install extensions or dependencies so you can extend it to fit exactly what you need. Also take a look at the Golang image documentation on [the Docker Hub](https://hub.docker.com/_/golang/).

```dockerfile
# Starting from the latest Golang image
FROM golang:1.9

# INSTALL any further tools you need here so they are cached in the docker build

# Set the WORKDIR to the project path in your GOPATH, e.g. /go/src/github.com/go-martini/martini/
WORKDIR /go/src/your/package/name

# Copy the content of your repository into the image
COPY . ./

# Install dependencies through go get, unless you vendored them in your repository before
# Vendoring can be done with an external tool like godep or glide
# Go versions after 1.5.1 include support for a vendor directory
RUN go get
```

### Multi-stage Builds

Using Docker's multi-stage build feature, you can implement some changes to you Dockerfile to allow you to build and use a Go binary from a single Dockerfile, outputting a Docker image with the Go binary but none of the Golang build tools - meaning a smaller and more efficient image with a less complex setup.

Multi-stage builds allow you to specify multiple `FROM` lines in a Dockerfile, where each `FROM` line begins a new stage. The final image is _the result of the last stage_, which means any previous stages are not saved in the final image. This is great for creating "builder" workflows easily.

Here's an example using Go in a Dockerfile:

```dockerfile
# phase one, labeled as build-stage
# first stage does the building

FROM golang:1.9 as build-stage
WORKDIR /go/src/github.com/codeship/go-hello-world
COPY hello-world.go .
RUN go build -o hello-world .

# starting second stage
FROM alpine:3.6

# copy the binary from the `build-stage`
COPY --from=build-stage /go/src/github.com/codeship/go-hello-world/hello-world /bin

CMD hello-world
```

Notice that the second `FROM` line begins the second stage, and this second stage is what the final image will consist of.

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %}).
