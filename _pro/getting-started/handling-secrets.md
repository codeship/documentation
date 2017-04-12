---
title: "Handling Secrets During Codeship Pro Builds"
layout: page
weight: 45
tags:
  - docker
  - secrets
  - encryption
  - environment
  - pro
  - build arguments

---

* include a table of contents
{:toc}

During most Codeship builds, your build machine needs to access or communicate with some resource that requires some kind of credential. There are two main ways to pass in secrets to the Docker containers where your build steps run:

- Environment variables
- Build arguments

Codeship supports encrypted and unencrypted versions of both. Depending on how and when the secret is used, either build arguments or environment variables may be a better choice - and you might often need both.


<table style="border: 1px solid #adadad; padding: 15px; margin: 15px 0 15px;">
  <colgroup>
    <col width="300px">
    <col width="150px">
    <col width="150px">
  </colgroup>
  <thead>
    <tr>
      <th>Type</th>
      <th>Image build time</th>
      <th>Container runtime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Build arguments</td>
      <td>✓</td>
      <td></td>
    </tr>
    <tr>
      <td>Env vars in Dockerfile</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>Env vars in codeship-services.yml</td>
      <td></td>
      <td>✓</td>
    </tr>
  </tbody>
</table>

It's important to note that *build time* means the secret is available in the context of the Dockerfile, or the building of the image - whereas *runtime* means the secret is available only after the image has been built, when running commands from your `codeship-steps.yml` file.

Typically, the need for passing secrets to the build falls into three main categories:

- Interacting with private Docker registries
- Accessing private assets during the image build
- Deployments access for a remote host.

> Note: Docker advises against using build arguments to pass in any sort of secrets to your images, as they can be seen when inspecting the image layers. This is great advice for production environments, but during CI/CD with Codeship all your builds run in a single-tenant environment, and no other user or machine has access to your build machine. Your machine (and everything on it!) is also destroyed after each build, never being reused. Because of this, it _is_ advised to use build arguments necessary for the CI/CD process on Codeship while being sure _not_ to deploy images to production that use them in the same way.

## How do I push or pull from a private Docker image registry during a Codeship Pro build?

You can store login credentials for your Docker image registry by using an encrypted credentials file. That file is declared in the service with the `encrypted_dockercfg_path` key or being using a `dockercfg_service` generator.

With those credentials, you'll be able to pull private base images to use in your own Docker images, pull images from a private registry, and push your images to a private registry. Read the [tutorial on pulling private images](https://documentation.codeship.com/pro/getting-started/docker-pull/) to get started.

## How do I access private assets and dependencies during a Docker image build?

In some cases, you might need to access an asset or resource that requires authentication during the Docker image build process. A few examples include private dependencies or any asset with a dynamic external path that may change from build to build.

When these private assets need to be accessed at buildtime, to successfully build your images, you should use a build argument. You can think of build args as environment variables that are only available when the image is in the process of being built, or as keys you provide only during the setup phase.

Build arguments can be passed to the image via your `codeship-services.yml` file either encrypted or unencrypted. [You can learn how to set up build arguments here](https://docs.docker.com/engine/reference/builder/#/arg))

## How can I provide deployment credentials to Codeship?
For any secret that needs to be accessed during container runtime, meaning _after_ your containers have built when you are running commands via your `codeship-steps.yml` file, then you should use encrypted environment variables.

You can learn more about using encrypted environment variables in [this article](https://documentation.codeship.com/pro/getting-started/encryption/). You'll need to [download Jet](https://documentation.codeship.com/pro/getting-started/installation/), the CLI for running Codeship Pro builds locally, as well as grab your project's AES key from the Project Settings page.
