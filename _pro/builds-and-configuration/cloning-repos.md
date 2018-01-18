---
title: Using Multiple Repositories
menus:
  pro/builds:
    title: Multiple Repos
    weight: 11
tags:
  - docker
  - tutorial
  - ssh key
  - encryption
  - repo
  - git
  - ssh

categories:
  - Builds and Configuration


redirect_from:
  - /docker/ssh-key-authentication/
  - /pro/getting-started/ssh-key-authentication/
  - /pro/getting-started/cloning-repos/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}).
</div>

* include a table of contents
{:toc}

## Multi-Repo Build Pipelines

When using microservices, you may have several repos you want to build together or in sequences. There are two primary setups to accomplish this, and for each setup there are a couple of methods you can use.

- You can create separate CI/CD projects for each repository, allowing them to deploy independently of one another. Then, you can either have each project bring in all of your individual component repos for full-stack testing, or you can create a separate, agnostic project just for the purposes of combining them for full-stack testing.

- You can create a single project that pulls from all of your repos, deploying all components together whenever the master project is updated.

Once you decide which workflow you like, there are two main ways to combine your repos for full-stack  testing.

## Using Image Pushes

If you opt to create separate CI/CD projects for each individual component, you can have each component's pipeline end with an [image push]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) to an image registry.

Then, either with a separate project or as a part of the build process for each component, you can pull in the latest images for each component to build and test your combined application.

## Cloning Multiple Repositories

In addition to the above method using images in a registry, you can also clone the repos themselves during the build process - either with a separate project or as part of the build for each individual component.

### Creating Your SSH Key

The first step of cloning a repo into your build process is to create your SSH key authentication. Another option for cloning from GitHub would be to use [OAuth instead of an SSH key](https://github.com/blog/1270-easier-builds-and-deployments-using-git-over-https-and-oauth).

The following command will create two files in your local repository. `keyfile.rsa` contains your private key that we will encrypt and put into your repository. This encrypted file will be decrypted on Codeship as part of your build. The second file `keyfile.rsa.pub` can be added to services that you want to access.

```shell
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f keyfile.rsa
```

Now you have to copy the content of `keyfile.rsa` into a [build arguments file]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}), in this case we'll name it `sshkey.args`. Make sure to replace newlines with \n so the whole SSH key is in one line. The following is an example of `ssh_key.args`.

```
PRIVATE_SSH_KEY=-----BEGIN RSA PRIVATE KEY-----\nMIIJKAIBAAKCFgEA2LcSb6INQUVZZ0iZJYYkc8dMHLLqrmtIrzZ...
```

And here is a `docker run` command that will do the work of replacing your newlines with `\n`

```
docker run -it --rm -v ${PATH_TO_PRIVATE_KEY}:/key alpine sed -E ':a;N;$!ba;s/\r?\n/\\n/g' /key
```

After preparing the `sshkey.args` file we can encrypt it with the local CLI. Follow the [encryption tutorial]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}) to turn the `sshkey.args` file into a `sshkey.args.encrypted` file.

You can then add it to a service via an [encrypted build arguments file]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}) with the `encrypted_args_file` option. It will be automatically decrypted on Codeship.

```yaml
app:
  build:
    dockerfile: Dockerfile
    encrypted_args_file: sshkey.args.encrypted
```

### Using The Key During The Build

Before running a command that needs SSH available make sure to run the following commands in that container. They will set up the SSH key so you can access external services.

```shell
mkdir -p "$HOME/.ssh"
echo -e $PRIVATE_SSH_KEY >> $HOME/.ssh/id_rsa
```

### Cloning Another Repo

Once you have the SSH authentication working, then you'll just need a Dockerfile that grabs git and clones the repo you want.

You will also need the use the `ARG` declaration in your Dockerfile to declare which argument from your [encrypted build arguments file]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}) you will be using.

```dockerfile
FROM ubuntu:latest
ARG PRIVATE_SSH_KEY

RUN apt-get update \
  && apt-get install -y --no-install-recommends\
    ca-certificates  \
    git-core \
    ssh \

RUN mkdir -p "$HOME/.ssh" \
  && echo -e $PRIVATE_SSH_KEY >> $HOME/.ssh/id_rsa \
  && git clone repo:repo.git

COPY . ./
```

Note that this is a high-level, directional example and will require additional work to use in a live build.

## Building With Repos Via API

You can also use the API v2 to programmatically trigger builds that depend on each other, or potentially an external event or system.

To get more details on how to do this, head over to the [API Documentation]({{ site.baseurl }}{% link _general/integrations/api.md %}) page
