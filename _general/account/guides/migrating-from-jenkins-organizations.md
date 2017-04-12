---
title: Migrating From Jenkins To Codeship - Organizations
weight: 48
tags:
  - jenkins
  - organizations
  - migrating

---
There’s always someone who ends up with the responsibility of managing users and roles within an organization. This is a task that just needs done, and it has a sunk investment in setup and maintenance. However, it’s a vitally important task that needs to be finished and managed reliably each day.

With the Swiss Army knife that is Jenkins, that management and setup can actually be time-consuming and, in the worst case, need dedicated, specialized personnel.

This documentation will guide you through the migration of this functionality from Jenkins to Codeship and will encompass the features and options available. We’ve worked hard to make sure we provide a streamlined, more conventionally based, yet feature-rich workflow to help make the day-to-day work involved with user and role management quick, easy, and minimal!

## Setting Up Users, Roles, and Organizations on Jenkins

The default installation of Jenkins provides a built-in database option around the creation of users.

![Jenkins Team Screenshot]({{ site.baseurl }}/images/jenkins-guide/jenkins_team.png)

These users are then used to authenticate to and work with the server. They’re set up using the default “Allow users to sign up” settings shown in the above screenshot. There are also various plugins around single-sign-on integration with systems and other tools, and there are plugins around roles available too.

One thing to note (and one thing that’s quite cumbersome to migrate) is that each of these plugins is managed independently for the authorization, roles management, users, notifications, and related elements of Jenkins. Which means this will need to be meticulously combed through to determine what all is wired together from all the plugins. Which leads us to the Codeship solution.

## Setting Up Users, Roles, and Organizations on Codeship

First, let’s use the example of a general team working on a project. We’d have several contributors, a project manager, and probably a manager. With Codeship, it’s easy to get all of these individuals involved with notifications, accounts, and roles with a minimal amount of effort. Let’s say our team looks like this:

- Ron S : Manager
- Leslie K : Project Manager
- Andy D : Coder
- April L : Coder
- Ben W : Testing Automation
- Tom H : Coder
- Donna M : Coder

![Codeship Add An Organization]({{ site.baseurl }}/images/jenkins-guide/codeship_org_screenshot.png)

To migrate from Jenkins to Codeship ,however, Ron has asked us to use one of the options for setting up users and organizations, the key structural element for organizing users, within Codeship.

Once an organization is set up within Codeship, you can import existing projects, start new ones, create teams with roles, and add users to any of those specific assets. You can see many of those options below on the organization management screen.

![Codeship Organization Management]({{ site.baseurl }}/images/jenkins-guide/organization_management.png)

On this screen, you can see the teams page, which would be something like **https://app.codeship.com/orgs/<your-org-name>/teams**, where you can create a new team, set up owners, members, and set up projects assigned to a team.

One account can have multiple organizations, and organizations can then have multiple organization owners. This provides flexibility for however an organization wants to organize their projects.

![Codeship Organization Management]({{ site.baseurl }}/images/jenkins-guide/organization_management-two.png)

##Setting Up Roles in Codeship’s Organization Management

When setting up a team, you can assign a specific role.

- **Managers** - These individuals can manage organization teams and projects and have access to all projects.
Project Managers - These individuals can manage projects assigned to the team. They can also debug builds, update test settings, or manage deployments.

- **Contributors** - These individuals can view project dashboards and builds.

- **Owners** - These individuals handle credit card setup and billing-related issues.

![Add A Team]({{ site.baseurl }}/images/jenkins-guide/adding_a_team.png)

Setting up members and projects within a team is easy.

![Add A Team Member]({{ site.baseurl }}/images/jenkins-guide/add_team_member.png)

All of these features combine to provide a seamless way to bring projects, teams, and individual users from Jenkins over to Codeship.

Here I’ve set up the team accordingly, and we’re ready to get to work now!

![Team List]({{ site.baseurl }}/images/jenkins-guide/team_list.png)

## Setting Up Groups

I’ve set up three additional groups aside from the default owners group. One for the managers called Leadership, one for the project managers called Team Leads, and one for the programmers called Contributors.

When we select a team via the Teams section in the account settings, we can simply add projects to it.

![Team List]({{ site.baseurl }}/images/jenkins-guide/add_project_to_team.png)

We can now set up notifications per group. Navigate to the project by clicking on the project after adding it to the team role, and then click on the Project Settings and then Notifications.

![Team List]({{ site.baseurl }}/images/jenkins-guide/build_in_a_team.png)

## Conclusion

Codeship handles setup of organizations and users simply, with informative visibility into the project for team members while providing a seamless and low maintenance way to manage users and roles within Codeship, whether it be [Codeship Basic](https://codeship.com/features/basic) or [Codeship Pro](https://codeship.com/features/pro).

Now that you know how to migrate your Organizations, Users, and Permissions from Jenkins to Codeship we suggest looking into our other walk-throughs:

- [Migrating your Tests from Jenkins to Codeship](https://documentation.codeship.com/general/account/guides/migrating-from-jenkins-testing/)
- [Migrating your Notifications from Jenkins to Codeship](https://documentation.codeship.com/general/account/guides/migrating-from-jenkins-notifications/)

You also might be interested in downloading these migration guides as PDFs. You can do so here.

- [Migrating your Tests from Jenkins to Codeship (pdf)](https://resources.codeship.com/hubfs/Codeship_Migrating_from_Jenkins_to_Codeship-Testing.pdf)
- [Migrating your Organizations, Users, and Permissions from Jenkins to Codeship (pdf)](https://resources.codeship.com/hubfs/Codeship_Migrating_from_Jenkins_to_Codeship-Organizations_Roles_and_Users.pdf)
- [Migrating your Notifications from Jenkins to Codeship (pdf)](https://resources.codeship.com/hubfs/Codeship_Migrating_from_Jenkins_to_Codeship-Testing.pdf)
