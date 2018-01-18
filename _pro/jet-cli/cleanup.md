---
title: jet cleanup
menus:
  pro/jet:
    title: jet cleanup
    weight: 3
categories:
  - Jet CLI
tags:
  - jet
  - cleanup
  - cli
  - pro
---

## Description
Remove docker resources left behind by Jet.

## Usage

```
jet cleanup [flags]
```

## Flags
{% include jet_flag_table.html flags=site.data.jet.flags.cleanup %}

## Extended description
With `jet cleanup` you can be sure that Jet removes any leftover containers, networks and all other Docker build artifacts of your local build run.

Typically, cleanup happens by default but the `jet cleanup` command allows you to invoke it manually if there are any issues that prevent Jet from completing.

## Examples

### Cleanup Dry Run
```shell
$ jet cleanup --dry-run
Would remove container "/jet-service-tests"
```
