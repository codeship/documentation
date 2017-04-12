---
title: Getting Started With Codeship Pro Part 3
layout: page
weight: 13
tags:
  - docker
  - jet
  - codeship pro
  - introduction
  - getting started
  - tutorial
  - getting started jet

redirect_from:
  - /docker-guide/getting-started-part-three/
---

* include a table of contents
{:toc}

The source for the tutorial is available on Github as [codeship/ci-guide](https://github.com/codeship/ci-guide/) and you can clone it via

```bash
git clone git@github.com:codeship/ci-guide.git
```

## Getting Started With Codeship Pro (Part 3)

Now that you have a working CI process with a successful test, the next step is to push out your Docker image!

## Required Services Before We Push

### A Codeship Pro Project

The first thing you'll need is a working Codeship account with a Codeship Pro project (**Codeship Pro is now free for 100 builds per month, 1 concurrent build, unlimited projects and unlimited users**).
When creating your new project, make sure to select Codeship Pro after choosing the repo you're using.

![Selecting Codeship Pro]({{ site.baseurl }}/images/gettingstarted/setup_select_docker.png)

If you don't have a repo configured, just create a new repo on Github and push the code examples we've been using so far.

### An Image Registry Account

Now, you're also gonna need an image repo account. For this example, we're gonna go with Dockerhub but you could use Quay.io or your own self-hosted image repo.

## Let's Do A Push

Now that we have our accounts created, let's go ahead and open up our `codeship-steps.yml` file. After our test step, we're going to add a new step - a `push` step.

Add the following code, and then we'll go through it, to discuss what's happening and what we need to do to make it work.

```yaml
- type: parallel
  steps:
    - name: checkrb
      service: demo
      command: bundle exec ruby check.rb
    - name: test
      service: demo
      command: bundle exec ruby test.rb

- type: serial
  steps:
    - name: dockerhub_push
      service: demo
      type: push
      image_name: account/repo
      registry: https://index.docker.io/v1/
      encrypted_dockercfg_path: dockercfg.encrypted
```

There are a few things to note here:

* `Push` is the step type we use to signify that we're pushing out the image defined or built by our service.

* `Image name` takes a slightly different form depending on the repo - if it's Dockerhub, it's `account_name/repo_name`. This is your repo account name and then the name of the specific repo on your account you're pushing to. You'll need to review specific documentation if you're using Quay.io / AWS ECR or a private repo to make sure the name is defined correctly.

* `Registry` is the unique push URL for the image repo. Again, this varies per registry so if you're not using Dockerhub be sure to verify that you get the right value for this.

* `Encrypted_dockercfg_path` is where we grab the credentials for your image repo account from. But, why is it encrypted and how did we encrypt it? Let's take a look at that now...

## Encrypted Credentials

So, just like we did with our environmental variables in the previous lesson, we'll want to encrypt our image repository examples so that our repo doesn't have our logins sitting around in plain text.

First, if you didn't do it on the last step, you'll need to download your project's AES key in to your code's directory. To get the AES key, just go to your project on Codeship.com and look at the project settings.

![Downloading AES key]({{ site.baseurl }}/images/gettingstarted/aes_key.png)

Now that you've downloaded your AES key, we'll created a new file named `dockercfg` where we'll drop in our Dockerhub credentials:

```json
{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "auth_key",
			"email": "email"
		}
	}
}
```

To get our auth key, we'll need to go back to our terminal and run:

```bash
docker login
cat ${HOME}/.docker/config.json
```

This will print the `auths` value that we need to add to our `dockercfg` file. Once we've added this information to our `dockercfg` file and saved it, we'll run:

```bash
jet encrypt dockercfg dockercfg.encrypted
```

You should see your new `dockercfg.encrypted` file populate. Now, you'll want to remove your unencrypted version - or, at the very least, add it to your **.gitignore** file.

## Push!

Now, assuming you've swapped in your credentials in the push step and created your encrypted Dockercfg file, it's time to push all this up and run our build!

Let's go back to our terminal and run:

```
git add .
git commit . -m "Deploying our image"
git push origin master
```

## Look At Web UI and Repo

Now that we've got our build running, let's hop over the web UI and look for evidence of our successful push.

When we click in to our build logs, we should able to click our push step and see something like this:

![Push step log output]({{ site.baseurl }}/images/gettingstarted/pushlogs.png)

Now, if we go over to our Dockerhub repo, we should see some meta data indicating a successful push:

![Dockerhub repo screenshot]({{ site.baseurl }}/images/gettingstarted/dockerhub-recent-push.png)

## Up Next: Using Volumes

Now we've built an app, added a test, pushed an image and deployed our code. What's next?

We want to walk through a couple of the powerful, flexible things you can achieve with Codeship Pro - and we're going to start with *volumes*. [Let's learn about volumes.]({% link _pro/getting-started/getting-started-part-four.md %})
