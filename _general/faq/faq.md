---
title: FAQ
layout: page
tags:
  - faq
category: FAQ
redirect_from:
  - /faq/root-level-access/
  - /classic/getting-started/root-level-access/
  - /faq/could-not-find-gemname-in-any-of-the-sources/
  - /general/projects/could-not-find-gemname-in-any-of-the-sources/
  - /troubleshooting/pending-step-in-cucumber-fails-build/
  - /faq/pending-step-in-cucumber-fails-build/
  - /general/projects/pending-step-in-cucumber-fails-build/
  - /troubleshooting/no-such-file-or-directory-config-yourconfigyml/
  - /faq/no-such-file-or-directory-config-yourconfigyml/
  - /general/projects/no-such-file-or-directory-config-yourconfigyml/
  - /troubleshooting/builds-are-not-triggered/
  - /faq/builds-are-not-triggered/
  - /general/projects/builds-are-not-triggered/
  - /troubleshooting/cant-find-file-in-repository/
  - /faq/cant-find-file-in-repository/
  - /general/projects/cant-find-file-in-repository/
---
* include a table of contents
{:toc}

## Why does Codeship need admin rights on my repository?
Unfortunately, the Version Control Systems (VCS - GitHub, Bitbucket, GitLab) do not allow for more fine-grained permissions. Write access is needed in order to add webhooks, fetch the list of users that are allowed to access your repository, and add SSH keys. Once this changes, we will make sure to update the permissions needed accordingly.

## Can I have sudo rights on the classic infrastructure?
Codeship does not allow root level access (i.e. commands run via `sudo`) on its hosted environment for security reasons. If you are looking to install a dependency that's not available via a language specific package manager (e.g. `gem`, `pip`, `npm` or a similar tool), please contact [support@codeship.com](mailto:support@codeship.com) or send us a message using our in-app messenger.

## Do you support native iOS/MacOS builds?
We do not support native iOS/MacOS builds, so we cannot provide testing for e.g. native iOS builds out of the box.

## What to do when I "could not find gemname in any of the sources"?
Sometimes you might see errors like the following:

```shell
Could not find safe_yaml-0.9.2 in any of the sources
```

Please make sure that the version of the gem you want to install there wasn't yanked from [Rubygems](http://rubygems.org/){:target="_blank"}.

## Why are my builds not triggered anymore?
Builds on Codeship are triggered via a webhook from your VCS. We add this hook to your repository when you configure the project on Codeship, but sometimes those settings get out of sync.

That's why we show the status of the webhook configuration on the _General_ page of your project settings.

![Hook Status and Project UUID]({{ site.baseurl }}/images/faq/hook_status_and_project_uuid.png)

**GitHub**

Make sure the _Codeship_ service is added under the _Webhooks & Services_ section of your repository settings. Also check that the UUID configured for the repository matches the one shown on the _General_ page of your project settings on Codeship.

![GitHub Service Configuration]({{ site.baseurl }}/images/faq/service_github.png)

**Bitbucket**

Make sure a webhook for Codeship is added under the _Webhooks_ section in the settings of your repository. Please also check the the UUID in the hook URL matches the UUID from your project. The hook URL itself should match the following pattern.

```
https://lighthouse.codeship.io/bitbucket/YOUR_PROJECT_UUID
```

![BitBucket Webhooks Configuration]({{ site.baseurl }}/images/general/bitbucket_webhooks.jpg)

**Issues with Codeship**

It also might be possible that there are issues on Codeship. Please check our [Codeship Status Page](http://codeshipstatus.com){:target="_blank"} or follow us on [@Codeship](https://twitter.com/codeship) for further information.

## What to do when I get the error: "No such file or directory config/your_config.yml"?
If it's a configuration file which you ignored in your repository, create a `your_config.yml.example` with data that works for your tests an add it to your repository. Then add the following command to your **setup commands** so the YAML file is properly set up.

```shell
# project settings > test settings > setup commands
cp your_config.yml.example your_config.yml
```

## Why can't my file in the repository be found, it's right there?
When you get an error indicating that a file can't be found but you are sure it exists in the repository it might be due to case sensitivity of the file system on our machines.

**OSX and case sensitive file systems**

By default OS X has a case insensitive file system, so *Testfile.xml* and *testfile.xml* are treated the same. Our Linux filesystem is case sensitive though, so those would be two different files and the commands won't find the file if you don't use the exact same file name in your code.

**Solution**

Whenever you see an error of a missing file make sure that the name of the file on disk and the name used in your code are exactly the same, with no case differences.

## What to do when a pending step in cucumber fails the build?
The cucumber option `--strict` fails the build if you have a pending or undefined step.

Take a look at the [cucumber documentation](https://github.com/cucumber/cucumber/wiki/Step-Definitions){:target="_blank"}
