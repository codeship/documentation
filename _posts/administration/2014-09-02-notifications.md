---
title: Notification Setup
layout: page
tags:
  - administration
  - notifications
categories:
  - administration
---
## <a name="configure-notifications"></a>Where can I configure Notifications
Click the project menu on the top navigation and click the settings wheel to get to your project settings. There click the **Notifications** link.

## <a name="github"></a>GitHub Status API
We will use the GitHub Oauth Token we got when you connected Codeship to your GitHub account to set the build status for every commit on GitHub. Take a look at the [blog post by GitHub](https://github.com/blog/1227-commit-status-api) that explains their status API.

## <a name="email"></a>Email notification
By default anyone who either owns a project or was added as a team member will receive an email whenever a build fails and if a build on a branch passes when the one before failed. So whenever a branch is back to OK you will be notified.

### Disable Email
If you don't want to receive any emails you can set that on your [account page](https://www.codeship.io/user/edit).

###Receive emails when I am
In your projects notification settings you can set the option that you only receive an email when the build was on the master branch or if you started this build

## <a name="chat"></a>3rd party chat notifications
You will get notifications whenever a build starts and when it finishes. All information about the result and a link to it will be in the message.

We have support for the following chat notification systems. Currently you can't customize the messages sent by Codeship.

* Hipchat
* Slack
* Flowdock
* Grove.io
* Campfire
