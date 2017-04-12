---
title: Getting Started With Projects
layout: page
tags:
  - administration
  - project

redirect_from:
  - /administration/delete-a-project/
  - /general/projects/delete-a-project/
  - /faq/testing-prs-from-forked-repositories/
  - /faq/limit_builds/
  - /administration/transfer-project-to-new-owner/
  - /general/projects/testing-prs-from-forked-repositories/
  - /general/projects/limit_builds/
  - /general/projects/transfer-project-to-new-owner/
---
This article will teach you how to create and delete a project as well as give some further information on specific questions.

* include a table of contents
{:toc}

## Create a Project
The screenshot below shows the initial [dashboard](https://app.codeship.com/projects) after logging in to Codeship for the first time.
![new project screen]({{ site.baseurl }}/images/general/1welcome.png)

In the next step, you can choose whether you want to import from a GitHub, GitLab, or Bitbucket repository by providing the repository link as shown in the examples.
![connecting to repository examples]({{ site.baseurl }}/images/general/2importrep.png)

After connecting to a repository, you will either continue with [Codeship Basic]({{ site.baseurl }}{% link basic/index.md %}) or be able to choose between Codeship Basic and [Codeship Pro]({{ site.baseurl }}{% link pro/index.md %}) if the latter is activated on your account.

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

If you wish to skip a build, please refer to the article about skipping builds for [Codeship Basic]({{ site.baseurl }}{% link _basic/getting-started/skipping-builds.md %}) and [Codeship Pro]({{ site.baseurl }}{% link _pro/getting-started/skipping-builds.md %}).

## Testing PRs from Forked Repositories
Codeship **does not support testing pull requests from forked repositories** at the moment. You'd need to configure the forked repository separately on Codeship or push the branch to the already configured repository instead.
