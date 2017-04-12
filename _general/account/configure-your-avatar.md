---
title: Configure Your Avatar
layout: page
tags:
  - faq
  - avatar
  - gravatar

redirect_from:
  - /faq/configure-your-avatar/
---

Git identifies people by their e-mail and uses your Gravatar settings for your profile picture. If you have not set up Gravatar yet and want to change the avatar shown on Codeship and in your commit messages, please head over to [Gravatar.com](http://www.gravatar.com/) and setup an avatar for both the email address you configured in your Codeship [Account Settings](https://codeship.com/user/edit) as well as for any email addresses you use in your git configuration.

You can check the latter via running the following command in your local git checkout.

```shell
# global configuration
git config --get user.email

# project specific (local) configuration
git config --get user.email
```

Note that different projects can have different email addresses configured and that your VCS can have other email addresses configured for the actions you take via their interfaces.
