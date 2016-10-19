---
title: "Tutorial: Encrypting environment variables"
layout: page
weight: 45
tags:
  - docker
  - tutorial
  - encryption
categories:
  - docker
---

If you need to make private information available to your build, you can save this information encrypted in your repository. This is most often needed to either make credentials used during deployment available or store credentials for a Docker registry. See e.g our [Docker Push]({{ site.baseurl }}{% post_url docker/tutorials/2015-07-03-docker-push %}) tutorial for a practical example.

* include a table of contents
{:toc}

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% post_url docker/jet/2015-05-25-installation %}).
</div>

## Getting the key

### Codeship.com

If you have a project on https://codeship.com, head over to the _General_ page of your project settings and you'll find a section labeled _AES Key_ which allows you to either copy or download the key.

![AES key]({{ site.baseurl }}/images/docker/aes_key.png)

Save that file as `codeship.aes` in your repository root and don't forget to add the key to your `.gitignore` file so you don't accidentally commit it to your repository.

```bash
echo "KEY_COPIED_FROM_CODESHIP.COM" > codeship.aes
echo "codeship.aes" >> .gitignore
```

_P.S.: This key is of course not a real key in use by one of our projects :)_

### For local use only

If you don't have a project running on Codeship.com already, or just want to test the tool locally you can generate a key yourself. Please note, that you'll need to re-encrypt all files with the key from Codeship once you want to build your project on our hosted plattform.

```bash
jet generate
echo "codeship.aes" >> .gitignore
```

This will generate a `codeship.aes` in your current directory and add it to the `.gitignore` file.

## Environment variables

Let's say you have a file with environment variables, that you want to make available to your builds. Save the file as e.g. `deployment.env` in your repository. It could contain the following data

```
# AWS
AWS_ACCESS_KEY_ID=XXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=XXXXXXXXX
AWS_DEFAULT_REGION=us-east-1
AWS_S3_BUCKET=documentation.codeship.com
```

To encrypt this file with the key saved previously you would run the following commands

```bash
# jet encrypt [--key-path=codeship.aes] plain_file encrypted_file
jet encrypt deployment.env deployment.env.encrypted
# also add the plain text version to .gitignore
echo "deployment.env" >> .gitignore
```

To load the file during the build adapt your `codeship-services.yml` and reference the encrypted files

```yaml
aws:
  build:
     image: codeship/aws-deployment:latest
  encrypted_env_file: deployment.env.encrypted
```

If you need to decrypt the encrypted file run the following command instead

```bash
# jet decrypt [--key-path=codeship.aes] encrypted_file plain_file
jet decrypt deployment.env.encrypted deployment.env
```

If you want to run through a complete example with a working services and steps file, please see our [Encryption Example](https://github.com/codeship/codeship-tool-examples/tree/master/11.encrypted-aes) on GitHub.

## Docker configuration

See the tutorials on [Docker Push]({{ site.baseurl }}{% post_url docker/tutorials/2015-07-03-docker-push %}) and [Private Base Images]({{ site.baseurl }}{% post_url docker/tutorials/2015-08-12-docker-pull %}) for the exact steps required to encrypt the Docker configuration.
