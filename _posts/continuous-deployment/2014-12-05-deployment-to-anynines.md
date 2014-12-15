---
title: Deploy to anynines
tags:
- deployment
- anynines
categories:
- continuous-deployment
---

[anynines](http://www.anynines.com) is a PaaS built on top of CloudFoundry and OpenStack.

They have a great [Getting Started](https://support.anynines.com/entries/60238466-Getting-started-with-anynines-using-the-CLI-v6) guide which we definitely encourage you to check out. Also, see their documentation available at [support.anynines.com](https://support.anynines.com/forums).

As for getting started with **anynines** on Codeship, start by getting your application to deploy from your local machine. Once this is done, you need to add the following environment variables to your project settings.

```
CF_USER
CF_PASSWORD
CF_ORG
CF_SPACE
CF_APPLICATION
```

Then create a new **script based** deployment and paste the following commands.

```shell
cf6 api https://api.de.a9s.eu
cf6 auth "${CF_USER}" "${CF_PASSWORD}"
cf6 target -o "${CF_ORG}" -s "${CF_SPACE}"
cf6 push "${CF_APPLICATION}"
```

This will deploy your application on each push to the specific branch you configured the deployment for.

If you have more thorough requirements, like _blue / green deployments_ see a great article written by the folks at _anynines_ about deploying to Codeship, which is  [available at their blog](http://blog.anynines.com/setup-continuous-deployment-anynines-codeship-com/).
