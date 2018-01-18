---
title: Using Docker Volumes In CI/CD
shortTitle: Using Volumes
menus:
  pro/builds:
    title: Volumes
    weight: 8
tags:
  - docker
  - tutorial
  - volumes
  - docker compose

categories:
  - Builds and Configuration


redirect_from:
  - /docker/docker-volumes/
  - /pro/getting-started/docker-volumes/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}).
</div>

* include a table of contents
{:toc}

## What Are Docker Volumes?

Volumes are directories on the host that your containers can read from and write to during your CI/CD process.

Volumes let your containers work together without needing to tightly couple them or build out any direct communication between them. This is a great way to keep your containers efficient, and volumes solve a lot of problems in a Docker-based architecture.

**Note** that every step of your CI/CD process on Codeship runs on a separate set of containers, so volumes are the only way to persist artifacts or changes between steps during your build pipeline.

## Using Volumes

There are two primary ways to use Docker volumes in your CI/CD process with Codeship.

### Configuration #1: Passing Data During A Single Step

You can mount volumes in your containers and allow other containers to access the volume during a single step.

It's important to note that with this setup, data will be available between containers but will __not__ persist when the current step finishes and the next step begins. This is because each step uses a separate set of containers. [Learn more about codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) if this is unclear to you.

To mount a volume to share data between your containers, first you need to open up your `codeship-service.yml` and specify a directory using the `volumes` directive on one of your services:

**Note** that in this case, `volumes` takes only a single path argument. This path is referring to a directory _inside_ the running container built from this service definition.

```yaml
data:
  image: busybox
  volumes:
    - /artifacts
```

For the services that require access to the volume, you will use the `volumes_from` directive in your additional service definitions and specify which service you are mounting the volume from.

```yaml
myapp:
  image: busybox
  volumes_from:
    - data
```

[We have a downloadable example of this set up here.](https://github.com/codeship/codeship-tool-examples/tree/master/07.volumes)

### Configuration #2: Passing Data Between Steps

In this configuration, you can persist data *between* steps in your CI/CD process by mounting a host volume. Since every step runs on a separate set of containers mounting a volume on the host is the only way to share data and artifacts across steps.

 To mount a volume on the host, open your `codeship-services.yml` file and map a host directory to your container directory.

 **Note** that in this case, `volumes` takes two path arguments. The first path argument refers to a directory on the host, cloned from your repository. Because of this, the host directory must be a part of your Git repository. The second directory path is an alias for the host directory that will be parsed _inside_ your containers at runtime.

```yaml
data:
  image: busybox
  volumes:
    - ./tmp/artifacts:/artifacts
```


On all other services that need to access this data, you can use either the `volumes_from` directive as explained in the previous example or simply provide the exact same `volumes` directive (with the host:container mapping) on all services that require access to your volume.

[We have a downloadable example of this set up here](https://github.com/codeship/codeship-tool-examples/tree/master/08.deployment-container)

## Use Cases

Volumes solve several common problems, including:

* Using a file in a shared volume as a "health check" to look for service availability or completion

* Passing credentials between steps or services

* Creating compiled assets and artifacts via one service to be deployed or pushed to an image registry from another service

* Avoiding re-work between steps (such as not re-creating test data multiple times.)

## Common Issues

- Volumes are mounted at run time, not at build time. During build time, the host directory is available but the directory mounted into the container is not. The inverse is true during run time. This means that if you were using the code snippet shown above, you would reference `tmp/artifacts` in your Dockerfile when running an `ADD` or a `COPY` command since those commands are running in the build context, but if you were accessing the volume from a step in your `codeship-steps.yml` file, then you would reference the mounted `/artifacts` directory instead since the host directory would be unavailable in the run context.

- As the hosts are ephemeral, you should not rely on existence of certain directories. Always make sure that you're mounting volumes from a directory relative to where your repo is checked out.

- When mounting volumes, ensure the directory you're attempting to mount already exists. The simplest way to do that is to add the required directory to your repository. Docker version 1.12 and earlier automatically created missing directories, but this behavior have been removed in later versions.

## More Information

- [https://docs.docker.com/engine/reference/builder/#volume](https://docs.docker.com/engine/reference/builder/#volume)

- [https://docs.docker.com/compose/compose-file/#volumes](https://docs.docker.com/compose/compose-file/#volumes)

- [https://docs.docker.com/engine/admin/volumes/volumes](https://docs.docker.com/engine/admin/volumes/volumes)
