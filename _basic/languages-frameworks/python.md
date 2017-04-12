---
title: Python
weight: 70
tags:
  - python
  - languages

redirect_from:
  - /languages/python/
---

* include a table of contents
{:toc}

## Versions And Setup

We use **virtualenv** to manage Python environments for you. We currently support Python `2.7.6`. Version `3.4.3` of Python is installed as well and available via the `python3` binary.

### Using Python 3

The virtual environment from `${HOME}/.virtualenv` is activated and configured for use with Python 2 by default. If you want to switch to version 3, simply add the following commands to your _Setup Commands_.

```shell
virtualenv -p $(which python3) "${HOME}/cache/python3_env"
source "${HOME}/cache/python3_env/bin/activate"
```

### Changing Versions

If you need a specific Python version installed, use [this script](https://github.com/codeship/scripts/blob/master/languages/python.sh) in your _Setup Commands_.

First set the desired version as an [environment variable]({{ site.baseurl }}{% link _basic/getting-started/set-environment-variables.md %}) in your project.

```shell
PYTHON_VERSION=3.6.0
```

Next add [this command](https://github.com/codeship/scripts/blob/master/languages/python.sh#L10) to your _Setup Commands_ and the script will automatically be called at build time.


## Dependencies

You can use **pip** to install any dependencies in your [setup commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}).

For example:

```shell
pip install -r requirements.txt
```

### Dependency Cache

Codeship automatically caches the `$HOME/.virtualenv/lib/python2.7/site-packages` directory between builds to optimize build performance. You can [read this article to learn more]({{ site.baseurl }}{% link _basic/getting-started/dependency-cache.md %}) about the dependency cache and how to clear it.

## Notes And Known Issues

Due to Python version issues, you may find it helpful to tests your commands with different versions via an [SSH debug session]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}) if tests are running differently on Codeship compared to your local machine.

## Frameworks And Testing

All Python frameworks, including Django, Flask and Pyramid, should work without issue as long as they do not require root-access for customized system configuration.

All test frameworks and tools, including pytest and unittest, should also work without issue.

## Parallelization

In addition to parallelizing your tests explicitly [via parallel pipelines]({{ site.baseurl }}{% link _basic/getting-started/parallelci.md %}), you may find that there are packages available for parallelizing different types of testing, such as [nose-parallel](https://pypi.python.org/pypi/nose-parallel), to speed your tests up.

While we do not officially support or integrate with these modules, many Codeship users find success speeding their tests up by using them. Note that it is possible for these modules to cause resource and build failure issues, as well.
