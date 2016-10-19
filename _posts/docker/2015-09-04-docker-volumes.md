---
title: "Tutorial: Docker volumes"
layout: page
weight: 45
tags:
  - docker
  - tutorial
categories:
  - docker
---

* include a table of contents
{:toc}

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% post_url docker/jet/2015-05-25-installation %}).
</div>

## What Are Docker Volumes?
Volumes are directories on the host that your containers can read from and write to during your CI/CD process. Because every step of your CI/CD process on Codeship runs on a separate set of containers, the ability to persist and pass along data with volumes enables you to create efficient and flexible container-based workflows without having to rely on pre-compiled assets or data.

Volumes let your containers work together without needing to tightly couple them or build out any direct communication between them. This is a great way to keep your containers efficient, and volumes solve a lot of problems in a Docker-based architecture.

There are two primary ways to use Docker volumes in your CI/CD process with Codeship.

## Configuration #1: Passing Data Between Containers
You can mount volumes in your containers and allow other containers to access the volume without persisting the data between steps. In this configuration, the volume (along with the rest of your containers) will be re-build at the beginning of each new step. ([Learn more about steps.]({{ site.baseurl }}/docker/steps/))

It's important to note that with this setup, data will be available between containers but will __not__ persist when the current step finishes and the next step begins.

To mount a volume to share data between your containers, first you need to open up your `codeship-service.yml` and specify a directory using the `volumes` directive on one of your services:

```yaml
data:
  image: busybox
  volumes:
    - /artifacts
```

Then, for your remaining services that require access to the volume, you will use the `volumes_from` directive in your other service definitions and specify which service you are mounting the volume from (i.e. the one specified with your `volumes` directive.)

```yaml
myapp:
  image: busybox
  volumes_from:
    - data
```

[We have a downloadable example of this set up here.](https://github.com/codeship/codeship-tool-examples/tree/master/07.volumes)

## Configuration #2: Passing Data Between Steps
The second setup solves the problem of persisting data *between* steps in your CI/CD process. Since every step runs on a separate set of containers, date produced in one step is not usually available to a later step - but by mounting a volume on the host (rather than in your container) you can persist data throughout your entire build.

 To mount a volume on the host, open your `codeship-services.yml` file and map a host directory to your container directory:

```yaml
data:
  image: busybox
  volumes:
    - ./tmp/artifacts:/artifacts
```

On all other services that need to access this data, you can use either the `volumes_from` directive as explained in the previous example or simply provide the exact same `volumes` directive (with the host:container mapping) on all services that require access to your volume.

[We have a downloadable example of this set up here](https://github.com/codeship/codeship-tool-examples/tree/master/08.deployment-container)

**Important note**: Volumes are mounted at run time, not at build time. During build time, the host directory is available but the directory mounted into the container is not. The inverse is true during run time. This means that if you were using the code snippet shown above, you would reference `tmp/artifacts` in your Dockerfile when running an `ADD` or a `COPY` command since those commands are running in the build context, but if you were accessing the volume from a step in your `codeship-steps.yml` file, then you would reference the mounted `/artifacts` directory instead since the host directory would be unavailable in the run context.

## Common Use Cases
Volumes solve several common problems, including:

* Using a file in a shared volume as a "health check" to look for service availability or completion

* Passing credentials between steps or services

* Creating compiled assets and artifacts via one service to be deployed or pushed to an image registry from another service

* Avoiding re-work between steps (such as not re-creating test data multiple times.)

## More Information

* https://docs.docker.com/engine/reference/builder/#volume

* https://docs.docker.com/compose/compose-file/#volumes-volume-driver

* https://docs.docker.com/engine/userguide/containers/dockervolumes/

As always, feel free to contact [support@codeship.com](mailto:support@codeship.com) if you have any questions.
