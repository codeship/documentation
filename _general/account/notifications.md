---
title: Managing Your CI/CD Build Notifications
shortTitle: Managing Notifications
tags:
  - administration
  - notifications
  - alerts
  - account
  - slack
  - hipchat
  - shipscope
categories:
  - Account  
redirect_from:
  - /administration/notifications/
  - /basic/getting-started/webhooks/
  - /integrations/webhooks/
menus:
  general/account:
    title: Notifications
    weight: 3
---

* include a table of contents
{:toc}

## Notifications Overview

As a default, we've setup a notification rule that sends an email to everyone on the team, whenever something happens to the builds in the project, regardless of branch.

Notification rules are grouped by branch, or branches, and you can setup as many as you like. Each rule applies to one service, so if you want to e.g. send the same notification to two slack channels, you'll have to setup two rules.

Each group can apply to a specific branch, e.g. `master`, or multiple branches that match a pattern, e.g. `feature/*`.

![Notifications]({{ site.baseurl }}/images/general/notifications.gif)

### Branch Matching

If you use the wildcard `*` in the branch name, it will try and match to multiple branches. Let's say you have a naming convention for your feature branches that have start with "feature/" followed by some name, you could create a notification rule that matches all feature branches by specifying `feature/*` as the branch name.

The wildcard allows you to replace any amount of characters, so you could even do `*design*feature*` to match any branch that have those two words in it.

### Integrated Notification Services

We have in-build support for the following services:

1. Email
1. Slack
1. Hipchat
1. Flowdock
1. Campfire
1. Grove
1. Webhooks

If the service you're looking for isn't on the list, you might be able to use the `webhook` option but if not, feel free to reach out to us (see bottom of the page).

## Configuring Build Notifications

To configure build notifications, go to your *Project Settings* and then click into the **Notifications** tab.

If you want to add more rules to an existing branch (or branch match) click the `add` button to the right of the branch name. If you want to add rules for a new branch (or branch match) click the big `new notification` button at the bottom of the page.

In case you no longer want to have a specific rule trigger notifications, you can either disable it (use the toggle on the right hand side) or delete it completely.

**Note**: Each service have different detail fields that will need to be populated, so refer to the sections below to see which apply for the service you want to configure.

## Common Configuration

All rules apply to either "All Branches", a names branch, or a branch match. If the field is left empty, the rule will apply to all branches.

Additionally, all rules can select between `started`, `failed`, `succeeded`, and `recovered` as events that trigger a notification. You must select at least one event in order to save the rule.

* `started` -> sends a notification when a new build is triggered
* `failed` -> sends a notification if a build fails for some reason
* `succeeded` -> sends a notification if the build finishes successfully
* `recovered` -> sends a notification if the previous build failed, but the current build succeeded

## Email Notification

For an email rule, you can select whether all members of the project will receive notifications, or only the person whos commit triggered the build.

If only the committer should be notified, either the emails or usernames must be the same in both Codeship and Github/Bitbucket/Gitlab. If they're different, no notifications are sent.

#### Disable Email

If you don't want to receive any emails you can set that on your [account page](https://www.codeship.com/user/edit). This applies to all emails though, and not just for one project.

## Slack

For Slack, the only thing you need is the webhook URL Slack provides when you configure a Codeship integration. Copy-paste the URL to the Webhook URL field.

## Hipchat

Hipchat mainly requires a token and the room that you want the notification to be posted to.

## Flowdock

Flowdock expects a token as well, but the where to send the notification is handled on the flowdock side of things.

## Campfire

For campfire, we need both an API key and your domain name (just the first part, without `.campfirenow.com`) as well as the specific room you want the notifications to end up in.

## Grove

Grove provides specific tokens for each channel, so in this case, that's all we'll need to get going.

## Webhook

Webhooks allows for a range of custom integrations. It's pretty similar to the other services in terms of setup though, as you just need to provide the URL of the webhook we'll need to call.

#### Webhook Payload

When sending the notification to a webhook, we send an HTTP POST request containing the following build data

```json
{
  "build": {
    "build_url":"https://www.codeship.com/projects/10213/builds/973711",
    "commit_url":"https://github.com/codeship/docs/
                  commit/96943dc5269634c211b6fbb18896ecdcbd40a047",
    "project_id":10213,
    "build_id":973711,
    "status":"initiated",
    # PROJECT_FULL_NAME IS DEPRECATED AND WILL BE REMOVED IN THE FUTURE
    "project_full_name":"codeship/docs",
    "project_name":"codeship/docs",
    "commit_id":"96943dc5269634c211b6fbb18896ecdcbd40a047",
    "short_commit_id":"96943",
    "message":"Merge pull request #34 from codeship/feature/shallow-clone",
    "committer":"beanieboi",
    "branch":"master"
  }
}
```

The _status_ field can have one of the following values:

- `initiated` for newly started build
- `error` for failed builds
- `success` for passed builds
- `stopped` for stopped builds
- `waiting` for waiting builds
- `ignored` for builds ignored because the account is over the monthly build limit
- `blocked` for builds blocked because of excessive resource consumption
- `infrastructure_failure` for builds which failed because of an internal error on the build VM

## Custom Notifications With Codeship Pro

Due to Codeship Pro's unique architecture, you have  more flexibility in implementing custom notifications via your [codeship-steps.yml file]({% link _pro/builds-and-configuration/steps.md %}).

In addition to using the above webhooks method, you can also define custom steps in your build pipeline to push notifications via methods not otherwise supported by Codeship.

#### The Notification Script

To look at using your Codeship Pro pipeline for flexible, custom notifications we will review a simple Slack script as a custom notification method.

First of all, we can create a simple notification script, pulling all configuration and credentials from environment variables, or mounted volumes should we need to use build artifacts.

```shell
#!/bin/sh
# Post to Slack channel on new deployment
# https://api.slack.com/incoming-webhooks

# script available at: https://github.com/codeship/scripts/blob/master/notifications/slack.sh

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

#### Integrating the Notification Script

It's quite simple to integrate a simple script like this into the deployment pipeline. First we can build it into a standalone container, or use an existing one from elsewhere in the pipeline which has the deploy script added to it.

```dockerfile
# Dockerfile.notify
FROM ubuntu

RUN apt-get install -y curl

COPY ./slack ./
```

We'll need to provide this container with the necessary environment variables. The standard `CI_*` variables will be provided automatically, however we'll need to provide the `SLACK_WEBHOOK_TOKEN`. This can be safely injected via the `encrypted_env_file` service declaration, and the [encryption commands]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}#encryption-commands). By encrypting this environment variable, and adding it to our repository, it can be later decoded and provided to our notifications container.

```yaml
deploynotify
  build:
    image: myuser/myrepo-deploynotify
    dockerfile: Dockerfile.notify
  encrypted_env_file: deploy.env.encrypted
```

By adding a relevant step to the steps file, we can control under what conditions this notification fires.

```yaml
- service: deploynotify
  command: ./slack
  tag: master
```

#### Other Integrations With Codeship Pro

Since you can integrate any container you wish into your pipeline, there are no limitations on what notifications you can use. In our scripts repo, [you can see other examples of custom notifications.](https://github.com/codeship/scripts/tree/master/notifications).

## Other Ways to Get Notified

### GitHub, Bitbucket and Gitlab Status API

We will automatically use the status API for pull requests on Github, Bitbucket and Gitlab. This does not need to be explicitly enabled, although it can be disabled via the **General** settings of your project.

### Status Badges On Your Repo

If you want to add a badge showing your last builds status to your ReadMe, you can find the code in the **General** settings of your project.

![Codeship Status for codeship/documentation](https://codeship.com/projects/0bdb0440-3af5-0133-00ea-0ebda3a33bf6/status?branch=master)

The raw URL for the image looks like the this:

```
https://codeship.com/projects/YOUR_PROJECT_UUID/status?branch=BRANCH_NAME
```

(The UUID for a specific project is also available on the **General** tab in your project settings)

### Shipscope - Chrome Extension

Monitor your Codeship projects and builds with [Shipscope](https://chrome.google.com/webstore/detail/shipscope/lajnoiemmpanljkbiiclldijcknbbkfm). Shipscope lists all of your Codeship projects and presents the status of recent builds in the Chrome toolbar. You can restart a build or go straight to the build details on the Codeship service.

The Shipscope notifications presented by Chrome will end up in the Notification Center. If you would like to prevent Shipscope notifications in the Notification Center, simply:

1. Click the bell icon in the lower right corner of your computer screen (on Windows) or the upper right of your computer screen (on Mac) to open the Notifications Center.

2. In the Notifications Center, click the gear icon  on the bottom right corner (on Windows) or the upper right corner (on Mac).

3. Uncheck the box next to "Shipscope".

Shipscope is open source and lives on [GitHub](https://github.com/codeship/shipscope).

### CCMenu

CCMenu is not supported at this time, although we hope to address it at a later stage.
