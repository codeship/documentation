---
title: Debugging Your Builds Via SSH Sessions
weight: 1
tags:
  - testing
  - ssh
  - key
  - debug

redirect_from:
  - /continuous-integration/ssh-access/
---

* include a table of contents
{:toc}

## What Is An SSH Debug Session?

You may find yourself trying to figure out why a particular build is failing, especially if the build succeeds locally or succeeded in the past. Often times the solution to these problems is to change versions, change dependencies, or change timing.

To make this troubleshooting and debugging process faster, we allow you to open an SSH debug session and connect to your build machine directly, where you can directly run different commands yourself to test for different solutions to the issue you may be having. This is often the fastest way to solve problems with builds that are failing.

## Using SSH Debug Sessions

You are able to activate an SSH debug session via the sidebar when you are looking at the log output screen for an individual build. One activated, the machine will take about a minute to prepare the session and then you will be giving an SSH command you can copy and paste into your local terminal to access the machine.

When you start a SSH Debug session we will clone the repository and set up all environment variables that you defined and that we set by default.

Your application itself is cloned into a directory named `$HOME/clone`, and you will want to `cd` into this directory to run your debug commands.

**Note** that we do not run any setup or test commands when preparing a machine for an SSH debug session. This gives you a clean machine so you can fully test and debug your application on Codeship. The SSH session is completely separate from any builds run before.

### Configuring SSH Access

To be able to open an SSH debug session, you will need to configure SSH access on your account. The first thing you will need to do is get your local machine's SSH key.

If you need to generate a new local key, you can do so by running:

```shell
ssh-keygen -b 8192
```

Or, if you need to fetch your existing local key, you can do so by running:

```shell
cat ~/.ssh/id_rsa.pub
```

Once you have your local key, you will need to add it to your Codeship *Account Settings*, which is accessible by clicking on your name in the top right of your screen. Once there, you will paste your local machine's key into the box labeled *Public SSH Key*.

![Public Key Setup]({{ site.baseurl }}/images/basic/public-key.png)

### Default Codeship Commands

Inside the SSH session, you have access to default Codeship commands. It provides some convenient methods to debug your project. You can view the available methods by running:

```shell
cs help
```

### Useful commands

Get insight into Environment variables:

```shell
printenv
```

You can use `grep` to filter the Environment:

```shell
printenv | grep CI
```

You can clear the [Dependency Cache]({{ site.baseurl }}{% link _basic/getting-started/dependency-cache.md %}):

```shell
cs clear-cache
```

### SSH Debug Session Timeout

The debug build will shutdown itself after **60 minutes**

You can shutdown the debug build manually by using

```shell
cs exit
```
