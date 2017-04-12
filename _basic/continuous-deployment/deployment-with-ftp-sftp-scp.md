---
title: Deploy via FTP, SFTP, SCP, RSYNC, and SSH
weight: 4
tags:
  - deployment
  - ftp
  - scp
  - rsync

redirect_from:
  - /continuous-deployment/deployment-with-ftp-sftp-scp/
---

* include a table of contents
{:toc}

<div class="info-block">
  You might also want to check out these related articles:
  * [Codeship public SSH key]({{ site.baseurl }}{% link _general/projects/project-ssh-key.md %})
  * [Deployment via Custom Script]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-custom-scripts.md %})
</div>

After your code passed through the pipeline successfully, the last step in your CI chain is deploying your code. You're either using one of our many integrations or deploying with your own script. If you're using your own means of deployment, we recommend tools like rsync, [Capistrano (Ruby)](http://capistranorb.com/), [Rocketeer (PHP)](http://rocketeer.autopergamene.eu/), [Deployer (PHP)](https://deployer.org/), or [Fabric (Python)](http://www.fabfile.org/).

Generally, we advise on using any SSH-based tool over FTP since the latter is not encrypted and transmits plain-text. If security is of any concern to you, one of the first steps is to use SSH when you're deploying without a tool.

Our recommendation if you do not want to use a deployment tool or one of our integrations is the following:

1. Add the Codeship public key to your `~/.ssh/authorized_keys` file, see [Authenticating via SSH Public Keys](#authenticating-via-ssh-public-keys).
2. Create a deployment script, see [Run commands on a remote server via SSH](#run-commands-on-a-remote-server-via-ssh). At the very least, you will have to copy all files needed by your application to the server and start the services needed by your application.

<div class="info-block">
When Codeship checks out your repository, we clone it to a folder called `clone` directly beneath the home directory. So when you see references to `~/clone/` folder, we talk about our local copy of your repository.
</div>

**Table of Contents**
* include a table of contents
{:toc}

## Authenticating via SSH public keys

All of the methods below can use key-based authentication. As this does not require you to provide your account password to Codeship, we strongly advise to configure this.

You need to add the [Codeship public SSH key]({{ site.baseurl }}{% link _general/projects/project-ssh-key.md %}) for your project to the `~/.ssh/authorized_keys` file on your server. Below are the commands you need to prepare everything and open an editor window where you can simply paste your key and save the file. Please run those commands via an SSH session on your server.

```shell
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
chmod -R go-rwx ~/.ssh/

# add the Codeship public SSH key to ~/.ssh/authorized_keys
nano ~/.ssh/authorized_keys
```
In the above example, we use `nano` to paste the public SSH key, but you might use any editor like `vi` or others that are installed on your server.

See [Run commands on a remote server via SSH](#run-commands-on-a-remote-server-via-ssh) on how to run commands on a remote server when building your application on Codeship.

## Run commands on a remote server via SSH

If you give a command as the last parameter to SSH it will run this command on the server and exit with the return status of that command. This can be used to start services or trigger a deployment on an external system.

To restart _Apache_ on a remote server, you could call the following command. (This would require the _deploy_ user to be able to call `sudo` without a password.)

```shell
ssh deploy@your.server.com 'sudo service apache restart'
```

`deploy` is the username that you are using on the deployment server and `your.server.com` is the IP or domain name of the server you want to deploy to.

## Continuous Deployment with SCP

SCP allows you to copy files from your local system to another server. With the `-r` option
you can also recursively upload directories. You can read more about the different options
in the [SCP man page]({% man_url scp %}).

For the [branch you want to deploy]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}) you create a script deployment that contains:

```shell
scp -rp ~/clone/* ssh_user@your.server.com:/path/on/server/
```

Make sure you add the [SSH key of your project]({{ site.baseurl }}{% link _general/projects/project-ssh-key.md %})
into your servers `~/.ssh/authorized_keys` file.

## Continuous Deployment with RSYNC

Rsync is an amazing tool to sync your local filesystem with an external server. Rsync
will check the files and only upload files that have changed.

For the [branch you want to deploy]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}) you create a script deployment that contains the following code.

```shell
rsync -avz ~/clone/ ssh_user@your.server.com:/path/on/server/
```

Or you can also run rsync over ssh.

```shell
rsync -avz -e "ssh" ~/clone/ ssh_user@your.server.com:/path/on/server/
```

You can read more about the Rsync options in the [Rsync man page]({% man_url rsync %}).

## Continuous Deployment with SFTP

SFTP supports FTP-like commands over an encrypted SSH session. You can automate SFTP by creating a batch file and handing it to SFTP. The batch file can contain any commands documented in the interactive commands section of the [SFTP man page]({% man_url sftp %}).

We will deploy the complete repository contents onto a remote server. Please add a file containing the following directives to your repository. You can name it any way you like. In our case we will call it _production_ and store it in a subdirectory called _deploy_.

```shell
put -rp /home/rof/clone /path/on/server/
```

For the [branch you want to deploy]({{ site.baseurl }}{% link _basic/getting-started/deployment-pipelines.md %}) you create a script deployment that contains:

```shell
sftp -b deploy/production ssh_user@your.server.com
```

* Make sure you add the [SSH key of your project]({{ site.baseurl }}{% link _general/projects/project-ssh-key.md %}) into your servers ***authorized_keys*** file.
* Also make sure your _remote directory_ already exists before running your first deployment.

## Continuous Deployment with FTP

For ftp we recommend using `lftp` for uploading your files. The following section will help you get started.

To keep your password out of your build logs, add it as an environment variable in your project configuration

```shell
FTP_PASSWORD
FTP_USER
```

So if you wanted to copy all of your repository to a remote server, you could add the following command to a _script deployment_ on the branch you want to deploy.

* Make sure your _remote dir_ does not end with a slash unless you want your copy to live in a subdirectory called _clone_.
* Also make sure your _remote dir_ already exists before trying your first deployment.

```shell
lftp -c "open -u $FTP_USER,$FTP_PASSWORD ftp.yoursite.com; set ssl:verify-certificate no; mirror -R ~/clone/ /path/on/server/"
```

For more information on using _lftp_ please see the [LFTP man page]({% man_url lftp %}) available online.
