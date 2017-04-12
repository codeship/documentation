---
title: Java on Docker
weight: 48
tags:
  - java
  - languages
  - docker

redirect_from:
  - /docker-integration/java/
---

<div class="info-block">
You may want to read the [Codeship Pro Getting Started Guide]({% link _pro/getting-started/getting-started.md %}) to learn more about how Codeship Pro works. You can also [watch a short demo video here](https://codeship.com/features/pro).
</div>

* include a table of contents
{:toc}

## Java on Codeship Pro

Any Java framework or tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Java-based Dockerfile with Maven and Gradle build steps.

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
  service: project_name
  command: mvn test -B
- name: ci
  service: project_name
  command: gradle build
```

## Dockerfile

Following are two example Dockerfiles, one for using Maven and one for using Gradle, with inline comments describing each step in the file. The Dockerfiles show the different ways you can install extensions or dependencies so you can extend it to fit exactly what you need.

### Maven

```
# We're using the official Maven 3 image from the Dockerhub (https://hub.docker.com/_/maven/).
# Take a look at the available versions so you can specify the Java version you want to use.
FROM maven:3

# INSTALL any further tools you need here so they are cached in the docker build

WORKDIR /app

# Copy the pom.xml into the container to install all dependencies
COPY pom.xml ./

# Run install task so all necessary dependencies are downloaded and cached in
# the Docker container. We're running through the whole process but disable
# testing and make sure the command doesn't fail.
RUN mvn install clean --fail-never -B -DfailIfNoTests=false

# Copy the whole repository into the container
COPY . ./
```

### Gradle

```
# We're using the official OpenJDK image from the Dockerhub (https://hub.docker.com/_/java/).
# Take a look at the available versions so you can specify the Java version you want to use.
FROM java:openjdk-8-jdk

# Set the WORKDIR. All following commands will be run in this directory.
WORKDIR /app

# Copying all gradle files necessary to install gradle with gradlew
COPY gradle gradle
COPY \
  build.gradle \
  gradle.properties \
  gradlew \
  settings.gradle \
  ./

# Install the gradle version used in the repository through gradlew
RUN ./gradlew

# Run gradle assemble to install dependencies before adding the whole repository
RUN gradle assemble

ADD . ./
```

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/getting-started/cli.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/getting-started/caching.md %}).
