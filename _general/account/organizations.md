---
title: Organization Accounts
layout: page
tags:
  - administration
  - project
  - organizations
  - team management

redirect_from:
  - /administration/organizations/
---

Organizations simplify and enhance team management as well as subscription management for (larger) teams on Codeship.

You can define arbitrary teams and add them to any organization project and add Codeship accounts to those teams. You can also provide read-only access to some of your team members.

* include a table of contents
{:toc}

We currently offer the following roles (though more roles are already on our todo list):

* **Owners** have control over all aspects of an organization. From changing the subscription to managing organization projects and teams.
* **Managers** have control over team and project management of an organization. They can add and remove projects and manage the organization teams by adding new team members or assigning projects to teams. They have access to all projects and are able to change the project configuration.
* **Project Managers** can manage projects the team is assigned to. They can debug builds, update test settings, or manage deployments.
* **Contributors** have read-only access to their projects. This means that they can view the project dashboard and build details but are not allowed to change project settings or open debug builds.

## Creating an Organization

* Click on your name in the navigation bar at the top and click the green _Create Organization_ button.
* Choose an available name and you're done!

![Creating an Organization]({{ site.baseurl }}/images/administration/create_organization.png)

## Managing Teams

On the _Teams_ tab of the organization settings, you can manage your different teams, add new teams and add or remove team members from the available teams.

Two teams are created for each organization by default:
* _Owners_, containing only the user who created the organization by default. You can however add any other Codeship account to the _Owners_ team as well.
* _Managers_, containing nobody by default.

If you want to create a new team, click the _Create new team_ button and select the appropriate role.

![Creating a Team]({{ site.baseurl }}/images/administration/create_team.png)

Once you have created a new team, you can add new team members via their email address as well as any existing projects.

If you need to change the team settings (e.g., the name or the role), hover over the team card and click the gear icon showing on the right hand side.

## Adding Projects

You can either add a project via the _Select project_ dropdown at the top, or via the _Create a new project_ button in the organization's project settings. Please make sure the correct account (either organization or your private account) is selected first, as it's currently not possible to transfer projects to another account.

Once the project is created, you can add it to any of your teams. Members of the _Owners_ and _Managers_ team will have access to all projects by default.

![Adding a project to a team]({{ site.baseurl }}/images/administration/add_project_to_team.png)

## Transfer A Project To An Organization

You can transfer your project to another account by navigating to:

***Project Settings > General***

A user with appropriate permission for the target account needs to confirm the transfer if you do not have project creation rights in the target account. When confirming the transfer, the user can choose which of the current team members to keep and which to remove.

If you want to **bulk transfer projects**, please reach out to our support via [helpdesk.codeship.com](https://helpdesk.codeship.com).

![Importing a personal project to an organization]({{ site.baseurl }}/images/administration/import_projects.png)

## Removing A User From All Teams And Projects

To remove a team member from all organization teams and projects, click into your team management page. At the top, you will see a link for "Show all Members".

From the "Show all Members" screen, changes to a any team member will apply to all teams and projects, organization-wide.

![Importing a personal project to an organization]({{ site.baseurl }}/images/administration/remove_all.png)

## Accessing Invoices

For all users assigned the **owner** role in an organization, you can access invoices by clicking on your name in the top right and selecting an organization from the drop-down. Then, on the sidebar underneath the organization name, you will see a tab for "Invoices".

![View invoices]({{ site.baseurl }}/images/general/download-invoice.png)
