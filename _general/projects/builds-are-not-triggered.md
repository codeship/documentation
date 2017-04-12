---
title: My builds are not triggered anymore
layout: page
tags:
  - troubleshooting
  - build error
  - github
  - bitbucket
  - gitlab

redirect_from:
  - /troubleshooting/builds-are-not-triggered/
  - /faq/builds-are-not-triggered/
---

Builds on Codeship are triggered via a webhook from your VCS. We add this hook to your repository when you configure the project on Codeship, but sometimes those settings get out of sync.

That's why we show the status of the webhook configuration on the _General_ page of your project settings.

![Hook Status and Project UUID]({{ site.baseurl }}/images/faq/hook_status_and_project_uuid.png)

## GitHub

Make sure the _Codeship_ service is added under the _Webhooks & Services_ section of your repository settings. Also check that the UUID configured for the repository matches the one shown on the _General_ page of your project settings on Codeship.

![GitHub Service Configuration]({{ site.baseurl }}/images/faq/service_github.png)

## Bitbucket

Make sure a webhook for Codeship is added under the _Webhooks_ section in the settings of your repository. Please also check the the UUID in the hook URL matches the UUID from your project. The hook URL itself should match the following pattern.

```
https://lighthouse.codeship.io/bitbucket/YOUR_PROJECT_UUID
```

![BitBucket Webhooks Configuration]({{ site.baseurl }}/images/general/bitbucket_webhooks.jpg)

## Issues with Codeship

It also might be possible that there are issues on Codeship. Please check our [Codeship Status Page](http://codeshipstatus.com){:target="_blank"} or follow us on [@Codeship](https://twitter.com/codeship) for further information.
