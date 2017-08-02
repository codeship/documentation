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
    weight: 10
---

* include a table of contents
{:toc}

## About Appranix

[Appranix ServiceFormation’s](http://www.appranix.com/) continually learning adaptive system optimizes your cloud resources from your applications perspective. Knowing how applications are designed and deployed, Appranix creates and manages only what’s required on hyperscale cloud platforms. Unlike other fragmented operations tools that automate applications and data separately, Appranix unifies them with ServiceFormation to deliver Cloud Ops and DevOps in one platform. Appranix User Documentation does a great job of providing more information, in addition to the setup instructions below.

## Using Appranix

This article will cover on how to setup and deploy the latest builds to your existing Appranix AppSpace through artifact component with [Codeship Basic](https://codeship.com/features/basic). This article will not cover on how to set up the AppSpace, documentation on that can be found at [Appranix's User Docs]{https://app.appranix.net/docs/}.

## Configuring Deployments

In the deployment section of your [Codeship](https://codeship.com/) project configure all your settings to deploy the artifact to your artifactory repository.
After that include code to execute the appranix.sh script.
The script file will connect to Appranix and trigger deployment for the new build.

## Adding Appranix Values

To start, you need to add the following values in environment variables `USER`, `PASSWORD`, `ORG`, `ASSEMBLY`, `AppSpace`, `PLATFORM`, `ARTIFACT`.

## Deploying With Appranix

During the next code push after all pipleine tests are complete at the deployment stage the artifact will be deployed to your artifactory repository as per your configuration after which the appranix.sh script file will be executed. The script file will start a new deployment for the latest build.

## Application Operations
