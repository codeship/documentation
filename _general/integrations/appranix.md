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

This article will cover on how to setup and deploy the latest builds to your existing Appranix AppSpace through artifact component with ![Codeship Basic](https://codeship.com/features/basic). This article will not cover on how to set up the AppSpace, documentation on that can be found at [Appranix's User Docs]{https://app.appranix.net/docs/}.

## Using Appranix

With Appranix the devloper doesn't have to worry about integrating the latest build to an existing backend.
Once you push the code Appranix takes care of integrating it with your AppSpace and have it in production without any extra effort. With Appranix integration the code flow is as simple as from your editor to production.

![Appranix DevOps Flow](https://github.com/RushinthJohn/documentation/blob/appranix/images/integrations/appranix-code-flow.jpg)

## Configuring Deployments

In the deployment section of your ![Codeship](https://codeship.com/) project configure all your settings to deploy the artifact to your artifactory repository.
After that include code to execute the appranix.sh script.
The script file will connect to Appranix and trigger deployment for the new build.

## Adding Appranix Values

To start, you need to add the following values in the environment page of your Codeship project, for more info read ![Environment Variables](https://documentation.codeship.com/basic/builds-and-configuration/set-environment-variables/)

- `USER` - Username of your Appranix account
- `PASSWORD` - Password of your Appranix account
- `ORG` - Organization in your Appranix account
- `AppSpace` - Name of the AppSpace where the artifact component is located
- `PLATFORM` - Name of the platform where the artifact component is located
- `ARTIFACT` - Specific name of the artifact component which should will deploy the latest build

## Deploying With Appranix

During the next code push after all pipleine tests are complete at the deployment stage the artifact will be deployed to your artifactory repository as per your configuration after which the appranix.sh script file will be executed. The script file will start a new deployment for the latest build.
Add `sh appranix.sh` at the end of your deployment configuration in project settings.

## Application Operations
