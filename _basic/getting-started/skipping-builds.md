---
title: Skipping Builds On Codeship Basic
weight: 95
tags:
  - testing
  - faq
  - builds

redirect_from:
  - /continuous-integration/skipping-builds/
---

* include a table of contents
{:toc}

## Skipping Builds On Codeship Basic

You may want to instruct Codeship not to run builds for specific commits, either because they are not relevant or to avoid backing up your build queue.

To do this, there are certain text strings you can include in your commit message, before pushing your commit to source control, that we will parse and skip accordingly.

## Using The Skip Builds Commit Messages

You can add either of the following skip directives to the commit message of the last commit before you push and that push will be ignored:

* `--skip-ci`
* `--ci-skip`
* `[skip ci]`
* `[ci skip]`

### Ignore pull request merges

When you merge a pull request you can add one of the skip directives to the commit message as well.

### Can we limit the branches that are built?

We build all branches you push to your repository. In our opinion every push to your repository should be tested.

We don't have a feature to limit which branches can be built.
