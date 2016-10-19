---
title: "Tutorial: Custom Notifications"
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

## Notifications

Codeship allows you to configure a number of standard notifications for your build via your project settings. For details on what notification methods are supported, as well as how to configure notifications for your builds, check out the [documentation]({{ site.baseurl }}{% post_url administration/2014-09-02-notifications %}#encryption-commands).

## Custom Notifications

You can also define custom steps in your build pipeline to push notifications via methods not supported by Codeship. This tutorial will cover using a simple slack script as a custom notification method.

### The notification script

First of all, we can create a simple notification script, pulling all configuration and credentials from environment variables, or mounted volumes should we need to use build artifacts.

```bash
#!/bin/sh
# Post to Slack channel on new deployment
# https://api.slack.com/incoming-webhooks
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
SLACK_WEBHOOK_TOKEN=${SLACK_WEBHOOK_TOKEN:?'You need to configure the SLACK_WEBHOOK_TOKEN environment variable!'}
SLACK_BOT_NAME=${SLACK_BOT_NAME:="Codeship Bot"}
SLACK_ICON_URL=${SLACK_ICON_URL:="https://d1089v03p3mzyq.cloudfront.net/assets/website/logo-dark-90f893a2645c98929b358b2f93fa614b.png"}
SLACK_MESSAGE=${SLACK_MESSAGE:?"${CI_COMMITTER_USERNAME} just deployed version ${CI_COMMIT_ID}"}

curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "'"${SLACK_BOT_NAME}"'",
  "text": "'"${SLACK_MESSAGE}"'",
  "icon_url": "'"${SLACK_ICON_URL}"'"}' \
  https://hooks.slack.com/services/$SLACK_WEBHOOK_TOKEN
```

### Integrating the notification script

It's quite simple to integrate a simple script like this into the deployment pipeline. First we can build it into a standalone container, or use an existing one from elsewhere in the pipeline which has the deploy script added to it.

```
# Dockerfile.notify
FROM ubuntu

RUN apt-get install -y curl

ADD ./slack ./
```

We'll need to provide this container with the necessary environment variables. The standard `CI_*` variables will be provided automatically, however we'll need to provide the `SLACK_WEBHOOK_TOKEN`. This can be safely injected via the `encrypted_env_file` service declaration, and the [encryption commands]({{ site.baseurl }}{% post_url docker/jet/2015-05-25-cli %}#encryption-commands). By encrypting this environment variable, and adding it to our repository, it can be later decoded and provided to our notifications container.

```yaml
deploynotify
  build:
    image: myuser/myrepo-deploynotify
    dockerfile_path: Dockerfile.notify
  encrypted_env_file: deploy.env.encrypted
```

By adding a relevant step to the steps file, we can control under what conditions this notification fires.

```yaml
- service: deploynotify
  command: ./slack
  tag: master
```

## Other integrations

Since you can integrate any container you wish into your pipeline, there are no limitations on what notifications you can use. You can see some other examples of custom notifications [here](https://github.com/codeship/scripts/tree/master/notifications).

 As always, feel free to contact [support@codeship.com](mailto:support@codeship.com) if you have any questions.