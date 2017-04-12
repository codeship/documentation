---
title: Push to Remote Repository
weight: 90
layout: page
tags:
  - deployment
  - git
  - push

redirect_from:
  - /continuous-deployment/push-to-remote-repository/
---

* include a table of contents
{:toc}

If you want to deploy your application by doing a `git push` to a remote repository please follow these steps:

1. Remove the Codeship deploy key from the repository. You'll find this option in the repository settings on the respective service.
2. Add the public key from your projects _General_ settings page to a so called [machine user](https://developer.github.com/guides/managing-deploy-keys/#machine-users) and provide this user with access to your repository. (Note that though we link to a GitHub documentation page, the process will work elsewhere as well.)
3. Add a _script-based deployment_ to your project and include the commands from [deployments/git-push.sh](https://github.com/codeship/scripts/blob/master/deployments/git_push.sh).
4. You might want to modify the commit message to include either of the following four strings if you push to a remote repository which is configured on Codeship as well, as the push would trigger a new build otherwise:

* `--skip-ci`
* `--ci-skip`
* `[skip ci]`
* `[ci skip]`
