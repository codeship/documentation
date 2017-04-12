---
title: Pushing to git remote fails
layout: page
tags:
  - troubleshooting
  - build error
  - github
  - bitbucket
  - gitlab
  - shallow clone
  - push
  - git

redirect_from:
  - /troubleshooting/push-to-remote-repositories/
  - /faq/push-to-remote-repositories/
---
If you want to push to a remote git repository during your deployment steps on Codeship, and the build fails with an error message such as the following:

In case you push to a remote git repository and encounter an error with an error message like the following

```shell
Writing objects: 100% (1065/1065), 234.32 KiB | 0 bytes/s, done.
Total 1065 (delta 602), reused 1065 (delta 602)
error: Could not read c70d417b6c0f4536f9a288888e80955b78b1cbc7
fatal: Failed to traverse parents of commit d9ff2fe276d15d485f9c71c309160d47cd4ccdfb
```

please include these commands in your script deployment

```shell
#!/bin/sh
git fetch --unshallow || true
git fetch origin "+refs/heads/*:refs/remotes/origin/*"

# checkout a remote branch with
# git checkout -b test origin/test
```

The reason for the error is that we only perform a _shallow clone_ of your git repository to speed up build times. We also only clone the specific branch which triggered the build, so if you want to push to another branch you need to fetch it first (which is taking care by lines 5 & 6 in the second script).
