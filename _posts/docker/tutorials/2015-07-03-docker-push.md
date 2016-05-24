---
title: "Tutorial: Pushing to a remote registry"
layout: page
weight: 45
tags:
  - docker
  - tutorial
  - push
  - registry
categories:
  - docker
---

* include a table of contents
{:toc}

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% post_url docker/jet/2015-05-25-installation %}).
</div>

## Pushing to a locally running registry

Please see the [example in the codeship-tool examples repository](https://github.com/codeship/codeship-tool-examples/tree/master/16.docker_push) for how to run a registry during the build process and push a new image to this registry.

## Pushing to the Docker Hub

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
    dockerfile_path: Dockerfile
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

## Pushing to Quay.io

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
    dockerfile_path: Dockerfile
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

## Pushing to tags

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

As always, feel free to contact [support@codeship.com](mailto:support@codeship.com) if you have any questions.
