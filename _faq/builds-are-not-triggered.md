---
title: My builds are not triggered anymore
layout: page
tags:
  - faq
  - build error
  - github
  - bitbucket
---
In general a build is triggered on Codeship on each push to your remote repository. Hence there needs to be a hook set up at your repository provider (GitHub, Bitbucket).

## Issues with the hook in your repository
+ Please check if the Codeship hook is configured and active for your repository on GitHub / Bitbucket.
+ Check if the project UUID is the same as on Codeship. You will find your project UUID on Codeship in your project settings on the ***General*** page.

## Issues with Codeship
It also might be possible that there are issues on Codeship. Please check our [Codeship Status Page](http://status.codeship.io){:target="_blank"} for further information.
