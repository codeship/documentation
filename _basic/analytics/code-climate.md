---
title: Code Climate Integration
layout: page
tags:
  - analytics
  - integrations
redirect_from:
  - /analytics/code-climate/
  - /classic/getting-started/code-climate/
---

* include a table of contents
{:toc}

## Setup

There is no specific setup necessary to use Code Climate on Codeship.
You can follow the [Code Climate docs](http://docs.codeclimate.com/article/219-setting-up-test-coverage)
set it up with your application and just include the Code Climate API key either
in the environment settings or prefix your test commands with it as explained in their docs.

For example execute your rake tests with the Code Climate token:

```shell
# After adding Code Climate to your application
CODECLIMATE_REPO_TOKEN=ACDDD1111222223333 bundle exec rake
```

## Successful build, even though tests failed

Because of a bug with version 0.8.x of simplecov, tests are reported as successful, even though they actually failed. This is caused by simplecov overriding the exit code of the test framework.

According the the [issue report on GitHub](https://github.com/colszowka/simplecov/issues/281) this won't be fixed in the 0.8 release any more. Please either use versions prior to 0.8 or higher than 0.9.
