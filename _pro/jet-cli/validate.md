---
title: jet validate
menus:
  pro/jet:
    title: jet validate
    weight: 10
categories:
  - Jet CLI
tags:
  - jet
  - validate
  - cli
  - pro
---

## Description
Validates the `codeship-services.yml` and `codeship-steps.yml` files.

## Usage

```
jet validate [flags]
```

## Flags
{% include jet_flag_table.html flags=site.data.jet.flags.validate %}

## Extended description
The `jet validate` command will confirm that your [codeship-services.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) and [codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) are valid and ready to be used, or if there are any configuration issues.

* need examples of error output
