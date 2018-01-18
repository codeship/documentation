---
title: Steps Configuration
menus:
  pro/builds:
    title: Steps Config
    weight: 3
tags:
  - docker
  - jet
  - configuration
  - steps
  - commands
  - testing
  - deployment
  - images
  - image registry
categories:
  - Builds and Configuration

redirect_from:
  - /docker/steps/
  - /pro/getting-started/steps/
  - /docker/dockercfg-services
  - /docker/getting-started/steps/
---

* include a table of contents
{:toc}

<div class="info-block">
This article is about the `codeship-steps.yml` file that powers Codeship Pro.

 If you are unfamiliar with Codeship Pro, we recommend our [getting started guide]({{ site.baseurl }}{% link _pro/quickstart/getting-started.md %}) or [the features overview page](http://codeship.com/features/pro).

 Also note that the `codeship-steps.yml` file depends on the `codeship-services.yml` file, which you can [learn more about here]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).
</div>

## What Is codeship-steps.yml?

`codeship-steps.yml` contains all the Steps for your CI/CD process. Steps are used for the `jet steps` command, which defines your continuous integration and delivery steps. By default, steps are expected to be in one of these 2 files:

* `codeship-steps.yml`
* `codeship-steps.json`

_Jet_ will look for a steps file in this order. If you are running _Jet_ locally, you can override the filename with the `--steps-path` flag. Both YAML and JSON formats are accepted.

## Prerequisites
Your Steps file will require that you have [installed Jet locally]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}) or [set up your project on Codeship.]({{ site.baseurl }}{% link _pro/quickstart/codeship-configuration.md %}). It will also require that you have configured your [codeship-services.yml file]({% link _pro/builds-and-configuration/services.md %}).

## Using codeship-steps.yml

Steps are specified in a list, such as:

```yaml
- name: foo_step
  tag: master
  service: app
  command: echo foo
- name: bar_step
  service: app
  command: echo bar
```

Steps are executed in the order they are specified. All steps share these directives:

* `name` specifies the name of the step, outputted in the logs. This must be unique for all steps. **This field is optional** and will be auto-generated if not specified.
* `tag` this field will cause the step to be executed only when the build tag matches the `tag` value. During a Codeship build, the build tag is either the branch name or tag associated with the commit. If you are using this feature locally, you can pass in `jet steps --tag TAG_NAME` to create a build tag. This field is optional.
* `exclude` this field prevents the step from being executed on branches or tags that match the `exclude` tag value. During a Codeship build, the build tag is either the branch name or tag associated with the commit. If you are using this feature locally, you can pass in `jet steps --tag TAG_NAME` to create a build tag. This field is the functional opposite of the `tag` field above. This field is optional. It takes precedence over the `tag` field.
* `encrypted_dockercfg_path` the path to your relevant dockercfg file, encrypted using `jet encrypt`. This is required for any steps using private base images or push steps. The dockercfg **must** contain an account for the registry being hit (e.g. _quay.io_ or _index.docker.io_)  with access to the repository being pulled.

## Limiting steps to specific branches or tags

As already mentioned you can specify a `tag` or `exclude`  attribute for each step. Codeship Pro supports two types of values for these attributes:

* A simple string will match the complete branch or tag name and allows you to limit a command to a single matching branch or tag. (This is the default mode if the value is a simple string.)

    * `tag: gh-pages` would limit the step to branches or tags matching `gh-pages`.
    * `exclude: gh-pages` would run the step on every branch or tag *except* `gh-pages`.

* A regular expression for more advanced configurations. Please note, that you need to specify line matchers `^` or `$` to trigger regular expression matching for tags.  __Note__ Codeship Pro uses the Golang regex library, so negative lookahead and conditional regexes are not supported.

    * `tag: ^(master|staging)` would run a command on `master` or `staging`, or any branch or tag beginning with `master` or `staging`, like `master-rebase`.
    * `exclude: ^(master|staging)` would skip the step on `master` or `staging`, or any branch or tag beginning with `master` or `staging`, like `master-rebase`.

If you are running your builds locally via the Jet CLI, you can pass in a branch or tag name for the build via the `--tag` flag, i.e. `jet steps --tag master`.

## Parallelizing steps and tests

If you're looking at running steps - such as setup commands, test commands or deployment commands - in parallel (i.e. simultaneously), it's as simple as using the `parallel` directive in your steps file.

```yaml
- type: parallel
  steps:
    - service: foo
      command: echo one
    - service: foo
      command: echo two
```

All steps you indent underneath the `type: parallel` directive will spin up separate containers on the host machine to run simultaneously. As with individual steps, if any parallel step fails the pipeline would not move past the current step group (although all still-running parallel steps will be allowed to finish.) It's important to note that, since every parallel step runs on a separate container, [you may need to use volumes]({{ site.baseurl }}{% link _pro/builds-and-configuration/docker-volumes.md %}) to persist or share data between your steps.

It is also worth noting that because parallel steps run separate containers simultaneously on the host machine, they will cause your build to use more resources (CPU and memory on the host machine) which can occasionally cause build issues if resources are maxed out (although you always have the option of upgrading to a larger build machine.)

You can also nest parallel (and serial) step groups within a larger parallel step group. See *Group Steps* below for more information.

## Group steps

There are two types of group steps:

* `parallel` run the sub-steps in parallel. Feel free to specify this recursively as much as you want, _Jet_ will just max out the number of available processors. If any sub-step fails, the parallel step fails as well.
* `serial` run the sub-steps serially. This is useful for grouping within parallel steps.

Group steps share the following directives:

* `dockercfg_service` specifies the Docker configuration service to use for a step.
* `encrypted_dockercfg_path` is the location of the encrypted Docker configuration file.
* `service` or `services` which specify a service or list of services for your steps to run on.
* `steps` is a list of sub-steps.
* `tag` indicates what branches the step will be run on (as a string or regex).
* `type` is the step type, either `parallel` or `serial`.

`dockercfg_service` and `encrypted_dockercfg_path` are mutually exclusive with `encrypted_dockercfg_path` taking precedence, i.e. if both are specified, the information is taken from `encrypted_dockercfg_path`.

`service` is a single string, `services` is a list of strings. At most one of these can be specified. If you specify a service at the group level you cannot specify a service for an individual run step. If you specify a list of services, all sub-steps will be run in one of two ways.

* For parallel steps, the sub-steps will be run as if you specified a serial step containing the sub-steps for each service.
* For serial steps, the services will be run in parallel.

Since that's confusing, here's a logically equivalent example:

```yaml
# Example 1
- type: parallel
  tag: "^(master|staging/.*)$"
  dockercfg_service: dockercfg_generator
  steps:
  - type: serial
    steps:
      - service: foo
        command: echo one
      - service: foo
        command: echo two
  - type: serial
    steps:
      - service: bar
        command: echo one
      - service: bar
        command: echo two

# the same as the above
- type: parallel
  tag: "^(master|staging/.*)$"
  dockercfg_service: dockercfg_generator
  services:
  - foo
  - bar
  steps:
  - command: echo one
  - command: echo two

# Example 2
- service: foo
  tag: "master"
  encrypted_dockercfg_path: dockercfg.encrypted
  command: echo one
- service: foo
  tag: master
  encrypted_dockercfg_path: dockercfg.encrypted
  command: echo two
- service: bar
  tag: master
  encrypted_dockercfg_path: dockercfg.encrypted
  command: echo one
- service: bar
  tag: "master"
  encrypted_dockercfg_path: dockercfg.encrypted
  command: echo two

# the same as the above
- type: serial
  tag: "master"
  encrypted_dockercfg_path: dockercfg.encrypted
  services:
  - foo
  - bar
  steps:
  - command: echo one
  - command: echo two
```

## Run steps

Run steps specify a command to run on a service. You must specify one or two directives:

* `command` the command to run. This is always required, and identifies a step as a run step. Note that quotes are respected to split up arguments, but special characters such as `&&`, `|` or `>` are not.
* `service` the service to run the command on. If you already specified a service at the group level you can not specify a service again, otherwise this directive is required.

## Push steps

<br />
<div class="info-block">
We implemented tagging via templates. See below for the available variables. Did we miss any important ones? Let us know at [support@codeship.com](mailto:support@codeship.com).
</div>

Push steps allow a generated container to be pushed to a remote docker registry. When running after a build, this allows a deployment based upon the successful build to occur. You must specify a number of directives:

* `type: push`
* `service` the service to run the command on. If the run step is a sub-step of a parallel step, `service` cannot be specified, otherwise it is required.
* `name` the name of this push step.
* `image_name` the name of the generated image as it exists in your service.yml/json file, in the format `[registry/][owner/][name]`.
* `image_tag` the tag the generated image should be pushed to. This can be either a hardcoded string (like `latest` ) or a golang [`Template` object](http://golang.org/pkg/text/template/) referencing any of the following variables. The resulting template will be stripped of any invalid characters. As an example, take the following configuration `{% raw %}"{{.ServiceName}}.{{.Branch}}"{% endraw %}` to get a tagged image like `sandbox-app.v0.2.6`.
    * `ProjectID` (the Codeship defined project ID)
    * `BuildID` (the Codeship defined build ID)
    * `RepoName` (the name of the repository according to the SCM)
    * `Branch` (the name of the current branch)
    * `CommitID` (the commit hash or ID)
    * `CommitMessage` (the commit message)
    * `CommitDescription` (the commit description, see footnote)
    * `CommitterName` (the name of the person who committed the change)
    * `CommitterEmail` (the email of the person who committed the change)
    * `CommitterUsername` (the username of the person who committed the change)
    * `Time` (a golang [`Time` object](http://golang.org/pkg/time/#Time) of the build time)
    * `Timestamp` (a unix timestamp of the build time)
    * `StringTime` (a readable version of the build time)
    * `StepName` (the user defined name for the `push` step)
    * `ServiceName` (the user defined name for the service)
    * `ImageName` (the user defined name for the image)
    * `Ci` (defaults to `true`)
    * `CiName` (defaults to `codeship`)
* `registry` the url of the registry being pushed to. For Docker Hub, use `https://index.docker.io/v1/`.
* `encrypted_dockercfg_path` the path to your relevant dockercfg file, encrypted using `jet encrypt`.
* `tag` a group tag associated with this build step (optional).

The commit description is the result of running `git describe --abbrev=1 --tags --always` for git, or `hg log -r . --template '{latesttag}-{latesttagdistance}-{node|short}\n'` for mercurial. This will be the current code deviation from the nearest tag.

When using a private repository, or a non-standard tag in the `image_name`, keep in mind your step directives _MUST_ match your service descriptions. In order to use a private registry, the `image_name` directive in your steps file needs to match the `image_name` from `codeship_services.yml`, and should look something like `myregistry.mydomain.com:5002/myuser/myrepo`.

As for the `encrypted_dockercfg_path` directive, we support both, the older `.dockercfg` as well as the newer `${HOME}/.docker/config.json` format. You can simply encrypt either of those files via `jet encrypt` and commit the encrypted files to the repository and the configuration will be picked up.

## Build Environment

For each step, the running container is provided with a set of environment variables from the CI process. These values can help your containers to make decisions based on your build pipeline.

* `CI_PROJECT_ID` (the Codeship defined project ID)
* `CI_BUILD_ID` (the Codeship defined build ID)
* `CI_REPO_NAME` (the name of the repository according to the SCM)
* `CI_BRANCH` (the name of the current branch)
* `CI_COMMIT_ID` (the commit hash or ID)
* `CI_COMMIT_MESSAGE` (the commit message)
* `CI_COMMIT_DESCRIPTION` (the commit description)
* `CI_COMMITTER_NAME` (the name of the person who committed the change)
* `CI_COMMITTER_EMAIL` (the email of the person who committed the change)
* `CI_COMMITTER_USERNAME` (the username of the person who committed the change)
* `CI_TIMESTAMP` (a unix timestamp of the build time)
* `CI_STRING_TIME` (a readable version of the build time)
* `CI` (defaults to `true`)
* `CI_NAME` (defaults to `codeship`)

Please see our [Docker Push Tutorial]({{ site.baseurl }}{% link _pro/builds-and-configuration/image-registries.md %}) for an example on how to push to [Quay.io](https://quay.io) or the Docker Hub.

## Step Timeouts

On **Codeship Pro**, a build can run for up to 2 hours, although builds will time out if there is no log activity for 15 minutes.

## Validating Your Files

You can use the `jet validate` command, via our [local CLI]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}), to verify that your files are configured correctly and ready to be used.
