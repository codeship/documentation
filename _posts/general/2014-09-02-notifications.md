---
title: Notification Setup
layout: page
tags:
  - administration
  - notifications
categories:
  - general
---
## Where can I configure Notifications
Click the project menu on the top navigation and click the settings wheel to get to your project settings. There, click the **Notifications** link.

## GitHub Status API
We will use the GitHub Oauth Token we got when you connected Codeship to your GitHub account to set the build status for every commit on GitHub. Take a look at the [blog post by GitHub](https://github.com/blog/1227-commit-status-api) that explains their status API.

## Email notification
By default anyone who either owns a project or was added as a team member will receive an email whenever a build fails and if a build on a branch passes when the previous one failed. Therefore, whenever a branch is back to OK you will be notified.

### Disable Email
If you don't want to receive any emails you can set that on your [account page](https://www.codeship.com/user/edit).

### Receive emails when I am involved
In your project's notification settings you can set the option that you only receive an email when the build was on the master branch or if you started this build.

## Shipscope - Chrome Extension
Monitor your Codeship projects and builds with [Shipscope](https://chrome.google.com/webstore/detail/shipscope/jdedmgopefelimgjceagffkeeiknclhh). Shipscope lists all of your Codeship projects and presents the status of recent builds in the Chrome toolbar. You can restart a build or go straight to the build details on the Codeship service.

The Shipscope notifications presented by Chrome will end up in the Notification Center. If you would like to prevent Shipscope notifications in the Notification Center, simply:

1. Click the bell icon in the lower right corner of your computer screen (on Windows) or the upper right of your computer screen (on Mac) to open the Notifications Center.
1. In the Notifications Center, click the gear icon  on the bottom right corner (on Windows) or the upper right corner (on Mac).
1. Uncheck the box next to "Shipscope".

Shipscope is open source and lives on [GitHub](https://github.com/codeship/shipscope).

## 3rd party chat notifications
You will get notifications whenever a build starts and finishes. All information about the result and a link to it will be in the message.

We have support for the following chat notification systems. Currently you can't customize the messages sent by Codeship.

* Hipchat
* Slack
* Flowdock
* Grove.io
* Campfire
