---
title: Getting Started With Projects
menus:
  general/projects:
    title: Creating New Projects
    weight: 1
tags:
  - administration
  - project
  - getting started
  - account
  - projects
  - firewall

redirect_from:
  - /administration/delete-a-project/
  - /general/projects/delete-a-project/
  - /faq/testing-prs-from-forked-repositories/
  - /faq/limit_builds/
  - /administration/transfer-project-to-new-owner/
  - /general/projects/testing-prs-from-forked-repositories/
  - /general/projects/limit_builds/
  - /general/projects/transfer-project-to-new-owner/
  - /general/projects/enabling-access-to-servers/
  - /general/projects/cant-find-file-in-repository/
  - /troubleshooting/no-such-file-or-directory-config-yourconfigyml/
  - /faq/no-such-file-or-directory-config-yourconfigyml/
---

* include a table of contents
{:toc}

This article will teach you how to create and delete a project as well as give some further information on specific questions.

## Create a Project
The screenshot below shows the initial [dashboard](https://app.codeship.com/projects) after logging in to Codeship for the first time.
![new project screen]({{ site.baseurl }}/images/general/1welcome.png)

In the next step, you can choose whether you want to import from a GitHub, GitLab, or Bitbucket repository by providing the repository link as shown in the examples.

![connecting to repository examples]({{ site.baseurl }}/images/general/2importrep.png)

After connecting to a repository, you will either continue with [Codeship Basic]({{ site.baseurl }}{% link basic/index.md %}) or be able to choose between Codeship Basic and [Codeship Pro]({{ site.baseurl }}{% link pro/index.md %}) if the latter is activated on your account.

## Requirements For Creating A New Project

To get started with a Codeship project, you will want to have a few resources available:

- A Github, Bitbucket or Gitlab account with admin permissions for a repo or organization

- A Codeship account, either using your email or using source control authentication

- A code base with either setup or test commands (or both) that you need to automate

## Delete a Project
You need to have project ownership for deleting a project. Once you click the delete button, you will have to confirm the deletion once more. A project can be deleted by going to:

***Project Settings > General > Delete project***
![Delete a Project]({{ site.baseurl }}/images/general/deleteproject.png)

All your builds will be deleted as well. Make sure that you really don't need this project anymore. It cannot be recovered once deleted.

## Transfer Project Ownership
You can transfer your project to another account by navigating to:

***Project Settings > General***

A user with appropriate permission for the target account needs to confirm the transfer if you do not have project creation rights in the target account. When confirming the transfer, the user can choose which of the current team members to keep and which to remove.

If you want to **bulk transfer projects**, please reach out to our support via [helpdesk.codeship.com](https://helpdesk.codeship.com).

<div class="info-block">
**Use Case Examples**
* You are using the Heroku addon and want to start using Codeship without it.
* You don't want to maintain a project anymore and want to transfer it to someone else.
</div>

## Limit Builds to Specific Branches
We don’t have a feature to limit which branches can be built.

We **build your project on every push** (that is, we run your setup and test commands) to let you know as soon as possible if something is broken. We will only ever run a deployment for the specific branch it is configured on and only after all setup and test commands executed successfully. Before deployment, every push to your repository should be tested.

If you wish to skip a build, please refer to the article about [skipping builds]({{ site.baseurl }}{% link _general/projects/skipping-builds.md %}).

## Testing PRs from Forked Repositories

Codeship **does not support testing pull requests from forked repositories** at the moment. You'd need to configure the forked repository separately on Codeship or push the branch to the already configured repository instead.

## Keyboard Shortcuts

To make it easier to navigate through your Codeship projects, we've provided several keyboard shortcuts for quickly jumping through the interface:

- `gp`, available from inside your projects, will return you to your projects overview page
- Escape key, available on your projects overview page, will return you to the previous page
- Arrow keys, available on your projects overview page, will navigate between your projects
- Enter key, available on your projects overview page, will select the highlighted project

## Invite Team Members To Your Projects

Once you've created your project, you can invite colleagues members to give them access.

Under ***Project Settings > Team members***, simply add their email address to send them an invite.

![Invite team members to project]({{ site.baseurl }}/images/general/invite-team-member.png)

## Whitelisting Codeship On Your Firewall

Codeship is hosted on AWS EC2 in the us-east-1 region. Because of this, Codeship services do not have static IP addresses. There are several different options for allowing Codeship to pass through your firewall.

AWS publishes current [IP address ranges](http://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html) in [JSON format](https://ip-ranges.amazonaws.com/ip-ranges.json). You can enable access for those ranges on your own server's firewall settings.

Another option, while not fully supported, is to set up and run your own [bastion host](https://en.wikipedia.org/wiki/Bastion_host). This would allow you to route all Codeship calls through your bastion host and white list only this host.

We realize these options may not work for all configurations. If there is something specific you would like to see, please [get in touch](mailto:support@codeship.com) and let us know more details about your environment.

## Can't Locate A File

If your build can't locate a configuration file which you ignored in your repository, via `.gitignore`, create a `your_config.yml.example` with data that works for your tests an add it to your repository. Then add the following command to your **setup commands** so the YAML file is properly set up.

```shell
# project settings > test settings > setup commands
cp your_config.yml.example your_config.yml
```

You should also check that you are not coming from a case-insensitive operating system where you may not have noticed that the file name is different, i.e. `File.yml` compared to `file.yml`.
