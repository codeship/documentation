---
title: Project SSH Key
weight: 93
tags:
  - project settings
  - ssh key
  - faq

redirect_from:
  - /continuous-integration/where-can-i-find-the-ssh-public-key-for-my-project/
  - /general/projects/where-can-i-find-the-ssh-public-key-for-my-project/
---
For communication between your Codeship project and outside via SSH, you will need your project's SSH public key which you can find in the Codeship dashboard.

* Open the project navigation on top of the page.
* Click on the settings icon next to the respective project.
* On the **General** tab of your project settings you will find your SSH public key.

![SSH Public Key]({{ site.baseurl }}/images/general/sshpublickey.png)

If you need more information on how to use SSH and similar tools, see [Deployment via FTP, SFTP, SCP, RSYNC, and SSH]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-ftp-sftp-scp.md %}).

## Use Case Examples
* You are deploying to one of your own servers instead of using Codehip's integrations to services like AWS, Heroku, and more.
* Your deployment script has a few more commands you want to be executed and you want to deploy to another service directly.
* You are using SSH tunnels to connect to your database within your tests.
