---
title: Granting permission to access Organization repositories on GitHub
layout: page
tags:
  - troubleshooting
  - github
  - scm
  - 3rd party restrictions

redirect_from:
  - /troubleshooting/github-3rd-party-restrictions/
  - /faq/github-3rd-party-restrictions/
---

If the repositories for a GitHub organization don't show up on Codeship, please head over to the settings for the [Codeship application on GitHub](https://github.com/settings/connections/applications/457423eb34859f8eb490) and in the section labeled **Organization access** either

* _Request access_ if you are not an administrator for the organization. (Your request will then have to be approved by an admin.)
* _Grant access_ if you are an administrator.

Once this is done and access has been granted, the organizations repositories will show up in the repository selector on Codeship again.

See GitHub's help article on [3rd party restrictions](https://help.github.com/articles/about-third-party-application-restrictions/) for more background information about this feature.
