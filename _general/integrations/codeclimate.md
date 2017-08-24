---
title: Integrating Codeship With Code Climate for Code Coverage Reports
shortTitle: Using Code Climate For Code Coverage
tags:
  - analytics
  - code-coverage
  - coverage
  - reports
  - reporting
  - continuous integration
  - integrations
menus:
  general/integrations:
    title: Using Code Climate
    weight: 1
redirect_from:
  - /basic/continuous-integration/code-climate/
  - /pro/continuous-integration/codeclimate-docker/
  -  /analytics/code-climate/
  - /classic/getting-started/code-climate/
  -  /basic/analytics/code-climate/  
---

<div class="info-block">
**Note** that these instructions use the newest version of the Code Climate reporter, which is still in beta. Please view [their documentation](https://docs.codeclimate.com/v1.0/docs/configuring-test-coverage-older-versions) for instructions on using the older reporter. You will still need to add your API token via [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}), as seen below, but the test configuration will work differently.
</div>

* include a table of contents
{:toc}

## About Code Climate

Code Climate is an automated code coverage service. Starting with Code Climate and Codeship is fast and easy. [Their documentation](http://docs.codeclimate.com/article/219-setting-up-test-coverage) does a great job of providing more information, as well as links to:

[setup with Codeship Basic](https://docs.codeclimate.com/docs/codeship-ci-test-coverage-example#section-codeship-basic)<br>
[setup for Codeship Pro](https://docs.codeclimate.com/docs/codeship-ci-test-coverage-example#section-codeship-pro)





