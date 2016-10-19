---
title: Run a command after another command fails
layout: page
tags:
  - faq
  - build error
  - commands
categories:
  - classic-infrastructure
---
To run another command if an earlier one fails you can use the following bash syntax

```shell
YOUR_COMMAND || (OTHER_COMMAND && exit 1)
```

This will still fail the build, but will let you execute another command first. If you are looking for a more flexible solution, take a look at [ensure_called.sh](https://github.com/codeship/scripts/blob/master/utilities/ensure_called.sh).
