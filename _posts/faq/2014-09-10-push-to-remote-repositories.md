---
title: Pushing to remote repositories
layout: page
tags:
  - faq
  - build error
  - github
  - bitbucket
  - shallow clone
categories:
  - faq
---
If you want to push to a remote git repository during your deployment steps on Codeship, and the build fails with an error message such as the following:

```shell
Writing objects: 100% (1065/1065), 234.32 KiB | 0 bytes/s, done.
Total 1065 (delta 602), reused 1065 (delta 602)
error: Could not read c70d417b6c0f4536f9a288888e80955b78b1cbc7
fatal: Failed to traverse parents of commit d9ff2fe276d15d485f9c71c309160d47cd4ccdfb
```

This is because we perform a *shallow clone* of the repository to speed up build times. We also only clone the specific branch which triggered the build, so if you want to push to another branch you need to fetch those first. The following two commands take care of this.

{% gist mlocher/fc922d5fec6c12539d51 %}
