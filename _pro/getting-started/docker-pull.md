---
title: "Tutorial: Using private base images"
layout: page
weight: 43
tags:
  - docker
  - tutorial
  - pull
  - registry

redirect_from:
  - /docker/docker-pull/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}).
</div>

* include a table of contents
{:toc}

## Using A Private Base Image In Your Builds

Using Codeship Pro, you can easily use private Docker images as base images for your containers.

Similar to [pushing images]({{ site.baseurl }}{% link _pro/getting-started/docker-push.md %}), you need to save your encrypted `dockercfg` file in the registry and reference it for any step using private base images (or for groups of steps). You also need to specify in your `Dockerfile` and your `codeship-services.yml` file which images from your registry you want to use.

You can also pull images from multiple registries within the same build, as long as you provide all necessary credentials.

## Encrypting Your Registry Account Credentials

To download a private base image, you'll need to provide your account credentials so that your Docker builds can authenticate with the registry and access your image. You'll probably want to encrypt these credentials to keep them secure.

To encrypt your image registry credentials:

* Get the AES encryption key from the _General_ settings page of your Codeship project and save it to your registry as `codeship.aes` (adding it to the `.gitignore` file is a good idea).

* Run the `jet encrypt` command against your image registry `dockercfg` file. See below for guidance on creating this file depending on which image registry you're using.

## Using Private Base Images From Dockerhub

To use an image from Dockerhub, you'll first need to login locally and `mv` the credentials file to your registry.

```bash
docker login
# follow the onscreen instructions
# ...
jet encrypt ${HOME}/.docker/config.json dockercfg.encrypted
# or (depending if you are on an older version of Docker)
jet encrypt ${HOME}/dockercfg dockercfg.encrypted
```

Next, you'll want to configure your `Dockerfile`. It will probably look similar to the following:

```Dockerfile
FROM username/registry_name
# ...
```

You will also need to configure your `codeship-steps.yml` file to provide your account credentials on every step that uses an image from your Dockerhub account.

```yaml
- service: app
  command: /bin/true
  encrypted_dockercfg_path: dockercfg.encrypted
```

## Using Private Base Images From Quay.io

Quay.io has slightly different permissions and specification requirement than Dockerhub, so make sure to provide the necessary specifications for accessing your Quay repos.

* First configure a [robot account](http://docs.quay.io/glossary/robot-accounts.html)

* Once you have configured the robot account, download the `dockercfg` file for this account, by heading over to the _Robots Account_ tab in your settings, clicking the gear icon, selecting _View Credentials_ and hitting the download button.

* Save the file as `dockercfg` in your registry, encrypt it and add the unencrypted version to

`.gitignore`

```bash
echo "dockercfg" >> .gitignore
jet encrypt dockercfg dockercfg.encrypted
```

* Now commit `dockercfg.encrypted` as well as the `.gitignore` file:

```bash
git add dockercfg.encrypted .gitignore
git commit -m "Adding encrypted credentials for docker push"
```

With your permissions defined for your Quay.io account, you'll now want to make sure your image definitions specify the Quay.io registry.

In your `Dockerfile`:

```Dockerfile
FROM quay.io/username/registry_name
# ...
```

You will also need to configure your `codeship-steps.yml` file to provide your account credentials on every step that using an image from your Quay.io registry.

```yaml
- service: app
  command: /bin/true
  encrypted_dockercfg_path: dockercfg.encrypted
```

## Using Private Base Images From Self-Hosted Registries

You can also access images from privately or self-hosted registries.

In your `Dockerfile`:

```Dockerfile
FROM registryURL/username/registry_name
# ...
```

You will also need to configure your `codeship-steps.yml` file to provide your account credentials on every step that using a private base image.

```yaml
- service: app
  command: /bin/true
  encrypted_dockercfg_path: dockercfg.encrypted
```

## Common Problems

### Invalid character / Failed to parse dockercfg

You might see an error like this when pulling a private base image using your encrypted `dockercfg` file:

``Failed to parse dockercfg: invalid character '___' after top-level value``

This  means that either your `dockercfg` has a syntax problem or that it was encrypted with an incorrect or incomplete AES key, or an AES key from another project.

Try deleting your `dockercfg` and your AES key, then re-downloading the AES key and re-encrypting the `dockercfg` file.

### No key

Sometimes you might see this error the first time you go to encrypt your `dockercfg` file:

``jet: no key``

This means your AES key is missing from your project directory and must be downloaded according to [the instructions above.](#configuring-a-build-with-a-private-base-image)

### Need a key regenerated

If you need a key regenerated, you can submit a ticket to the help desk from your account. Keep in mind that this will leave current encrypted credentials and environmental variables invalid for future builds on Codeship until they are re-encrypted using the new key.
