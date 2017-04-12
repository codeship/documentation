---
title: "Tutorial: Caching"
layout: page
weight: 47
tags:
  - docker
  - tutorial

redirect_from:
  - /docker/caching/
---

<div class="info-block">
This tutorial describes the way caching works on Codeship's infrastructure during a build. For [local builds using the `jet` CLI]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}), rely on the local Docker image cache.
</div>

* include a table of contents
{:toc}

## Using Caching

As a way to speed up your build pipelines, Codeship supports persistent caching. This means we'll export your final image as a compressed tar file, which is stored in an encrypted bucket on AWS S3.

For future builds, we'll import the image to your build's machine and repopulate the local Docker image cache. Then, when the service image is rebuilt, only the layers that changed will need to be updated. [Read more about optimizing your Dockerfile for caching.](#optimizing-your-build-to-use-the-docker-image-cache)

To use caching on a particular service, you must add a `cached` declaration to your services description:

```yml
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

```yml
app:
  build:
    path: testpath
    dockerfile: Dockerfile.foo
  cached: true
  default_cache_branch: "branch_name"
```

If the `default_cache_branch` directive is not present, we will always use `master` as your cache fallback branch by default.

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
