---
title: Dart
tags:
  - dart
  - languages

redirect_from:
  - /languages/dart/
---

* include a table of contents
{:toc}

## Versions And Setup

`$DART_SDK` is available in the Environment and included in the PATH. The installed version of the Dart SDK is `1.5.1`.

You can use these commands from the Dart SDK:

* Dart-to-JavaScript compiler (dart2js)
* Dart VM (dart)
* Dart package manager (pub)
* Dart Analyzer (dart_analyzer)

### Installing New Versions

If you want to use a newer Dart version than what is pre-installed on the build  machines, you can use the following script:

```shell
wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip
unzip -o dartsdk-linux-x64-release.zip -d ~
```

## Dependencies

You can install any dependencies you defined in your `pubspec.yaml` by running

```shell
pub get
```

### Dependency Cache

We do not cache Dart dependencies between builds.

## Notes And Known Issues

Due to Dart version and build issues, you may find it helpful to tests your commands with different versions via an [SSH debug session]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}) if tests are running differently on Codeship compared to your local machine.


## Frameworks And Testing

As dart currently doesn't have a default way to run your tests you can use exactly the same command to run those tests as you would on your local machine. Note that almost all tools that do not require root access for custom machine configuration will install and run without issue on Codeship.

### Browser testing

We automatically have `xvfb` running on our System. You can use Firefox, Chrome
or PhantomJS to run your Dart tests in a browser. You can read more in our
[Browser Testing Guide]({{ site.baseurl }}{% link _basic/continuous-integration/browser-testing.md %})


## Parallelization

In addition to parallelizing your tests explicitly [via parallel pipelines]({{ site.baseurl }}{% link _basic/getting-started/parallelci.md %}), some customers have found using Dart test runner's built-in test parallelization is a good way to speed up your tests.

Note that aggressive parallelization can cause resource and build failure issues, as well.
