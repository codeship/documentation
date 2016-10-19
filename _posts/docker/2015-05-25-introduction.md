---
title: Welcome to Codeship’s Docker Infrastructure
layout: page
weight: 100
tags:
  - docker
  - introduction
categories:
  - docker
---

Welcome to Codeship's Docker Infrastructure, the new way to run your tests on Codeship. Enjoy full customizability. Easily mirror your Development, Test and Production Environments with full parity. The underlying build infrastructure, based on Docker, allows for customized definition of the running environment.

<div class="info-block">
Codeship's Docker based infrastructure is available to customers on a invite only basis at the moment. Please see the [Docker feature page](http://pages.codeship.com/docker) for information and to request access.

**Note**
- Codeship's Docker Infrastructure supports git based repositories on GitHub and BitBucket. **Mercurial based repositories on BitBucket are not currently supported.**
</div>

_Docker Infrastructure_ implements two main functions:

- It replicates and replaces some of the functionality of [Docker Compose](https://docs.docker.com/compose/) for the purpose of defining the build environment.
- It allows you to define your CI and CD steps and run those the same way locally in your development environment as within the hosted Codeship environment.

For this reason we introduce two new concepts.

- [Services]({{ site.baseurl }}{% post_url docker/2015-05-25-services %}) specify a Docker image, plus accompanying configuration, same as you would do with _Docker Compose_. The Docker image defines the operating environment.
- [Steps]({{ site.baseurl }}{% post_url docker/2015-05-25-steps %}) specify what to run on those services.

To get started, please [install Jet]({{ site.baseurl }}{% post_url docker/jet/2015-05-25-installation %}) locally on your development machine and follow the [tutorial]({{ site.baseurl }}{% post_url docker/guide/2015-06-10-getting-started %}) to get your first project working on the Codeship Docker Infrastructure.
