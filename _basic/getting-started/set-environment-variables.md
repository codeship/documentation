---
title: Environment Variables on Codeship Basic
weight: 96
tags:
  - testing
  - environment variables

redirect_from:
  - /continuous-integration/set-environment-variables/
---

* include a table of contents
{:toc}

## Environment Variables On Codeship Basic

For most applications, you will need to set environment variables to be passed in your project's build so that build steps, tests and deployments can all run successfully.

On Codeship Basic, this can be done either through your project's *Project Settings* screen or through exporting environment variables during your setup or test commands. Additionally, we provide a set of pre-populated, global environment variables with information related to your build and the commit that triggered it.

## Environment Page on Project Settings

On the ***Environment*** page of your project settings you can enter the variable name and values into the corresponding fields.

![Environment Settings page]({{ site.baseurl }}/images/continuous-integration/environment-variables.png)

We will export these environment variables to the environment your build runs via a command similar to:

```bash
export VARIABLE_NAME="value"
```

Single (`'`) and double quotes (`"`), as well as backticks (`` ` ``) in the _value_ part of your variable are automatically escaped by prepending them with a backslash (`\`). Other characters with a special meaning (e.g. `$`) are not escaped automatically to allow you to use them with your environment variables. (For example to include the value of another variable.)

We export your environment variables before all other commands of your build. This is pure convenience for setting up the environment but completely equal to exporting environment variables yourself.

### Directly in Setup or Test Commands

You can also export environment variables in your setup or test commands. So, for example, you could enter the following setup commands:

```bash
rvm use 2.0.0
export RAILS_ENV="test"
bundle install
```

There is no difference between setting ***RAILS_ENV*** like this and adding it on the ***Environment*** page of your project settings. The advantage of putting it into the environment configuration is that secret values will not show up in your build log.

### Default Environment Variables

The following environment variables are exported automatically. You can use them to build your own scripts, run specific commands only if you are on a specific branch or even add flags to your ***CI_MESSAGE*** and use those flags to influence your build.

You can get the value of an environment variable by adding `$` in front of the variable name. For example:

```shell
echo "$CI_MESSAGE"
```

| Name                        | Value                                              |
| ----------------------------|:---------------------------------------------------|
| `CI`                        |  true                                              |
| `CI_BUILD_NUMBER`           |  ID of the build in our service                    |
| `CI_BUILD_URL`              |  URL of the build                                  |
| `CI_PULL_REQUEST`           |  false [^pull_request]                             |
| `CI_BRANCH`                 |  Branch of the build                               |
| `CI_COMMIT_ID`              |  Commit Hash of the build                          |
| `CI_COMMITTER_NAME`         |  Name of the committer                             |
| `CI_COMMITTER_EMAIL`        |  Email of the committer                            |
| `CI_COMMITTER_USERNAME`     |  Username of the commiter in their SCM service     |
| `CI_MESSAGE`                |  Message of the last commit for that build         |
| `CI_NAME`                   |  codeship                                          |

[^pull_request]: This value is hardcoded and doesn't indicate whether a build was triggered by a pull request or not at the moment. Once we add support for building external pull requests, we will update this environment variable accordingly as well.
