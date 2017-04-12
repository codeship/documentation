---
title: Continuous Delivery to Heroku with Docker
weight: 46
tags:
  - deployment
  - heroku
  - docker

redirect_from:
  - /docker-integration/heroku/
---

<div class="info-block">
You can find a sample repo for deploying to Heroku with Codeship Pro on Github [here](https://github.com/codeship-library/heroku-deployment).
</div>

* include a table of contents
{:toc}

To make it easy for you to deploy your application to Heroku we've built a container that has the Heroku Toolbelt and additional scripts installed. We will set up a simple example showing you how to configure the deployment.

<h1>{{ page.collection }}</h1>


The deployment uses the [Heroku Platform API](https://devcenter.heroku.com/articles/build-and-release-using-the-api) to deploy your application, so no SSH key management is necessary.

## Authentication

Before setting up the `codeship-services.yml` and `codeship-steps.yml` file we're going to create an encrypted environment file that contains the Heroku API Key.

Take a look at our [encrypted environment files documentation]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}) and add a `heroku-deployment.env.encrypted` file to your repository. The file needs to contain an encrypted version of the following file:

```bash
HEROKU_API_KEY=your_api_key_here
```

You can get the Heroku API Key from your [Heroku Dashboard](https://dashboard.heroku.com/account) or other methods outlined in the [Heroku documentation](https://devcenter.heroku.com/articles/platform-api-quickstart#authentication).

## Service Definition

In the `codeship-services.yml` we're starting a Docker build with the aforementioned `Dockerfile.deploy`. We can then use the newly created container to deploy our application through the `codeship-steps.yml`.

```yaml
herokudeployment:
  image: codeship/heroku-deployment
  encrypted_env_file: heroku-deployment.env.encrypted
  volumes:
    - ./:/deploy
```

## Deploy Steps

The container has a `codeship_heroku deploy` command that you need to call with the path to your application, here provided through a host volume in `/deploy`, and your application name. The script will then check that it has access to the application and deploy it.

By providing the location of the application that should be deployed you can deploy subfolders of your app, or even run different commands on your codebase before deploying it so e.g. assets can already be created.

As the container has the Heroku Toolbelt installed you can use other Heroku commands in further steps, e.g. to run your database migrations.

```yaml
- service: herokudeployment
  command: codeship_heroku deploy /deploy codeship-heroku-deployment
- service: herokudeployment
  command: heroku run --app codeship-heroku-deployment -- bundle exec rake db:migrate
```
