---
title: Speed Up Your Builds With Caching on Codeship Pro
shortTitle: Image Caching
description: Technical documentation for speeding up Codeship Pro builds by utilizing Codeship's image cache that works per-branch and per-service
menus:
  pro/builds:
    title: Image Caching
    weight: 6
tags:
  - docker
  - tutorial
  - speed
  - caching
  - dependencies
  - cache
  - images

categories:
  - Builds and Configuration

redirect_from:
  - /docker/caching/
  - /pro/getting-started/caching/
---

<div class="info-block">
This tutorial describes the way caching works on Codeship's infrastructure during a build. For [local builds using the `jet` CLI]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}), rely on the local Docker image cache.
</div>

* include a table of contents
{:toc}

## Using Caching

As a way to speed up your build pipelines, Codeship supports image caching that works per-service and per-branch.

This mean's after your build is finished, we will push any images you enable caching for out to a secure registry and pull the image at the start of future builds to reuse as many of the image layers as possible rather than rebuilding them. [Read more about optimizing your Dockerfile for caching.](#optimizing-your-build-to-use-the-docker-image-cache)

To use caching on a particular service, you must add a `cached` declaration to your services description:

```yaml
app:
  build:
    path: testpath
    dockerfile: Dockerfile.foo
  cached: true
```

Once your cache is working, you should see something like this in your build logs:

```
2016-04-29 23:38:27 Step 2 : RUN mkdir /app
2016-04-29 23:38:27  ---> Using cache
2016-04-29 23:38:27  ---> 283438c51d72
2016-04-29 23:38:27 Step 3 : WORKDIR /app
2016-04-29 23:38:27  ---> Using cache
```

Note that it will take at least two builds in order for the cached image assets to be created and used.

## Specifying A Cache Fallback Branch

By default, if we can't find a cached image for the branch your current build is running on, we will fallback and look for a cached image for the `master` branch.

In some cases, you may want to specify a branch other than `master` to use as your cache fallback. You can do this per service using the `default_cache_branch` directive:

```yaml
app:
  build:
    path: testpath
    dockerfile: Dockerfile.foo
  cached: true
  default_cache_branch: "branch_name"
```

If the `default_cache_branch` directive is not present, we will always use `master` as your cache fallback branch by default.

Note that branch-cache images are automatically removed after 90 days of inactivity.

## Using The Remote Cache Locally [deprecated]

During local builds, there is no need for a remote or persistent caching solution. Rely on the local Docker image cache.

In previous versions of Jet, you were able to use the remote cache when running a local build with `jet steps`. This feature has been deprecated, because Codeship no longer relies on registries to provide remote caching. Instead, rely on the local Docker image cache for image caching during local builds.

## Optimizing Your Build To Use The Docker Image Cache

In order to fully utilize the caching provided by Codeship, you should optimize your Docker builds to take advantage of the Docker image cache. Here is a simple guide to optimizing your build:

### 1. Order your Dockerfile

You should move all RUN steps which are not dependent on added files up to the top of your Dockerfile. This should include any package installation, directory creation, or downloads. This way the image cache for these steps will not be invalidated when an added file is changed.

### 2. Separate dependent RUNs

Any further RUN commands, which are dependent upon added files, should be run ONLY after adding those specific files required. A great example of this doing a bundle install for a Ruby app. By adding ONLY the Gemfile and Gemfile.lock first, and running a bundle install, the image cache for the bundle install remains valid regardless of any changes across the entire project unless the Gemfile.lock itself is changed.

The various RUN commands should also be ordered according to frequency of invalidation. Any RUN commands which are dependent on files whose contents frequently change should be moved to the bottom of the file. This way they are unlikely to invalidate a more stable cached image as a side effect. A good tie breaker for this situation would also be that whichever image cache is larger should be placed higher in the file.

### 3. Use a strict .dockerignore file

The more files which get added to the Docker image during an ADD or COPY, the higher the chance that the image cached will be invalidated despite the functionality of the image remaining the same. To reduce the chances of this happening, strip down the number of files being added to the image to the bare essentials. Ignore any temporary files, logs, development files, and documentation, especially `.git`. A good rule of thumb for this process is if the resulting image will not utilize a file or folder, add it to the `.dockerignore` file.

## Caching With Multi-stage Builds

Docker's multi-stage build feature allows you to build Docker images with multiple build stages in the Dockerfile, ultimately saving an image from just the final stage. You can [read more about Docker multi-stage builds on our blog](https://blog.codeship.com/docker-17-05-on-codeship-pro/), but this has certain impacts on caching your image with Codeship Pro.

Since the build stage layers are untagged and not associated with the final image, they are not part of the cached image. This means that -- for now -- it’s possible that your build may take a bit longer if you relied on caching all of the layers to speed up the build.

If build speed AND small images are both critical for your application, you may choose to create a separate service in your `codeship-services.yml` file and cache that service, using a primary service to build and test your code and a secondary service - with a multi-stage Dockerfile - to produce your production image.
