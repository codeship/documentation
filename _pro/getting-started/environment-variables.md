---
title: "Environment Variables With Codeship Pro"
layout: page
weight: 41
tags:
  - docker
  - encryption
  - environment variables

redirect_from:
  - /docker/encryption/
  - /pro/getting-started/encryption/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}).
</div>

* include a table of contents
{:toc}

Using Codeship Pro, you can set environment variables in two formats: Encrypted and unsecured.

This is important because some environment variables may not need to be securely stored, but some may relate to authentication or deployment access and therefore need to be secured and never visible in your repo or configuration files.

## Unsecured Environment Variables

You can set your environment variables directly in your [Services file]({{ site.baseurl }}{% link _pro/getting-started/services.md %}), or via your Dockerfile.

### Via Services File

To set unsecured enviroment variables via your [Services file]({{ site.baseurl }}{% link _pro/getting-started/services.md %}), you will use the `environment` specification. For example:

```
app:
  build:
    image: myorg/appname
    dockerfile_path: Dockerfile
  environment:
    - NAME=Codeship
    - URL=www.codeship.com
```

### Via Dockerfile

To set unsecured environment variables via your Dockerfile, you will use the `ENV` directive. For example:

```
FROM ubuntu:latest
ENV URL=www.codeship.com
```

## Encrypted Environment Variables

The most common way to use environment variables on Codeship Pro is by using our `encrypted_env_file` option. This lets you keep all environment variables securely encrypted, via a project-specific AES KEY, and therefore never explicitly visible in your repo.

By doing this, you never have to worry about using environment variables for passing your secrets to your CI/CD pipeline and to your builds.

### Downloading Your AES Key

If you have a project on https://codeship.com, head over to the _General_ page of your project settings and you'll find a section labeled _AES Key_ which allows you to either copy or download the key.

![AES key]({{ site.baseurl }}/images/docker/aes_key.png)

Save that file as `codeship.aes` in your repository root and don't forget to add the key to your `.gitignore` file so you don't accidentally commit it to your repository.

### Encrypting Your Environment Variables

To encrypt your environment variables, first create a new text file with your variables defined in it. In this case, let's call the file `env` and add some example environment variables:

```
NAME=codeship
URL=www.codeship.com
```

Once you create this file and save it in your project directory, we'll encrypt it. This will require that you have installed the [Jet CLI]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}) and that you have downloaded your [AES key](#downloading-your-aes-key) to your project root, as well.

From your terminal, you will run:

```bash
jet encrypt env env.encrypted
```

In this example `env` is the name of the text file containing your environment variables, and `env.encrypted` is the name of the encrypted file.

**Note** that both names are customizable and up to you. Once encrypted, you also want to make sure to add your origin, plain-text `env` file to your `.gitignore`, or to delete it altogether.

### Using Your Encrypted Environment Variables

Now that you have created your encrypted environment variables file (and added the plain-text version to your `.gitignore`), you will want to use the encrypted file in your [Services file]({{ site.baseurl }}{% link _pro/getting-started/services.md %}). You do this using the `encrypted_env_file` directive. For example:

```
app:
  build:
    image: myorg/appname
    dockerfile_path: Dockerfile
  encrypted_env_file: env.encrypted
```

### Decrypting

If you need to decrypt the encrypted file run the following command instead

```bash
jet decrypt env.encrypted env
```

Just like when encrypting but in reverse, `env.encrypted` is the name of the file you want to decrypt and `env` is the name you give to the decrypted file.

## Notes And Common Questions

### Build Arguments

If you want to set environment variables just for the purpose of using secrets in your Dockerfile, you will want to use [build arguments](https://docs.docker.com/compose/compose-file/#/args). Build arguments are buildtime-only variables populated just for the purposes of being used in your Dockerfiles.

### Image Push Registry Authentication

See the tutorials on [Docker Push]({{ site.baseurl }}{% link _pro/getting-started/docker-push.md %}) and [Private Base Images]({{ site.baseurl }}{% link _pro/getting-started/docker-pull.md %}) for the exact steps required to encrypt the Docker configuration.

### Managing Local Credential Differences

In some situations, you may find that you want to run one set of credentials locally and a different set during your Codeship builds. Or, some developers on your team may need to use different sets of credentials. There is no ideal way to resolve this issue, at the moment, although we hope to solve for it better in the future.

For the time being, there are several workarounds that may be worth investigating for your team if you have this need:

- You can create another, separate version of your service in your [Services file]({{ site.baseurl }}{% link _pro/getting-started/services.md %}), such as `services_local` , that would use a different encrypted env file. Your team would keep this alternative file locally, with their personal credentials, and it would be added to .gitignore so that it is not committed. Your [Steps file]({{ site.baseurl }}{% link _pro/getting-started/steps.md %}) would only reference your main service definition, which would use the encrypted env file that you commit. Locally with the [Jet CLI]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}), you would run `jet steps service_name command` rather than just `jet steps`.

- You could keep a different encrypted env file on hand locally. From there, you would maintain local `.gitignore` files so that the local credential files are not committed by individual developers and only the canonical, production encrypted environment file would be in the repo. The developers would then need to override the pulled encrypted enviroment variables file with their own, but it would be ignored on all commits back to the repo because of the `.gitignore`.

- Your team could also maintain branches just for local development, and these branches would not have any environment variables file committed on them. Developers could then maintain a local env file that is never committed, with the main branches continuing to host a primary, encrypted environment variables file.
