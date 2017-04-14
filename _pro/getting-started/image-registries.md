---
title: "Using Image Registries"
layout: page
weight: 44
tags:
  - docker
  - tutorial
  - push
  - registry

redirect_from:
  - /docker/docker-push/
  - /pro/getting-started/docker-push/
  - /pro/getting-started/docker-pull/
  - /pro/getting-started/dockercfg-services/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/getting-started/cli.md %}).
</div>

* include a table of contents
{:toc}

## Pushing Images To Registries

### Pushing to a locally running registry

Please see the [example in the codeship-tool examples repository](https://github.com/codeship/codeship-tool-examples/tree/master/16.docker_push) for how to run a registry during the build process and push a new image to this registry.

### Pushing to the Docker Hub

* Get the AES encryption key from the _General_ settings page of your Codeship project and save it to your repository as `codeship.aes` (adding it to the `.gitignore` file is a good idea).

* Login to the Docker Hub locally and save the encrypted credentials file to your repository.

```bash
docker login
# follow the onscreen instructions
# ...
jet encrypt ${HOME}/.docker/config.json dockercfg.encrypted
git add dockercfg.encrypted
git commit -m "Adding encrypted credentials for docker push"
```

* Configure your `codeship-services.yml` file. It will probably look similar to the following:

```yaml
app:
  build:
    image: username/repository_name
    dockerfile: Dockerfile
```

* Configure your `codeship-steps.yml` file. Your service `image_name` can differ from the repository defined in your steps file. Your image will be tagged and pushed based on the `push` step.

    If you don't want to push the image for each build, add a `tag` entry to the below step and it will only be run on that specific branch or git tag.

```yaml
- service: app
  type: push
  image_name: username/repository_name
  registry: https://index.docker.io/v1/
  encrypted_dockercfg_path: dockercfg.encrypted
```

* Commit and push the changes to your remote repository, head over to [Codeship](https://codeship.com/), watch your build and then check out your new image!

### Pushing to Quay.io

**Prerequisites:** You will need to have a robot account for your Quay repository. Please see the documentation on [Robot Accounts](http://docs.quay.io/glossary/robot-accounts.html) for Quay.io on how to set it up for your repository.

* Once you have configured the robot account, download the `.dockercfg` file for this account, by heading over to the _Robots Account_ tab in your settings, clicking the gear icon, and selecting _View Credentials_. Then select _Docker Configuration_ and download the credentials config file.

    Save the file as `dockercfg` in your repository (you'll probably want to add it to the `.gitignore` file as well).

* Get the AES encryption key from the _General_ settings page of your Codeship project and save it to your repository as `codeship.aes` (again, adding it to the `.gitignore` file is a good idea).

* Encrypt the credentials for accessing Quay.io by running the following command and commit the encrypted file to your repository.

```bash
jet encrypt dockercfg dockercfg.encrypted
git add dockercfg.encrypted
git commit -m "Adding encrypted credentials for docker push"
```

* Add the robot user to the Quay.io repository with the appropriate permissions (at least _Write_).

* Configure your `codeship-services.yml` file. It will probably look similar to the following:

```yaml
app:
  build:
    image: quay.io/username/repository_name
    dockerfile: Dockerfile
```

* Configure your `codeship-steps.yml` file. Your service `image_name` can differ from the repository defined in your steps file. Your image will be tagged and pushed based on the `push` step.

    If you don't want to push the image for each build, add a `tag` entry to the below step and it will only be run on that specific branch or git tag.

```yaml
- service: app
  type: push
  image_name: quay.io/username/repository_name
  registry: quay.io
  encrypted_dockercfg_path: dockercfg.encrypted
```


* Commit and push the changes to your remote repository, head over to [Codeship](https://codeship.com/), watch your build and then check out your new image!

### Pushing to tags

Along with being able to push to private registries, you can also push to tags other than `latest`. To do so, simply add the tag as part of your push step using the `image_tag` declaration.

```yaml
- service: app
  type: push
  image_name: quay.io/username/repository_name
  image_tag: dev
  registry: quay.io
  encrypted_dockercfg_path: dockercfg.encrypted
```

This `image_tag` field can contain a simple string, or be part of a [Go template](http://golang.org/pkg/text/template/). You can compose your image tag from a variety of provided values. __Note__ that because we use Go for our Regex support, negative regexes and conditional regexes are  not supported.

* `ProjectID` (the Codeship defined project ID)
* `BuildID` (the Codeship defined build ID)
* `RepoName` (the name of the repository according to the SCM)
* `Branch` (the name of the current branch)
* `CommitID` (the commit hash or ID)
* `CommitMessage` (the commit message)
* `CommitDescription` (the commit description, see footnote)
* `CommitterName` (the name of the person who committed the change)
* `CommitterEmail` (the email of the person who committed the change)
* `CommitterUsername` (the username of the person who committed the change)
* `Time` (a golang [`Time` object](http://golang.org/pkg/time/#Time) of the build time)
* `Timestamp` (a unix timestamp of the build time)
* `StringTime` (a readable version of the build time)
* `StepName` (the user defined name for the `push` step)
* `ServiceName` (the user defined name for the service)
* `ImageName` (the user defined name for the image)
* `Ci` (defaults to `true`)
* `CiName` (defaults to `codeship`)

To tag your image based on the Commit ID, use the string `"{% raw %}{{ .CommitID }}{% endraw %}"`. You can template together multiple keys into a tag by simply concatenating the strings: `"{% raw %}{{ .CiName }}-{{ .Branch }}{% endraw %}"`. Be careful about using raw values, however, since the resulting string will be stripped of any invalid tag characters.

## Pulling Images From Registries

### Using A Private Base Image In Your Builds

Using Codeship Pro, you can easily use private Docker images as base images for your containers.

Similar to [pushing images]({{ site.baseurl }}{% link _pro/getting-started/image-registries.md %}), you need to save your encrypted `dockercfg` file in the registry and reference it for any step using private base images (or for groups of steps). You also need to specify in your `Dockerfile` and your `codeship-services.yml` file which images from your registry you want to use.

You can also pull images from multiple registries within the same build, as long as you provide all necessary credentials.

### Encrypting Your Registry Account Credentials

To download a private base image, you'll need to provide your account credentials so that your Docker builds can authenticate with the registry and access your image. You'll probably want to encrypt these credentials to keep them secure.

To encrypt your image registry credentials:

* Get the AES encryption key from the _General_ settings page of your Codeship project and save it to your registry as `codeship.aes` (adding it to the `.gitignore` file is a good idea).

* Run the `jet encrypt` command against your image registry `dockercfg` file. See below for guidance on creating this file depending on which image registry you're using.

### Using Private Base Images From Dockerhub

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

### Using Private Base Images From Quay.io

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

### Using Private Base Images From Self-Hosted Registries

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

### Common Problems

#### Invalid character / Failed to parse dockercfg

You might see an error like this when pulling a private base image using your encrypted `dockercfg` file:

``Failed to parse dockercfg: invalid character '___' after top-level value``

This  means that either your `dockercfg` has a syntax problem or that it was encrypted with an incorrect or incomplete AES key, or an AES key from another project.

Try deleting your `dockercfg` and your AES key, then re-downloading the AES key and re-encrypting the `dockercfg` file.

#### No key

Sometimes you might see this error the first time you go to encrypt your `dockercfg` file:

``jet: no key``

This means your AES key is missing from your project directory and must be downloaded according to [the instructions above.](#configuring-a-build-with-a-private-base-image)

#### Need a key regenerated

If you need a key regenerated, you can submit a ticket to the help desk from your account. Keep in mind that this will leave current encrypted credentials and environmental variables invalid for future builds on Codeship until they are re-encrypted using the new key.

## Generating Credentials With A Service

Codeship supports using private registries for pulling and pushing images by allowing static dockercfg credentials to be encrypted as part of your codebase. Due to an increasing number of container registry vendors using different methods to generate Docker temporary credentials, we have added support for custom dockercfg credential generation. By using a custom service within your list of Codeship services, you can integrate with a standard dockercfg generation container for your desired provider. Codeship will provide a basic set of images supporting common providers, however you will also be able to use custom images to integrate with custom registries.

### Using a service to generate Docker credentials

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

### Creating your own dockercfg generator image

The majority of container registries use standard, static credentials, and even using a custom authentication proxy, most of the time you can generate a compatible static dockercfg and encrypt it for use within your pipeline. Should you need to use dynamic credentials, or some other method of securely retrieving static credentials during the CI/CD process, you'll need to use a generator service. Luckily creating your own image is simple, the only requirement is that the image writes the dockercfg to a path provided via a `CMD` argument.

```
$ docker run -it -v /tmp/:/opt/data mygenerator /opt/data/dockercfg
$ cat /tmp/dockercfg # read generated dockercfg
```

The container must be provided with any credentials or configuration needs to generate a dockercfg via environment variables. When the image is being used in a build, this information is provided via the service definition in the `codeship-services.yml` file. Codeship will run the container any time it needs to generate the dockercfg, however the cost of this can be mitigated by locally caching credentials using a host volume mount defined in the service definition. The container image would be responsible for managing this cached folder, and checking the presence and validitity of credentials in the cache before returning them.

### Integrations

Here is a list of the standard dockercfg generators we support. If you don't see your desired provider on this list, please reach out to support, or create it yourself.

* [AWS ECR](https://github.com/codeship-library/aws-deployment)
* [Google GCR](https://github.com/codeship-library/gcr-dockercfg-generator)
