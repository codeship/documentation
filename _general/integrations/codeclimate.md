---
title: Integrating Codeship With Code Climate for Code Coverage Reports
shortTitle: Using Code Climate For Code Coverage
tags:
  - analytics
  - code-coverage
  - coverage
  - reports
  - reporting
  - continuous integration
  - integrations
menus:
  general/integrations:
    title: Using Code Climate
    weight: 1
redirect_from:
  - /basic/continuous-integration/code-climate/
  - /pro/continuous-integration/codeclimate-docker/
  -  /analytics/code-climate/
  - /classic/getting-started/code-climate/
  -  /basic/analytics/code-climate/  
---

<div class="info-block">
**Note** that these instructions use the newest version of the Code Climate reporter, which is still in beta. Please view [their documentation](https://docs.codeclimate.com/v1.0/docs/configuring-test-coverage-older-versions) for instructions on using the older reporter. You will still need to add your API token via [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}), as seen below, but the test configuration will work differently.
</div>

* include a table of contents
{:toc}

## About Code Climate

Code Climate is an automated code coverage service. Starting with Code Climate and Codeship is fast and easy. [Their documentation](http://docs.codeclimate.com/article/219-setting-up-test-coverage) does a great job of providing more information, in addition to the setup instructions below.

## Codeship Pro

### Adding Reporter ID

To start, you need to add your `CC_TEST_REPORTER_ID` to the [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) that you encrypt and include in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

### Project Configuration

Once your Code Climate project ID is loaded via your environment variables, you will need to install Code Climate into one of your services via your Dockerfile by using the following command:

```bash
curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > "$/usr/local/bin/cc-test-reporter"
chmod +x "/usr/local/bin/cc-test-reporter"
```

Next, you will need to add a couple additional commands to your pipeline via your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}).

Before your test commands:

```bash
- name: codeclimate_pre
  service: YOURSERVICE
  command: cc-test-reporter before-build
```

After your final test commands:

```bash
- name: codeclimate_post
  service: YOURSERVICE
  command: cc-test-reporter after-build --exit-code $ -prefix /path
```

The prefix here is what you'll need to remove from absolute paths in coverage payloads, to make them relative to the project root. This is usually the directory in which the tests were run.

### Parallel Test Coverage

Code Climate supports parallel test reports by uploading the partial result to an external service, such as S3.

In addition to the pre-test and post-test commands above, to use Code Climate with parallel reporting you will need to add another command after your individual tests, and after all tests have completed, in your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}).

Here are [Code Climate's example](https://github.com/codeclimate/test-reporter#low-level-usage) scripts for doing so.

After each parallel test command you'll run a new script:

```
- type: parallel
  steps:
    - service: YOURSERVICE
      command: tests1.sh
    - service: YOURSERVICE
      command: tests2.sh
```

Note that we're using script files to run our tests, so that we can execute the tests and export the coverage report as one command. This is because each step uses a new container, so the coverage report will not persist if the commands are separated. Inside the new `tests.sh` files, you will have:

```bash
# your test commands go here

./cc-test-reporter format-coverage --output "coverage/codeclimate.$N.json"
aws s3 sync coverage/ "s3://my-bucket/coverage/$CI_COMMIT_ID"
```

Note that you will need to modify the S3 path (or provide an alternative storage path), as well as set the `$N` value value by manually declaring separate pipeline IDs.

Next, at the end of your build itself, as a new test command placed after your normal tests:

```bash
- name: codeclimate_assemble_results
  service: YOURSERVICE
  command: codeclimate-assemble.sh
```

Inside the `codeclimate-assemble.sh` file, you will have:

```bash
cc-test-reporter sum-coverage --output - --parts $PARTS coverage/codeclimate.*.json | \
```

Note that you will need to manually `$PARTS` to reflect the number of parallel threads.

## Codeship Basic

### Adding Reporter ID

To start, you need to add your `CC_TEST_REPORTER_ID` to your to your project's [environment variables]({{ site.baseurl }}{% link _basic/builds-and-configuration/set-environment-variables.md %}).

You can do this by navigating to _Project Settings_ and then clicking on the _Environment_ tab.

### Project Configuration

Once your Code Climate project ID is loaded via your environment variables, you will want to install Code Climate via your [setup commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}):

```bash
curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > "${HOME}/bin/cc-test-reporter"
chmod +x "${HOME}/bin/cc-test-reporter"
```

Next, you will need to add special Code Climate commands before and after your [test commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}):

Before your tests:

```bash
cc-test-reporter before-build
```

After your final tests have run:

```bash
cc-test-reporter after-build --exit-code $ -prefix /home/rof/src/github.com/user_or_org_name/repo_name
```

The prefix here is what you'll need to remove from absolute paths in coverage payloads, to make them relative to the project root. This is usually the directory in which the tests were run.

### Parallel Test Coverage

Code Climate supports parallel test reports by uploading the partial result to an external service, such as S3.

In addition to the pre-test and post-test commands above, to use Code Climate with parallel reporting you will need to add another command at the end of your [test commands]({{ site.baseurl }}{% link _basic/quickstart/getting-started.md %}), in each [parallel pipeline]({{ site.baseurl }}{% link _basic/builds-and-configuration/parallel-tests.md %}) that you run tests in - as well as a new command at the end of your build.

Here are [Code Climate's example](https://github.com/codeclimate/test-reporter#low-level-usage) scripts for doing so.

At the end of each [parallel pipeline]({{ site.baseurl }}{% link _basic/builds-and-configuration/parallel-tests.md %}):

```bash
./cc-test-reporter format-coverage --output "coverage/codeclimate.$N.json"
aws s3 sync coverage/ "s3://my-bucket/coverage/$CI_COMMIT_ID"
```

Note that you will need to modify the S3 path (or provide an alternative storage path), as well as set the `$N` value value by manually declaring separate parallel test pipeline IDs.

At the end of your build itself, you will need to complete the parallel coverage reports in one of two ways.

- As a command, run via a the [custom-script deployment option]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %}). This means code coverage for parallel testing will only run on branches you have configured deployments.

- As an additional test step placed at the end of one of your parallel test pipelines. This method will require additional logic to be written to pause the script while it queries your external storage service for the existence of the appropriately-named coverage reports for all the additional pipelines, so that it doesn't erroneously combine coverage reports for pipelines that are still in progress.

The code to use to end the parallel coverage report is:

```bash
cc-test-reporter sum-coverage --output - --parts $PARTS coverage/codeclimate.*.json | \
```

Note that you will need to manually `$PARTS` to reflect the number of parallel threads.

All of these commands will work best when executed from script files.

## Common Issues

### Successful build, even though tests failed

Because of a bug with version 0.8.x of simplecov, tests are reported as successful, even though they actually failed. This is caused by simplecov overriding the exit code of the test framework.

According the the [issue report on GitHub](https://github.com/colszowka/simplecov/issues/281) this won't be fixed in the 0.8 release. Please either use versions prior to 0.8 or higher than 0.9.
