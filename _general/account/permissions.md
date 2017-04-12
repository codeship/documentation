---
title: "Permissions And Security Management"
layout: page
weight: 27
tags:
  - security
  - permissions
  - github
  - gitlab
  - bitbucket
  - organizations


---

* include a table of contents
{:toc}

## How Permissions Work On Codeship

Let's take a look at how Codeship manages permissions around your source control, your builds and your team.

### What do we mean by permissions?

When we say permissions, we are  talking about access you give Codeship to your source control repo, or access you give to people on your team to your Codeship builds and account information.

### What permissions are needed on my source control?

Codeship requires different permission levels depending on the source control service being used:

- **Github**: We require admin permissions so that we can clone the repos and report back status.

- **Bitbucket**: We require master or owner permissions so that we can clone the repos and report back status.

- **Gitlab**: We require admin permissions so that we can clone the repos and report back status.

### What permissions can I assign my team members?

You can learn more about organization management on Codeship [by clicking here]({% link _general/account/organizations.md %}), but in general there are four basic security levels for teams on Codeship:

- **Owners** have control over all aspects of an organization. From changing the subscription to managing organization projects and teams.

- **Managers** have control over team and project management of an organization. They can add and remove projects and manage the organization teams by adding new team members or assigning projects to teams. They have access to all projects and are able to change the project configuration.

- **Project Managers** can manage projects the team is assigned to. They can debug builds, update test settings, or manage deployments.

- **Contributors** have read-only access to their projects. This means that they can view the project dashboard and build details but are not allowed to change project settings or open debug builds.

### Can Codeship staff see my code or builds?

You can learn more about security on Codeship [by clicking here]({% link _general/about/security.md %}), but there are two Codeship services and staff have different levels of access for each:

- On [Codeship Basic](https://codeship.com/features/basic), with permission our support team can open an SSH debug session in to your build machine which allows us to see your source code.

- On [Codeship Pro](https://codeship.com/features/pro), we have no direct access to your source control but our support team can see your builds and build logs, as well as account information.
