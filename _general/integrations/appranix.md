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

This article will cover on how to setup and deploy the latest builds to your existing Appranix AppSpace through artifact component with [Codeship Basic](https://codeship.com/features/basic). This article will not cover on how to set up the AppSpace, documentation on that can be found at [Appranix's User Docs](https://app.appranix.net/docs/).

## Using Appranix

With Appranix the devloper doesn't have to worry about integrating the latest build to an existing backend.
Once you push the code Appranix takes care of integrating it with your AppSpace and have it in production without any extra effort. With Appranix integration the code flow is as simple as from your editor to production.

![Appranix DevOps Flow](https://github.com/RushinthJohn/documentation/blob/appranix/images/integrations/appranix-code-flow.jpg)

##Appranix Setup
In your Appranix account to get your artifact from the artifact repository you will be using the artifact component to download it. Add a variable `appVersion` which will hold the build number and configure your artifact accordingly to use the variable for downloading that specific build.
Include the [appranix.sh](https://github.com/RushinthJohn/documentation/blob/appranix/_data/appranix.sh) script file in your project repository.

## Adding Appranix Values

To start, you need to add the following values in the environment page of your Codeship project, for more info read [Environment Variables](https://documentation.codeship.com/basic/builds-and-configuration/set-environment-variables/)

- `USER` - Username of your Appranix account
- `PASSWORD` - Password of your Appranix account
- `ORG` - Organization in your Appranix account
- `SUBORG` - Sub Oraginization in your account where assembly is located
- `ASSEMBLY` - Name of the assembly where the AppSpace is located
- `PLATFORM` - Name of the platform where the artifact component is located
- `ARTIFACT` - Specific name of the artifact component which should will deploy the latest build
- `AppSpace` - Name of the AppSpace where the artifact component is located

## Configuring Deployments

In the deployment section of your [Codeship](https://codeship.com/) project configure all your settings to deploy the artifact to your artifactory repository.
After that add `sh appranix.sh` at the end. The script file will connect to Appranix and trigger deployment for the new build.

## Application Operations

After successfull deployment all operations management can be easily done from the Appranix dashboard. Operations like scaling up, scaling down, instance replace, health monitoring, instance termination can be performed with the click of a button.

![Appranix Operations](https://github.com/RushinthJohn/documentation/blob/appranix/images/integrations/appranix-ops.jpg)
