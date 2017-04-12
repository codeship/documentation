---
title: Signing Up For Codeship
weight: 10
tags:
- account

---

## Setting Up A New Codeship Account

If you're looking to sign up and create a project on Codeship, this guide will walk you through the initial onboarding process.

### Signing Up

**Sign up** [Navigate to our signup page](https://codeship.com/registrations/new).  You can sign up either via your Source Code Management (SCM) or email address.  SCMs we currently support are: GitLab, Bitbucket, or GitHub.

Note that these oAuth login pages come directly from the SCM tools themselves and we do not have access to them or to the credentials you provide.

![SCM Choice]({{ site.baseurl }}/images/new-user-setup/scm-choice.png)

- **Via GitHub:**  After selecting GitHub, you are automatically navigated to a login page where you must enter your GitHub login credentials in order to give Codeship access to your account.

![Github Login]({{ site.baseurl }}/images/new-user-setup/gh-login.png)

- **Via Bitbucket:**  After selecting Bitbucket, you are automatically navigated to a login page where you must enter your bitbucket login credentials in order to give Codeship access to your account.

![Bitbucket Login]({{ site.baseurl }}/images/new-user-setup/bb-login.png)

- **Via GitLab:** After selecting GitLab, you are automatically navigated to a login page where you must enter your GitLab login credentials in order to give Codeship access to your account.

![GitLab Login]({{ site.baseurl }}/images/new-user-setup/gl-login.png)

- **Via Email:**   If you prefer to not sign up for Codeship via an SCM, you may also sign up via email.  You simply provide your: Name, Email Address, and create a Password, then hit ‘Sign up for free’.

![Email Login]({{ site.baseurl }}/images/new-user-setup/email-login.png)

*You can learn more about the permissions we ask when authenticating with SCM [here](https://documentation.codeship.com/general/account/permissions/).  Learn more about security at Codeship [here](https://documentation.codeship.com/general/about/security/).*

### New User Setup

Once you’ve signed-up for Codeship you’ll be directed to a short form where we ask a few questions about your team size and type of product you’re looking for.  We ask these questions so that we can get a better sense of what you’d like to achieve with Codeship and so that we can direct you to the correct resources/help.

![Email Login]({{ site.baseurl }}/images/new-user-setup/new-user-form.png)

**Authenticate SCM:**  If you signed up for Codeship via GitLab, Bitbucket, or Github, your SCM is already authenticated!  If you’ve signed up via email, you authenticate your SCM here:

![Email Login]({{ site.baseurl }}/images/new-user-setup/authenticate-scm.png)

Simply click on the SCM icon you would like to connect with and proceed to provide your login credentials in order to give Codeship access to your account (see step 1 for further information).

**Choose your repository:** Once you have authenticated your SCM you have to select your repository.  To choose your repository, simply paste your Git clone URL into the provided area and click ‘Connect’.  

_Examples_:
- git@gitlab.com:<username>/<repository_name>.git
- https://username@gitlab.com/<username>/<repository_name>.git
- https://gitlab.com/<username>/<respository_name>.git

![Bitbucket Repo]({{ site.baseurl }}/images/new-user-setup/bb-repo.png)

![Github Repo]({{ site.baseurl }}/images/new-user-setup/gh-repo.png)

![Gitlab Repo]({{ site.baseurl }}/images/new-user-setup/gl-repo.png)

Now that you’ve connected your repo, it’s time to select your infrastructure!  You simply have to decide if you want to set up your project with [Codeship's Basic Infrastructure.](https://codeship.com/features/basic) or [Codeship's Pro Infrastructure.](https://codeship.com/features/pro)


**Basic** is a good place to start if:

- You want out of the box configuration
- You can use common, pre-installed CI dependencies
- You would prefer easy, 1-click app integrations

**Pro** is a good place to start if:

- Native Docker support
- Fully customizable CI environment
- Local build runner for test consistency

Once you know which type of infrastructure you’d like to use, simply click ‘Select Infrastructure’ on the corresponding project.

![Select Codeship Infrastructure]({{ site.baseurl }}/images/new-user-setup/select-infra.png)
