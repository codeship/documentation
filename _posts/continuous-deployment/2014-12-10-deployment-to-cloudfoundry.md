---
title: Deploy with Cloud Foundry
tags:
- deployment
- cloudfoundry
categories:
- continuous-deployment
---

As for getting started with **Cloud Foundry** on Codeship, start by getting your application to deploy from your local machine. Once this is done, you need to add the following environment variables to your project settings.

```shell
# CF_API Endpoints
# Pivotal Labs: https://api.run.pivotal.io
CF_API
CF_USER
CF_PASSWORD
CF_ORG
CF_SPACE
CF_APPLICATION
```

Then create a new **script based** deployment and paste the following commands.

```shell
cf6 api "${CF_API}"
cf6 auth "${CF_USER}" "${CF_PASSWORD}"
cf6 target -o "${CF_ORG}" -s "${CF_SPACE}"
cf6 push "${CF_APPLICATION}"
```

This will deploy your application on each push to the specific branch you configured the deployment for.
