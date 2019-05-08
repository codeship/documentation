---
title: Signing Up For A New Codeship Account
shortTitle: Signing Up For A New Account
menus:
  general/account:
    title: New User Signup
    weight: 1
tags:
- account
- scm
- svn
- badge
- avatar
- gravatar
- getting started
categories:
  - Account
  - Guide
redirect_from:
  - /general/about/other-scm/
  - /general/account/configure-your-avatar/
  - /faq/codeship-badge/
  - /general/about/codeship-badge/
  - /faq/configure-your-avatar/
  - /faq/other-scm/
weight: 1
---

* include a table of contents
{:toc}

## Setting Up A New Codeship Account

If you're looking to sign up and create a project on Codeship, this guide will walk you through the initial onboarding process.

### Signing up for Codeship with GitHub, GitLab or Bitbucket 

You can sign up for a new Codeship Account either with your Source Code Management (SCM) or email address.  The following SCMs are supported: GitLab, Bitbucket, or GitHub.

To signup with your SCM:

Note that these oAuth login pages come directly from the SCM tools themselves and we do not have access to them or to the credentials you provide.
1. [Navigate to our signup page](https://app.codeship.com/registrations/new).
![SCM Choice]({{ site.baseurl }}/images/new-user-setup/scm-choice.png)
2. Select either GitHub, GitLab or Bitbucket.

- **If GitHub:**  You are automatically navigated to a login page where you must enter your GitHub login credentials in order to give Codeship access to your account.

![Github Login]({{ site.baseurl }}/images/new-user-setup/gh-login.png)
- **If Bitbucket:**  You are automatically navigated to a login page where you must enter your bitbucket login credentials in order to give Codeship access to your account.

![Bitbucket Login]({{ site.baseurl }}/images/new-user-setup/bb-login.png)

- **If GitLab:** You are automatically navigated to a login page where you must enter your GitLab login credentials in order to give Codeship access to your account.

![GitLab Login]({{ site.baseurl }}/images/new-user-setup/gl-login.png)

### Signing up for Codeship with an e-mail address

To sign up for Codeship with an email:

1. Enter your Name, Email Address, and create a Password.

2. Click the _Sign up for free_ button.

![Email Login]({{ site.baseurl }}/images/new-user-setup/email-login.png)

*You can learn more about the permissions we ask when authenticating with SCM [here]({{ site.baseurl }}{% link _general/about/permissions.md %}). Learn more about security at Codeship [here]({{ site.baseurl }}{% link _general/about/security.md %}).*

**Note**: When signing up using your email, we won't know what your git username is, which means that your personal dashboard (aka your home page) won't be populated with your builds. To get your builds to show up, head over to your [Connected Services](https://app.codeship.com/authentications) page and enter your git username(s) there.

### Creating your organization account 

* Organization accounts are free to start and offer 100 free private builds per month and unlimited open source builds.
* Organization accounts offer [centralized team management and team permissions]({{ site.baseurl }}/general/account/organizations/).

Once you’ve signed up, unless you were invited by a team member to an existing organization, you will be asked to create a new organization. Organization names must be unique since, you will be able to access your account with a unique URL. The unique URL is:  `app.codeship.com/<your-organization-name>`.

To create your organization account:

1. Enter a unique organization name.
![Account Creation Page]({{ site.baseurl }}/images/new-user-setup/organization-creation.png)
2. Click _Create Organization_.

or

Ask your team to invite you to an existing organization with your e-mail.

_In case you are expecting to be invited to an already existing organization, you will find the email you signed up with - sometimes less obvious for oauth signup - on the organization creation page._

### Creating your first project

Right after account creation, you can either create your first project right away or begin setting up your teams and inviting your colleagues.

To create your first project:

1. Select either GitHub, Bitbucket, or GitLab. If you signed up for Codeship with GitLab, Bitbucket, or Github, you can skip this step.

2. Enter your Git clone URL. You can find the correct clone command in the header of the repository under Clone.  
The following are examples of Git clone URLs:  
git@gitlab.com:<username>/<repository_name>.git, https://username@gitlab.com/<username>/<repository_name>.git, and https://gitlab.com/<username>/<repository_name>.git
3. Click the _Connect_ button.
Note that a repository can only be connected to one project, and a project can only have one repository.
Now that you’ve connected your repository, it’s time to select your infrastructure!
4. Either select _Select Pro Project_ or _Select Basic Project_. You can choose to set up your project with [Codeship's Basic Infrastructure.](https://codeship.com/features/basic) or [Codeship's Pro Infrastructure.](https://codeship.com/features/pro).
**Basic** is a good place to start if:
- You want out of the box configuration.
- You can use common, pre-installed CI dependencies.
- You would prefer easy, 1-click app integrations.
**Pro** is a good place to start if:
- You want Native Docker support.
- You want a fully customizable CI environment.
- You want a local build runner for test consistency.


### Customizing your project

#### Adding team members to your projects

To add team members to your project: 

1. Select the _Teams_ tab in the dashboard.

2. Click the _New Team_ button.

3. Enter the  team name and select the team role.

We recommend inviting people to the _Managers_ team if they will need to create or delete projects or manage additional team members. See [Team roles and permissions]({{ site.baseurl }}/general/account/organizations/#managing-teams-and-projects) for more information.


#### Adding status badges to your repository

If you want to add a badge showing your last builds status to your ReadMe, you can find the code in the **Notification** settings of your project.

![Codeship Status for codeship/documentation](https://codeship.com/projects/0bdb0440-3af5-0133-00ea-0ebda3a33bf6/status?branch=master)

The raw URL for the image looks like the this:

```
https://codeship.com/projects/YOUR_PROJECT_UUID/status?branch=master
```

The UUID for a specific project is available on the **General** tab in your project settings.

### Additional information

#### Configuring your avatar

Git identifies people by your e-mail and Codeship uses your Gravatar settings for your profile picture. If you have not set up Gravatar yet and want to change the avatar shown on Codeship and in your commit messages, please head over to [Gravatar.com](https://en.gravatar.com/) and setup an avatar for both the email address you configured in your Codeship [Account Settings](https://app.codeship.com/user/edit) as well as for any email addresses you use in your git configuration.

You can check the latter by running the following command in your local git checkout.

```shell
# global configuration
git config --global --get user.email

# project specific (local) configuration
git config --get user.email
```

Note that different projects can have different email addresses configured and that your VCS can have other email addresses configured for the actions you take via their interfaces.

#### Keyboard shortcuts

To make it easier to navigate through your Codeship projects, we've provided several keyboard shortcuts for quickly jumping through the interface:

- `Shift` + `?` brings up a list of all shortcuts
- `gp`, available from inside your projects, will return you to your projects overview page
- Escape key, available on your projects overview page, will return you to the previous page
- Arrow keys, available on your projects overview page, will navigate between your projects
- Enter key, available on your projects overview page, will select the highlighted project
- `s` focuses on the project search bar
- `gd` returns you to the CodeShip homepage
