---
title: Codeship Security Information
layout: page
tags:
  - security
  - gpg key

redirect_from:
  - /security/
  - /security/security/
---
We fully understand and recognize, that the security of your source code and configuration data is important, as it forms the base of your and our endeavors. Therefore we put a lot of effort and thought into providing a secure infrastructure for you to use.

* include a table of contents
{:toc}

## System Security Overview

For every project you add to Codeship we create an SSH Key that is itself encrypted strongly and only decrypted shortly before being used in the build virtual machine. For every build we start a new and clean virtual machine. All changes you make (including file system changes) are stored in a ramdisk which is removed as soon as your build finishes (tests and deployment). None of your data is ever stored on any hard drive on our build servers.

All communication between your browser and our website is SSL encrypted, as is all communication to our Openredis queue. All communication to the build virtual machines is done over SSH.

## Can Codeship Read My Code?

On Codeship Basic, with permission our support team can open an SSH debug session in to your build machine which allows us to see your source code.

On Codeship Pro, we have no direct access to your source control but our support team can see your builds and build logs, as well as account information.

## What Kind Of Access To My SCM Does Codeship Need?

To run your tests, we need to check out your code from your source code provider. Currently we support GitHub, GitLab, and Bitbucket. You can sign up for the Codeship via Email as well but as soon as you connect a repository with your Codeship account you are telling your source code provider that you allow us to check out your private repositories.

You can revoke permission in your source code provider settings and by removing the Codeship's deploy keys and service hooks from your projects' configuration pages.

## What Services Does Codeship Use?

Our whole infrastructure is based on Amazon EC2 or services built on top of it. EC2 is one of the most trusted, tried and tested hosting services out there. The services we use are:

* Amazon EC2
* Heroku
* Openredis

Additionally for collecting Metrics (but without any sensitive data) we use

+ Google Analytics
+ Mixpanel
+ Intercom
+ Google Docs
+ Source code access

As outlined in our Terms of Service we only access your source code for a build or support request. We do not have any way to access your repository outside of our build environment.

## How Does Codeship Back Up Data?

Codeship never takes ownership of a customer's files, with the exception of opt-in image caching on Codeship Pro. However, all Codeship file storage and backup is held in an encrypted state off-site.

## Does Codeship Conduct External Security Audits?

Yes, from time to time Codeship will hire external parties to examine and audit current security practices.

## Does Codeship Use External Contractors?

For various roles, Codeship will hire part-time workers or 3rd party contractors. All employees - full time, part time or external - are given appropriately limited resource access and security requirements.

## Does Codeship Have A Security Audit?

We have a more detailed security checklist available on request. [Get in touch](mailto:security@codeship.com) if you need more information.

## How Can I Get In Touch About Security?

If you have any further questions you can send an email to [contact@codeship.com](mailto:security@codeship.com).

If you want to contact us regarding a security issue please send an email to [security@codeship.com](mailto:security@codeship.com) instead. You can encrypt it with [Codeship's PGP Key]({{ site.baseurl }}/codeship.asc).
