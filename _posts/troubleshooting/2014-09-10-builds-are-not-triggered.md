---
title: My builds are not triggered anymore
layout: page
weight: 23
tags:
  - troubleshooting
  - build error
  - github
  - bitbucket
categories:
  - troubleshooting
---

Builds on Codeship are triggered via a webhook from GitHub or BitBucket. We add this hook to your repository when you configure the project on Codeship, but sometimes those settings get out of sync.

That's why we show the status of the webhook configuration on the _General_ page of your project settings.

![Hook Status and Project UUID]({{ site.baseurl }}/images/faq/hook_status_and_project_uuid.png)

## GitHub

Make sure the _Codeship_ service is added under the _Webhooks & Services_ section of your repository settings. Also check that the UUID configured for the repository matches the one shown on the _General_ page of your project settings on Codeship.

![GitHub Service Configuration]({{ site.baseurl }}/images/faq/service_github.png)

## BitBucket

<div class="info-block" style="margin-top: 1em;">
BitBucket recently released a new implementation for their webhooks, which we are currently evaluating and will switch to in the future!
</div>

Make sure a webhook for Codeship is added under the _Services_ section of your repository. Please also check the the UUID in the hook URL matches the UUID from your project. The hook URL itself should match the following pattern.

```
https://lighthouse.codeship.io/bitbucket/YOUR_PROJECT_UUID
```

![BitBucket Service Configuration]({{ site.baseurl }}/images/faq/webhook_bitbucket.png)

## Issues with Codeship

It also might be possible that there are issues on Codeship. Please check our [Codeship Status Page](http://codeshipstatus.com){:target="_blank"} or follow us on [@Codeship](https://twitter.com/codeship) for further information.
