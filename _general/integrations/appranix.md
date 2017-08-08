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

[Appranix](http://www.appranix.com/) simplifies and automates the entire application operations (Site Reliability Engineering) on cloud platforms using its app-centric, real-time, cognitive automation technology called ServiceFormation. Refer to the full set of Appranix platform capabilities at [www.appranix.com/product/platform.html](http://www.appranix.com/product/platform.html).

Similar to Codeship, ServiceFormation is a SaaS platform that is readily accessible and implemented for any distributed application bound to run on any private or public cloud platforms.

With Appranix [Codeship](https://codeship.com/) integration, Codeship developer doesn’t have to worry about pushing the code to operations. Application operations teams (SREs) can confidently deploy, run and operate the code in production to achieve the Service Level Objectives.

Appranix can be integrated with [Codeship Basic](https://codeship.com/features/basic) and [Codeship Pro](https://codeship.com/features/pro). This article will not cover on how to set up the AppSpace, documentation on that can be found at [Appranix's User Docs](https://app.appranix.net/docs/).

This article explains how development and operations teams can quickly extend their Codeship CI pipelines beyond their typical Continuous Deployments (CD) to App Operations.

![Appranix Operations]({{ site.baseurl }}/images/continuous-integration/appranix-ops.jpg){:class="app-img"}

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

![Appranix Variable]({{ site.baseurl }}/images/continuous-integration/appranix-variable.jpg){:class="app-img"}

2. Add the `appVersion` variable in `Version` field of the artifact component.

![Appranix Artifact]({{ site.baseurl }}/images/continuous-integration/appranix-artifact.jpg){:class="app-img"}

When a new build is completed the build number is stored in the `CI_BUILD_NUMBER` environment variable, this build number is then updated in Appranix within the `appVersion` variable and the artifact component pulls the artifat with that build number.

### Configuring Deployments

In `codeship-steps.yml` file, after the step where the artifact is deployed to your artifactory server add another step at the end to execute the `appranix.sh` file. For eg,
```yaml
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

![Appranix Kubernetes]({{ site.baseurl }}/images/continuous-integration/appranix-k8.png){:class="app-img"}

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
![Appranix Variable]({{ site.baseurl }}/images/continuous-integration/appranix-variable.jpg){:class="app-img"}

2. Add the `appVersion` variable in `Version` field of the artifact component.
![Appranix Artifact]({{ site.baseurl }}/images/continuous-integration/appranix-artifact.jpg){:class="app-img"}

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

## Need More Help?

Get in touch if you need more help at <a href="mailto:info@appranix.com?Subject=Reg-Codeship%20Integration" target="_blank" >info@appranix.com</a>
