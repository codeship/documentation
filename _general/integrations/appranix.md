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

This article will cover on how to setup and deploy the latest builds to your existing Appranix AppSpace through artifact component. The article will not cover on how to set up the AppSpace

## Configuring Deployments

Configure the build deployment to your artifactory repository as per your requirements.
The next stage of deployment process triggers a new deployment in the Appranix AppSpace to load the new artifact by executing a script file which should be executed.

## Adding Appranix Values

To start, you need to add the following values in environment variables `USER`, `PASSWORD`, `ORG`, `ASSEMBLY`, `AppSpace`, `PLATFORM`, `ARTIFACT`.

## Deploying With Appranix

During the next build the artifact will be deployed to the artifactory repository after which Appranix process will be triggered with the latest build number which initiates a deployment with

## Application Operations
