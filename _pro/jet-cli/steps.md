---
title: jet steps
menus:
  pro/jet:
    title: jet steps
    weight: 9
categories:
  - Jet CLI
tags:
  - jet
  - usage
  - cli
  - pro
  - steps
---

## Description
Run your Codeship Pro pipeline steps.

## Usage

```
jet steps [flags]
```

## Flags
{% include jet_flag_table.html flags=site.data.jet.flags.steps %}

## Extended description
Executing the `jet steps` command will build the services defined in the [codeship-services.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) file, and execute the steps in the [codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) file.

The `jet steps` command skips [push steps]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}#push-steps) and [branch/tag specific steps]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}#limiting-steps-to-specific-branches--tags) unless the appropriate flags are passed to the command.

Docker will use existing images when running `jet` locally. This may lead to builds passing locally, and failing remotely on Codeship. This is due to the remote environment starting without any prior images. We recommend removing any locally saved Docker images prior to running `jet steps` for a more consistent result to the remote server.


## Examples

### Steps with Push

```shell
$ jet steps --push
(step: tests)
...
(step: tests) success ✔
(step: push_service)
...
```

Using the `--push` flag will execute any [push steps]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}#push-steps) in the [codeship-steps.yml]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) file. If the step is also a [branch/tag specific step]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}#limiting-steps-to-specific-branches--tags), use `--tag` in conjunction with `--push`.


### Specify Branch or Tag
It is often necessary to test [branch/tag specific steps]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}#limiting-steps-to-specific-branches--tags).  To do this, use the `--tag` flag to specify a branch or tag name.

```shell
$ jet steps --tag master

$ jet steps --tag staging
```

### Using CI Flags

A remote build has access to [default environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md%}#default-environment-variables) populated from the SCM. You can pass similar data to test the behavior. A normal practice is to use the `commit-id` in a container tag, for example.

```shell
$ jet steps --ci-commit-id 1234ABCD --ci-branch master --ci-committer-name "Jane Doe" --ci-commit-message "A random message from the committer"
```
