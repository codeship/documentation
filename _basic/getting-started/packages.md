---
title: What's Intalled on Codeship Basic
weight: 97
tags:
- AMI
- continuous integration
- packages

---

* include a table of contents
{:toc}


<div class="info-block">
**current build: last edited on {{ site.data.basic.latest_update }}**
</div>

* include a table of contents
{:toc}

## Codeship Pre-Installed Packages And Tools

In a best effort to list everything installed on  our hosted Codeship Basic environment, we offer the following list of installed packages. While the list may not be fully complete at any given moment, we try our best to keep it comprehensive and up to date.

## Check For Packages Versions Via SSH Session

If you want to check for a certain package or see what the default version is for yourself, you can use the [SSH Debug session]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}) within your project and connect directly to our build machine.

![Open SSH Debug Session]({{ site.baseurl }}/images/basic/open_ssh.png)

Click on the link to open an SSH debug session. You will be provided with the username, server, and port which you can use to access the build machine. You will need an SSH key in your .ssh folder (default). For more information, please read our documentation on [SSH access]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}).

## Full list of installed packages
{% include basic/ami/{{ site.data.basic.ami_id }}/packages.md %}

## NodeJS versions available via nvm
{% include basic/ami/{{ site.data.basic.ami_id }}/node.md %}

## PHP Versions available via phpenv
{% include basic/ami/{{ site.data.basic.ami_id }}/php.md %}

## Ruby versions available via rvm
{% include basic/ami/{{ site.data.basic.ami_id }}/ruby.md %}
