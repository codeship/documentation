---
title: Deploy to Ninefold
tags:
  - deployment
  - ninefold
categories:
  - continuous-deployment
---
Deploying to [Ninefold](https://ninefold.com/) from Codeship is as simple as copying and pasting an URL!

Head over to the Ninefold Portal and your existing apps _Overview_ tab. Grab the _Deployment URL_ from there and switch back to Codeship.

To trigger a deployment, add a **Script**  deployment to your project and add the following command:

```bash
curl -X POST -d "" YOUR_NINEFOLD_DEPLOYMENT_URL
```
