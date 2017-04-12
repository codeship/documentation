---
title: Include / Exclude Commands On Specific Branches
layout: page
tags:
  - faq
  - commands
  - branch

redirect_from:
  - /faq/ignore-command-on-branch/
---

* include a table of contents
{:toc}

## What is including or excluding a specific branch?

For a variety of reasons, you may want to either _only run_ commands on certain branches (i.e. only run custom alert commands on the `master` branch) or _exclude_ commands from running on certain branches (i.e. never run acceptance tests if on a branch that starts with `feature/*`).

Below you will find scripts that you can use on your project's [setup and test commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}) to accomplish both scenarios.

## Using Include / Exclude Commands Per Branch

### Skip A Command On Specific Branches

If you don't want to run a command on a specific branch use the following syntax. In this example we run your command on every branch except gh_pages

```shell
if [ "$CI_BRANCH" != "gh-pages" ]; then YOUR_COMMAND; fi
```

### Only Run A Command On Specific Branches

If you want to run a specific command only on one branch use the following syntax. In this example we run your command only on the master branch.

```shell
if [ "$CI_BRANCH" == "master" ]; then YOUR_COMMAND; fi
```
