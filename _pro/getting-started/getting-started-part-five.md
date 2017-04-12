---
title: Getting Started With Codeship Pro Part 5
layout: page
weight: 15
tags:
  - docker
  - jet
  - codeship pro  
  - introduction
  - getting started
  - tutorial
  - getting started jet

redirect_from:
  - /docker-guide/getting-started-part-five/
---

* include a table of contents
{:toc}

The source for the tutorial is available on Github as [codeship/ci-guide](https://github.com/codeship/ci-guide/) and you can clone it via

```bash
git clone git@github.com:codeship/ci-guide.git
```

## Getting Started With Codeship Pro (Part 5)

Now that we've covered the basic pieces of the service, we should take a few minutes and cover two additional features that make for more flexible and powerful CI/CD workflows for your team.

## Caching

Next up, let's take a look at caching. When you use caching, we'll push your image out to a private, secure S3 bucket with access credentials unique to your project. Then, on your next build, we'll quickly check your Dockerfile to see if anything has changed. If nothing has changed - meaning, if building the Dockerfile would result in the exact same image as last time - we'll reuse the cached image. This is a layer by layer cache, so we'll reuse as much of the image as we can before rebuilding the rest of the image once we encounter a change.

Let's open up our `codeship-services.yml` file and make a change to enable caching.

```yaml
demo:
  build:
    image: myapp
    dockerfile: Dockerfile
  links:
    - redis
    - postgres
  volumes:
    - ./tmp:/app
  cached: true
```

Now, let's push our build so that it runs and sets our cache.

Of course, to see our cache in action we'll have to push *another* build using the same image so that we can actually use the cache - so let's comment out part of our `codeship-steps.yml` file just for this example and push up a (second) new build.

```yaml
- type: parallel
  steps:
    - name: checkrb
      service: demo
      command: bundle exec ruby check.rb
    - name: test
      service: demo
      command: bundle exec ruby test.rb
    # - type: serial
    #   steps:
    #   - name: volumes_in
    #     service: demo
    #     command: bundle exec ruby write.rb
    #   - name: volumes_out
    #     service: demo
    #     command: bundle exec ruby read.rb

- type: serial
  steps:
    - name: dockerhub_push
      service: checkrb
      type: push
      image_name: account/repo
      registry: https://index.docker.io/v1/
      encrypted_dockercfg_path: dockercfg.encrypted
```

Once the new build runs, we can check our log output and see our cache in action.

![Caching working log output.]({{ site.baseurl }}/images/gettingstarted/cacheworking.png)

Caching is a really powerful way to speed your builds up. We also have a great article on optimizing your builds overall, as well as making sure your Dockerfile is designed with caching in mind. [You can read that here.](https://blog.codeship.com/speeding-up-your-docker-based-builds-with-codeship/)

## Tests Per Branch

Now I want to take a look at a bit of the flexibility you can implement around running your tests.

Let's go back to our `codeship-steps.yml` file and look at the command where we run our tests.

On our step, let's add a new line: `tag: master`

This tag tells Codeship to only run this tag on the master branch. You can imagine creating branches that run all your tests (before deployments, for instance), branches that only run front-end tests or tests for certain apis (**/api/_** for instance)... and a ton of other combinations that will streamline your workflows and keep developers productive.

## Learn More!

From here, there's still a ton more you can learn to optimize your builds, troubleshoot your problems and build more complex and productive workflows.

We recommend [our blog](https://blog.codeship.com), [our documentation](({{ site.url }}), [our community forum](https://community.codeship.com), and [our webinars](http://resources.codeship.com/webinars) to keep learning more.

It's important to get to a working build as soon as possible when you start your new CI/CD process with Codeship Pro. From there, take some time with your team every few weeks or every few months to find ways to optimize, save time, keep the developers coding with fewer waiting periods and improve your application and Docker image efficiency.
