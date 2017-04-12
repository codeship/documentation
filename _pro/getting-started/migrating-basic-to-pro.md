---
title: Migrating from Codeship Basic to Codeship Pro
layout: page
weight: 40
tags:
  - docker
  - jet
  - codeship pro
  - migration

---

* include a table of contents
{:toc}

## Create A New Pro Project

To create a new Codeship Pro project, just select the Pro infrastructure after connecting your source control.

![Selecting Codeship Pro]({{ site.baseurl }}/images/gettingstarted/setup_select_docker.png)

[You can learn more about creating a new project here.]({{ site.baseurl }}{% link _general/projects/getting-started.md %}).

## Switch A Basic Project To A Pro Project

To switch a project from Codeship Basic to Codeship Pro, just click on "Project Settings" in the top right. Then, under the "General" tab, you will see a "Switch project to Codeship Pro" button.

![Selecting Codeship Pro]({{ site.baseurl }}/images/general/enable-pro.png)

## Run Pro Builds On Basic Projects

On any Codeship Basic project, you can commit to the branch `codeship-docker-migration` to trigger a Codeship Pro build. Note that this is the only branch that will run Pro builds on Basic projects, and you will also need to click "View Docker based builds" above your project's builds to see the Pro build results.

![Selecting Codeship Pro]({{ site.baseurl }}/images/general/view-docker-builds.png)
