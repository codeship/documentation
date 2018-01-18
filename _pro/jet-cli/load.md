---
title: jet load
menus:
  pro/jet:
    title: jet load
    weight: 7
categories:
  - Jet CLI
tags:
  - jet
  - usage
  - cli
  - pro
---

## Description
Pull an image or build a docker service

## Usage

```
jet load service [flags]
```

## Flags

{% include jet_flag_table.html flags=site.data.jet.flags.load %}

## Extended Description
The `jet load` command allows you to build a service without executing anything. This can be helpful for debugging, e.g. if one particular service fails to load correctly you can isolate the issue by loading only that service. You can load a service defined in the [codeship-services.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) file.

## Examples

```shell
$ jet load web

(step: web-36a86f22)
(image: registry.heroku.com/todos-js/web) (service: web) Step 1/7 : FROM node:8.6.0-alpine
(image: registry.heroku.com/todos-js/web) (service: web)  ---> b7e15c83cdaf
...
(step: web-36a86f22) success ✔
```
