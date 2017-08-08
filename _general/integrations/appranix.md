---
title: Integrating Codeship With Appranix
shortTitle: Integrating Codeship With Appranix
tags:
  - integrations
  - operations
  - management
  - DevOps
menus:
  general/integrations:
    title: Using Appranix
    weight: 15
---

* include a table of contents
{:toc}

## About Appranix

[Appranix](http://www.appranix.com/) simplifies and automates the entire application operations on cloud platforms using its app-centric, real-time, cognitive automation technology called ServiceFormation.

With Appranix integration in [Codeship](https://codeship.com/) the devloper doesn't have to worry about integrating the latest build to an existing backend whenever new code is pushed.

Once the code is pushed Codeship builds it and Appranix integrates the latest build in the AppSpace and brings it to production without any manual hassle. With Appranix integration the code flow is as simple as from your editor to production.

Appranix can be integrated with [Codeship Basic](https://codeship.com/features/basic) and [Codeship Pro](https://codeship.com/features/pro). This article will not cover on how to set up the AppSpace, documentation on that can be found at [Appranix's User Docs](https://app.appranix.net/docs/).

![Appranix Operations]({{ site.baseurl }}/images/continuous-integration/appranix-ops.jpg {:height="36px" width="36px"})
<img src="http://ec2-52-201-255-209.compute-1.amazonaws.com:4000/images/continuous-integration/appranix-variable.jpg" alt="img">

## Codeship Pro

### Manual Integration

Integrating Appranix with Codeship is as simple as including the  [appranix.sh](https://github.com/RushinthJohn/documentation/blob/appranix/_data/appranix.sh) script file in your project repository.

### Prerequisites

After adding `appranix.sh` to your project repository along with `codeship-services.yml` and `codeship-steps.yml` files add the following environment variables to your `codeship-services.yml` file. You can also encrypt the environment variables, for more info read [Environment Variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}).

- `USER` - Username of your Appranix account
- `PASSWORD` - Password of your Appranix account
- `ORG` - Organization in your Appranix account
- `SUBORG` - Sub Oraginization in your account where assembly is located
- `ASSEMBLY` - Name of the assembly where the AppSpace is located
- `PLATFORM` - Name of the platform where the artifact component is located
- `ARTIFACT` - Specific name of the artifact component which should will deploy the latest build
- `AppSpace` - Name of the AppSpace where the artifact component is located

### Appranix Setup
In your Appranix AppSpace where the latest build is to be integrated, the `appVersion` variable must be created in that platform and must be included in Version field of artifact component within that same platfrom.

1. Add the `appVersion` variable in your Appranix platform.
![Appranix Variable]({{ site.baseurl }}/images/continuous-integration/appranix-variable.jpg)

2. Add the `appVersion` variable in `Version` field of the artifact component.
![Appranix Artifact]({{ site.baseurl }}/images/continuous-integration/appranix-artifact.jpg)

When a new build is completed the build number is stored in the `CI_BUILD_NUMBER` environment variable, this build number is then updated in Appranix within the `appVersion` variable and the artifact component pulls the artifat with that build number.

### Configuring Deployments

In `codeship-steps.yml` file, after the step where the artifact is deployed to your artifactory server add another step in the end to execute the `appranix.sh` file. For eg,
```bash
- name: artifact deployment
  tag: master
  service: app
  command: mvn package
  command: mvn deploy
- name: Appranix deployment
  tag: master
  service: app
  command: sh appranix.sh
```
<div class="info-block">
Note:
The container must have Ruby version 2.3.3 or higher for the `appranix.sh` file to execute the required gem install.
</div>

### Appranix's Kubernetes-as-a-service

Appranix can run and operate Codeship built docker images on [Kubernetes](https://kubernetes.io/) container orchestration system. Appranix manages the entire Kubernetes system including deployment, cloud infrastructure provisioning, configuration management, monitoring, self-healing of the Master nodes or kube nodes.

![Appranix Kubernetes]({{ site.baseurl }}/images/continuous-integration/appranix-k8.png)

## Codeship Basic

### Manual Integration

Include the  [appranix.sh](https://github.com/RushinthJohn/documentation/blob/appranix/_data/appranix.sh) script file in your project repository.

### Prerequisites

After adding `appranix.sh` to your project repository add the following values in the Environment page of your Codeship Project Settings, for more info read [Environment Variables]({{ site.baseurl }}{% link _basic/builds-and-configuration/set-environment-variables.md %})

- `USER` - Username of your Appranix account
- `PASSWORD` - Password of your Appranix account
- `ORG` - Organization in your Appranix account
- `SUBORG` - Sub Oraginization in your account where assembly is located
- `ASSEMBLY` - Name of the assembly where the AppSpace is located
- `PLATFORM` - Name of the platform where the artifact component is located
- `ARTIFACT` - Specific name of the artifact component which should will deploy the latest build
- `AppSpace` - Name of the AppSpace where the artifact component is located

### Appranix Setup

1. Add the `appVersion` variable in your Appranix platform.
![Appranix Variable]({{ site.baseurl }}/images/continuous-integration/appranix-variable.jpg)

2. Add the `appVersion` variable in `Version` field of the artifact component.
![Appranix Artifact]({{ site.baseurl }}/images/continuous-integration/appranix-artifact.jpg)

### Configuring Deployments

In the Deploy section of your [Codeship](https://codeship.com/) Project Settings configure all your settings to deploy the artifact to your artifactory repository.

After that add `sh appranix.sh` at the end. The script file will connect to Appranix and trigger deployment for the new build. For eg,
```bash
#Deployment to artifactory repository
mvn package
mvn deploy

#Appranix deployment
sh appranix.sh
```
<div class="info-block">
Note:
Make sure you have selected Ruby version 2.3.3 or higher. It can be done by adding `rvm use 2.3.3` to Deploy Configuration of your Codeship Project Settings.
</div>
## Integration Video

Here is a simple video on how the Appranix integration with Codeship Basic works.
<body>
 <iframe src="http://www.youtube.com/embed/3KE7EyTEHqg"
  width="896" height="504" frameborder="0" allowfullscreen></iframe>
</body>

## Appranix Operations

A recent DevOps [survey](http://www.prnewswire.com/news-releases/qualis-survey-offers-insights-about-it-challenges-in-cloud-and-devops-300423438.html) found the following results:
- 54% of respondents indicated they had no access to self-service infrastructure which means they had to wait for a long time for someone to provision their resources.
- Over 59% of respondents said it takes up to a month or more to deliver infrastructure, this slows application delivery.
- Many repondents feel that some applications are very complex for cloud.

Appranix solves the above problems with it's ServiceFormation technology, LiveDeploy feature allows you to frequently deploy your application, platform or database changes to running applications from your CI/CD systems, continuously monitor and update infrastructure changes made in your cloud accounts with LiveDiscovery, scale your application components be it applications, platforms, sharded databases easily based on your policies using LiveScale.

## Need More Help?

Get in touch if you need more help at <a href="mailto:info@appranix.com?Subject=Reg-Codeship%20Integration" target="_blank" >info@appranix.com</a>
