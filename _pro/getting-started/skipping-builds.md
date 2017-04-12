---
title: Skipping builds
weight: 38
tags:
  - docker
  - jet
  - git
  - builds
  - testing

redirect_from:
  - /docker/skipping-builds/
---

* include a table of contents
{:toc}

You can add either of the following skip directives to the commit message of the last commit before you push and that push will be ignored:

* `--skip-ci`
* `--ci-skip`
* `[skip ci]`
* `[ci skip]`

Skipped builds do not have a build record and will not show up in the Codeship UI. They will also not count towards the concurrent builds or monthly build limits for users.

## Ignore pull request merges

When you merge a pull request you can add one of the skip directives to the commit message as well.
