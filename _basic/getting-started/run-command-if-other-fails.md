---
title: Running A Command If A Step Fails
layout: page
tags:
  - faq
  - build error
  - commands

redirect_from:
  - /faq/run-command-if-other-fails/
---

* include a table of contents
{:toc}

## Running A Command If A Step Fails

In some workflows, you may want to execute a command _only when_ a previous command has failed. As one example, you may want to run an alerts script if your tests fail.

By default, Codeship exits a build once their is a failure of any kind, which means when any command reports back a status code other than `0`. However, by wrapping your commands in an "on fail" script, you can create a fallback conditionality and then exit your build appropriately afterwards.

## Using The "On Fail" Script

To run another command if an earlier one fails you can use the following bash syntax

```shell
YOUR_COMMAND || (OTHER_COMMAND && exit 1)
```

This will still fail the build, but will let you execute another command first. If you are looking for a more flexible solution, take a look at [ensure_called.sh](https://github.com/codeship/scripts/blob/master/utilities/ensure_called.sh).
