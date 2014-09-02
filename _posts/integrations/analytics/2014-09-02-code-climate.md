---
title: Code Climate Integration
layout: page
tags:
  - analytics
  - integrations
categories:
  - analytics
---
There is no specific setup necessary to use Code Climate on Codeship.
You can follow the [Code Climate docs](http://docs.codeclimate.com/category/3-test-coverage)
set it up with your application and just include the Code Climate API key either
in the environment settings or prefix your test commands with it as explained in their docs.

For example execute your rake tests with the Code Climate token:

~~~shell
# After adding Code Climate to your application
CODECLIMATE_REPO_TOKEN=ACDDD1111222223333 bundle exec rake
~~~
