---
title: Integrating Codeship With Appranix for Direct Deployments
shortTitle: Using Appranix For Application Management
tags:
  - integrations
  - operations
  - management
menus:
  general/integrations:
    title: Using Appranix
    weight: 16
---

## About Appranix

[Appranix](http://www.appranix.com/) ServiceFormation’s continually learning adaptive system optimizes your cloud resources from your applications perspective. Knowing how applications are designed and deployed, Appranix creates and manages only what’s required on hyperscale cloud platforms. Unlike other fragmented operations tools that automate applications and data separately, Appranix unifies them with ServiceFormation to deliver Cloud Ops and DevOps in one platform.

With Appranix integration in Codeship the devloper doesn't have to worry about integrating the latest build to an existing backend whenever new code is pushed.

Once the code is pushed Codeship builds it and Appranix integrates the latest build in the AppSpace and brings it to production without any manual hassle. With Appranix integration the code flow is as simple as from your editor to production.

Appranix can be integrated with [Codeship Basic](https://codeship.com/features/basic) and [Codeship Pro](https://codeship.com/features/pro). This article will not cover on how to set up the AppSpace, documentation on that can be found at [Appranix's User Docs](https://app.appranix.net/docs/).

![Appranix Operations](https://github.com/RushinthJohn/documentation/blob/appranix/images/integrations/appranix-ops.jpg)

## Manual Integration

Integrating Appranix with Codeship is as simple as including the  [appranix.sh](https://github.com/RushinthJohn/documentation/blob/appranix/_data/appranix.sh) script file in your project repository.

## Prerequisites

To start, you need to add the following values in the environment page of your Codeship project, for more info read [Environment Variables](https://documentation.codeship.com/basic/builds-and-configuration/set-environment-variables/)

- `USER` - Username of your Appranix account
- `PASSWORD` - Password of your Appranix account
- `ORG` - Organization in your Appranix account
- `SUBORG` - Sub Oraginization in your account where assembly is located
- `ASSEMBLY` - Name of the assembly where the AppSpace is located
- `PLATFORM` - Name of the platform where the artifact component is located
- `ARTIFACT` - Specific name of the artifact component which should will deploy the latest build
- `AppSpace` - Name of the AppSpace where the artifact component is located

## Appranix Setup
In your Appranix AppSpace where the latest build is to be integrated, the `appVersion` variable must be created in that platform and included in Version field of artifact component within that same platfrom.

When a new build is completed the build number is stored in the `CI_BUILD_NUMBER` environment variable, this build number is then updated in Appranix within the `appVersion` variable and the artifact component pulls the artifat with that build number.

## Configuring Deployments

In the deployment section of your [Codeship](https://codeship.com/) project configure all your settings to deploy the artifact to your artifactory repository.

After that add `sh appranix.sh` at the end. The script file will connect to Appranix and trigger deployment for the new build. For eg,
```bash
#Deployment to artifactory repository
mvn package
mvn deploy

#Appranix deployment
sh appranix.sh
```

## Application Operations

After successfull deployment all operations management can be easily done from the Appranix dashboard. Operations like scaling up, scaling down, instance replace, health monitoring, instance termination can be performed with the click of a button.
