---
title: Build Notifications
layout: page
tags:
  - administration
  - notifications

redirect_from:
  - /administration/notifications/
  - /basic/getting-started/webhooks/

---

* include a table of contents
{:toc}

## Configuring Build Notifications

To configure build notifications, go to your *Project Settings* and then click into the **Notifications** tab.

## Email notification

By default anyone who either owns a project or was added as a team member will receive an email whenever a build fails and if a build on a branch passes when the previous one failed. Therefore, whenever a branch is back to OK you will be notified.

### Disable Email

If you don't want to receive any emails you can set that on your [account page](https://www.codeship.com/user/edit).

### Receive emails when I am involved

In your project's notification settings you can set the option that you only receive an email when the build was on the master branch or if you started this build.

## Notification Integrations

You will get notifications whenever a build starts and finishes. All information about the result and a link to it will be in the message.

We have support for the following chat notification systems. Currently you can't customize the messages sent by Codeship.

* Hipchat
* Slack
* Flowdock
* Grove.io
* Campfire

* include a table of contents
{:toc}

## Shipscope - Chrome Extension

Monitor your Codeship projects and builds with [Shipscope](https://chrome.google.com/webstore/detail/shipscope/jdedmgopefelimgjceagffkeeiknclhh). Shipscope lists all of your Codeship projects and presents the status of recent builds in the Chrome toolbar. You can restart a build or go straight to the build details on the Codeship service.

The Shipscope notifications presented by Chrome will end up in the Notification Center. If you would like to prevent Shipscope notifications in the Notification Center, simply:

1. Click the bell icon in the lower right corner of your computer screen (on Windows) or the upper right of your computer screen (on Mac) to open the Notifications Center.

2. In the Notifications Center, click the gear icon  on the bottom right corner (on Windows) or the upper right corner (on Mac).

3. Uncheck the box next to "Shipscope".

Shipscope is open source and lives on [GitHub](https://github.com/codeship/shipscope).

## Webhooks For Custom Notifications

Go to the _Notification_ settings of your project and enter the HTTP endpoint of the service you want to notify.

![Webhooks]({{site.baseurl}}/images/integrations/webhooks.png)

### Webhooks Payload

We send you a POST request containing the following build data

```json
{
  "build": {
    "build_url":"https://www.codeship.com/projects/10213/builds/973711",
    "commit_url":"https://github.com/codeship/docs/
                  commit/96943dc5269634c211b6fbb18896ecdcbd40a047",
    "project_id":10213,
    "build_id":973711,
    "status":"testing",
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

- `testing` for newly started build
- `error` for failed builds
- `success` for passed builds
- `stopped` for stopped builds
- `waiting` for waiting builds
- `ignored` for builds ignored because the account is over the monthly build limit
- `blocked` for builds blocked because of excessive resource consumption
- `infrastructure_failure` for builds which failed because of an internal error on the build VM

## GitHub, Bitbucket and Gitlab Status API

We will automatically use the status API for pull requests on Github, Bitbucket and Gitlab. This does not need to be explicitly enabled, although it can be disabled via your *Project Settings*.
