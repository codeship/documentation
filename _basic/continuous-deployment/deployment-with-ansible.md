---
title: Deploy via Ansible
layout: page
published: false
tags:
  - deployment
  - ansible

---

* include a table of contents
{:toc}

Ansible is fully supported on the Codeship.

## Install ansible
To install ansible run

```shell
pip install ansible
```

as part of your setup commands. We will cache ansible for your next build so the install task should be faster.

## Run ansible in Script Deployment
To deploy with Ansible, set up a Script Deployment and run exactly the same Ansible commands you would use to deploy from your local machine.

## Install SSH Key on your server
To be able to SSH into your servers, make sure you've set up your SSH public key as an authorized key on your servers.
