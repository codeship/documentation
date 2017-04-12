---
title: "Tutorial: Configure SSH Key Authentication"
layout: page
weight: 41
tags:
  - docker
  - tutorial
  - ssh key
  - encryption

redirect_from:
  - /docker/ssh-key-authentication/
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/getting-started/installation.md %}).
</div>

* include a table of contents
{:toc}

During your build you might want to access other repositories to pull in dependencies or push your code to other servers.

To do this you need to set up an encrypted SSH Key that is available as an environment variable and can be written to the `.ssh` folder.

We will walk you through an example that will set up a key, encrypt it and make it available during the build. For cloning from Github another option is to use their [OAuth Key instead of an SSH key](https://github.com/blog/1270-easier-builds-and-deployments-using-git-over-https-and-oauth).

## Create an SSH Key

The following command will create two files in your local repository. `keyfile.rsa` contains your private key that we will encrypt and put into your repository. This encrypted file will be decrypted on Codeship as part of your build. The second file `keyfile.rsa.pub` can be added to services that you want to access.

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f keyfile.rsa
```

Now you have to copy the content of `keyfile.rsa` into an environment file `sshkey.env`. Make sure to replace newlines with \n so the whole SSH key is in one line. The following is an example of ssh_key.env.

```bash
PRIVATE_SSH_KEY=-----BEGIN RSA PRIVATE KEY-----\nMIIJKAIBAAKCFgEA2LcSb6INQUVZZ0iZJYYkc8dMHLLqrmtIrzZ...
```

After preparing the `sshkey.env` file we can encrypt it with Jet. Follow the [encryption tutorial]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}) to turn the `sshkey.env` file into a `sshkey.env.encrypted` file.

You can then add it to a service with the `encrypted_env_file` option. It will be automatically decrypted on Codeship.

```yaml
app:
  build: .
  encrypted_env_file: sshkey.env.encrypted
```

## Setup during the build

Before running a command that needs SSH available make sure to run the following commands in that container. They will set up the SSH key so you can access external services.

```bash
mkdir -p "$HOME/.ssh"
echo -e $PRIVATE_SSH_KEY >> $HOME/.ssh/id_rsa
```
