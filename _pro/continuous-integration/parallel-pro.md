---
title: Running Tests In Parallel on Codeship Pro
layout: page
weight: 47
tags:
  - docker
  - jet
  - tools
  - tests
---

* include a table of contents
{:toc}

## Parallelizing on Codeship Pro

One of the ways Codeship Pro makes it easy to get faster and more powerful build pipelines is with an open-ended approach to parallelization.

On Codeship Pro, you can parallelize any commands you want, and at any point in your pipeline you wish. You can also parallelize _as much_ as you want to - the only barrier is the resources on the host machine.

The [pricing](https://codeship.com/pricing/pro) for Codeship Pro is centered around what size build machine you need, essentially the CPU and memory resources you need available. Every build and every group of containers use a unique amount of resources, but as a rule of thumb the more you have running at once, the more CPU and memory resources you'll need.

## Setting Up Parallel Steps

To set up your parallel steps in Codeship Pro, you will be making changes to your [codeship-services.yml]({% link _pro/getting-started/services.md %}) file.

A parallel step group is just defined by using the `type: parallel` header and then nesting all steps you want parallelized underneath, as seen in this example:

```
- type: parallel
  steps:
  - service: app
    command: ./script/ci/ci.parallel spec
  - service: app
    command: ./script/ci/ci.parallel plugin
  - service: app
    command: ./script/ci/ci.parallel qunit
```

## Parallelizing Test Specs

To break a larger test suite into parallelized groups of test specs running simultaneously, you'll want to call your individual specs via separate commands rather than invoking the test suite overall:

```
- type: parallel
  steps:
  - service: app
    command: rspec tests/frontend
  - service: app
    command: rspec tests/backend
  - service: app
    command: rspec tests/api
```

## Parallel Modules

In addition to parallelizing explicitly in your [codeship-services.yml]({% link _pro/getting-started/services.md %}), most popular frameworks offer modules that you can install to parallelize within the codebase itself.

While we do not officially support or integrate with any of these modules, many Codeship users find success speeding their tests up by using them. **Note** that in many cases these modules create additional strain on your machine resource usage, so you will want to keep an eye on this as misconfiguration can result in a resource max out that ultimately slows your builds down or causes failures.

### Rails
- [https://github.com/grosser/parallel_tests](https://github.com/grosser/parallel_tests)
- [https://github.com/ArturT/knapsack](https://github.com/ArturT/knapsack)

### Node
- [https://www.npmjs.com/package/mocha-parallel-tests](https://www.npmjs.com/package/mocha-parallel-tests)

### PHPUnit
- [https://github.com/brianium/paratest](https://github.com/brianium/paratest)

## Common Issues

If builds are running slow or failing intermittently and you think memory or CPU constraints may be a cause, you can [contact our helpdesk](https://helpdesk.codeship.com), and we can investigate your resource usage and see if a larger build machine makes sense.

Or, if you just want to upgrade to a larger build machine or try a larger machine out in a trial period, you can contact our [account team](mailto:solutions@codeship.com).
