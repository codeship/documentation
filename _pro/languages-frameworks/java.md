---
title: Using Java In CI/CD with Docker and Codeship Pro
shortTitle: Java And The JVM
menus:
  pro/languages:
    title: Java And JVM
    weight: 5
tags:
  - java
  - languages
  - docker
  - jvm
categories:
  - Languages And Frameworks
redirect_from:
  - /docker-integration/java/
---

<div class="info-block">
We've got [quickstart repos, sample apps and a getting started guide]({% link _pro/quickstart/quickstart-examples.md %}) available to make starting out with Codeship Pro faster and easier.
</div>

* include a table of contents
{:toc}

## Java on Codeship Pro

Any Java framework or tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a Java-based Dockerfile with Maven and Gradle build steps.

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

```dockerfile
# We're using the official Maven 3 image from the Docker Hub (https://hub.docker.com/_/maven/).
# Take a look at the available versions so you can specify the Java version you want to use.
FROM maven:3

# INSTALL any further tools you need here so they are cached in the docker build

WORKDIR /app

# Copy the pom.xml into the image to install all dependencies
COPY pom.xml ./

# Run install task so all necessary dependencies are downloaded and cached in
# the Docker image. We're running through the whole process but disable
# testing and make sure the command doesn't fail.
RUN mvn install clean --fail-never -B -DfailIfNoTests=false

# Copy the whole repository into the image
COPY . ./
```

### Gradle

```dockerfile
# We're using the official OpenJDK image from the Docker Hub (https://hub.docker.com/_/java/).
# Take a look at the available versions so you can specify the Java version you want to use.
FROM java:openjdk-8-jdk

# Set the WORKDIR. All following commands will be run in this directory.
WORKDIR /app

# Copying all gradle files necessary to install gradle with gradlew
COPY gradle gradle
COPY \
  ./gradle \
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

### Multi-stage Builds

Using Docker's multi-stage build feature, you can implement some changes to your Dockerfile to allow you to build and use a Java binary from a single Dockerfile, outputting a Docker image with the JAVA binary but none of the build tools - meaning a smaller and more efficient image with a less complex setup.

Multi-stage builds allow you to specify multiple `FROM` lines in a Dockerfile, where each `FROM` line begins a new stage. The final image is _the result of the last stage_, which means any previous stages are not saved in the final image. This is great for creating "builder" workflows easily.

Here's an example using Java in a Dockerfile:

```dockerfile
# phase one, labeled as build-stage
# first stage does the building

FROM maven:3 as build-stage

COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

# phase two, which uses the java binary produced above
FROM org/app:latest

COPY --from=BUILD /usr/src/app/target/binary.war /opt/org/app/path/deployments/binary.war
```

Notice that the second `FROM` line begins the second stage, and this second stage is what the final image will consist of.

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %}).
