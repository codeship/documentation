---
title: Ignore command on specific branch or run only on a branch
layout: page
tags:
  - faq
  - commands
  - branch
---
## Ignore command on a branch

If you don't want to run a command on a specific branch use the following syntax.
In this example we run your command on every branch except gh_pages

~~~shell
if [ "$CI_BRANCH" != "gh-pages" ]; then YOUR_COMMAND; fi
~~~

## Run command only on one branch

If you want to run a specific command only on one branch use the following syntax.
In this example we run your command only on the master branch.

~~~shell
if [ "$CI_BRANCH" == "master" ]; then YOUR_COMMAND; fi
~~~
