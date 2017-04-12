---
title: "Tutorial: Generating Docker credentials using a service"
layout: page
weight: 42
tags:
  - docker
  - tutorial
  - push
  - registry

redirect_from:
  - /docker/dockercfg-services/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}). Note that if the generator service you select needs to write to your local filesystem, you must use a local Docker host such as Docker for Mac.
</div>

* include a table of contents
{:toc}

## Overview

Codeship supports using private registries for pulling and pushing images by allowing static dockercfg credentials to be encrypted as part of your codebase. Due to an increasing number of container registry vendors using different methods to generate Docker temporary credentials, we have added support for custom dockercfg credential generation. By using a custom service within your list of Codeship services, you can integrate with a standard dockercfg generation container for your desired provider. Codeship will provide a basic set of images supporting common providers, however you will also be able to use custom images to integrate with custom registries.

## Using a service to generate Docker credentials

Taking advantage of this feature is fairly simple. First off, add a service using the image for your desired registry provider to your `codeship-services.yml` file. You can add any links, environment variables or volumes you need, just like with a regular service.

```
# codeship-services.yml
app:
  build:
    dockerfile: ./Dockerfile
    image: myservice.com/myuser/myapp
myservice_generator:
  image: codeship/myservice-dockercfg-generator
  encrypted_env: creds.encrypted
```

To use this generator service, simply reference it using the `dockercfg_service` field in lieu of an `encryped_dockercfg` in your steps or services file.

```
# codeship-steps.yml
- type: push
  service: app
  registry: myservice.com
  image_name:  myservice.com/myuser/myapp
  dockercfg_service: myservice_generator
```

Codeship will run the service to generate a dockercfg as needed. Under the hood, Codeship will launch a container with the specified image, mount a volume and request a dockercfg be written to a temporary file on that volume. As soon as the dockercfg is read, it is deleted from the filesystem. The container logs from this generator service will be visible on the command line and in the Codeship interface.

Keep in mind that different generator images may have different requirements. If your generator image, for example, performs a `docker login`, you may need to set `add_docker: true` in order to use it. Be sure to read the documentation for your specific provider when implementing these generator services.

## Creating your own dockercfg generator image

The majority of container registries use standard, static credentials, and even using a custom authentication proxy, most of the time you can generate a compatible static dockercfg and encrypt it for use within your pipeline. Should you need to use dynamic credentials, or some other method of securely retrieving static credentials during the CI/CD process, you'll need to use a generator service. Luckily creating your own image is simple, the only requirement is that the image writes the dockercfg to a path provided via a `CMD` argument.

```
$ docker run -it -v /tmp/:/opt/data mygenerator /opt/data/dockercfg
$ cat /tmp/dockercfg # read generated dockercfg
```

The container must be provided with any credentials or configuration needs to generate a dockercfg via environment variables. When the image is being used in a build, this information is provided via the service definition in the `codeship-services.yml` file. Codeship will run the container any time it needs to generate the dockercfg, however the cost of this can be mitigated by locally caching credentials using a host volume mount defined in the service definition. The container image would be responsible for managing this cached folder, and checking the presence and validitity of credentials in the cache before returning them.

## Integrations

Here is a list of the standard dockercfg generators we support. If you don't see your desired provider on this list, please reach out to support, or create it yourself.

* [AWS ECR](https://github.com/codeship-library/aws-deployment)
* [Google GCR](https://github.com/codeship-library/gcr-dockercfg-generator)
