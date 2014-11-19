---
title: My builds are not triggered anymore
layout: page
tags:
  - faq
  - build error
  - github
  - bitbucket
categories:
  - faq
---
In general a build is triggered on Codeship on each push to your remote repository. Hence there needs to be a hook set up at your repository provider (GitHub, Bitbucket).

## Hook URL

You can find your project UUID in the project settings on the ***General*** page.

### GitHub

```
https://lighthouse.codeship.io/github/YOUR_PROJECT_UUID
```

### BitBucket

```
https://lighthouse.codeship.io/bitbucket/YOUR_PROJECT_UUID
```


## Issues with the hook in your repository

* Please check if the Codeship hook is configured and active for your repository on GitHub / Bitbucket.
* Check if the project UUID is the same as on Codeship. You will find your project UUID on Codeship in your project settings on the ***General*** page.

## Issues with Codeship

It also might be possible that there are issues on Codeship. Please check our [Codeship Status Page](http://status.codeship.com){:target="_blank"} for further information.
