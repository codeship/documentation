---
title: Deploy via FTP, SFTP, SCP, RSYNC and SSH
weight: 55
tags:
  - deployment
  - ftp
  - scp
  - rsync
categories:
  - continuous-deployment
---
We generally advise to use any SSH based tools like SFTP or SCP for deployment and only use FTP if not possible otherwise.

When we checkout your repository we clone it to a folder called `clone` directly beneath the home directory. So when you see references to `~/clone/` folder, we talk about our local copy of your repository.

* include a table of contents
{:toc}

## Continuous Deployment with FTP

For ftp we have recommend using `lftp` for uploading your files. The following section will help you get started.

To keep your password out of your build logs, add it as an environment variable in your project configuration

```shell
FTP_PASSWORD="your_ftp_password"
FTP_USER="ftp_user"
```

So if you wanted to copy all of your repository to a remote server, you could add the following command to a _script deployment_ on the branch you want to deploy.

* Make sure your _remote dir_ does not end with a slash unless you want your copy to live in a subdirectory called _clone_.
* Also make sure your _remote dir_ already exists before trying your first deployment.

```shell
lftp -c "open -u $FTP_USER,$FTP_PASSWORD ftp.yoursite.com; set ssl:verify-certificate no; mirror -R ~/clone/ /remote/dir"
```

For more information on using _lftp_ please see the [LFTP man page]({% man_url lftp %}) available online.

## Authenticating via SSH public keys

All of the methods below can use key based authentication. As this does not require you to provide your account password to Codeship, we strongly advise to configure this.

You need to add the [Codeship public SSH key]({{ site.baseurl }}{% post_url continuous-integration/2014-09-03-where-can-i-find-the-ssh-public-key-for-my-project %}) for your project to the `~/.ssh/authorized_keys` file on your server. Below are the commands you need to prepare everything and open an editor window where you can simply paste your key and save the file. Please run those commands via an SSH session on your server.

```shell
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
chmod -R go-rwx ~/.ssh/

# add the Codeship public SSH key to ~/.ssh/authorized_keys
editor ~/.ssh/authorized_keys
```

See [Run commands on a remote server via SSH](#run-commands-on-a-remote-server-via-ssh) on how to run commands on a remote server when building your application on Codeship.

## Continuous Deployment with SFTP

SFTP supports FTP like commands over an encrypted SSH session. You can automate SFTP by creating a batchfile and handing it to SFTP. The batchfile can contain any commands documented in the interactive commands section of the [LFTP man page]({% man_url sftp %}).

As with the the FTP example above, we will deploy the complete repository contents onto a remote server.

Please add a file containing the following directives to your repository. You can name it any way you like. In our case we will call it _production_ and store it in a subdirectory called _deploy_.

```ftp
mkdir /path/on/server
put -rp ~/clone/* /path/on/server/
```

For the [branch you want to deploy]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-pipelines %}) you create a script deployment that contains:

```shell
sftp -b deploy/production ssh_user@your.server.com
```

Make sure you add the [SSH key of your project]({{ site.baseurl }}{% post_url continuous-integration/2014-09-03-where-can-i-find-the-ssh-public-key-for-my-project %})
into your servers ***authorized_keys*** file.

## Continuous Deployment with SCP

SCP allows you to copy files from your local system to another server. With the `-r` option
you can also recursively upload directories. You can read more about the different options
in the [LFTP man page]({% man_url scp %}).

For the [branch you want to deploy]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-pipelines %}) you create a script deployment that contains:

```shell
scp -rp ~/clone/* ssh_user@your.server.com:/path/on/server/
```

Make sure you add the [SSH key of your project]({{ site.baseurl }}{% post_url continuous-integration/2014-09-03-where-can-i-find-the-ssh-public-key-for-my-project %})
into your servers `~/.ssh/authorized_keys` file.

## Continuous Deployment with RSYNC

Rsync is an amazing tool to sync your local filesystem with an external server. Rsync
will check the files and only upload files that have changed.

For the [branch you want to deploy]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-pipelines %}) you create a script deployment that contains the following code.

```shell
rsync -av ~/clone/ ssh_user@your.server.com:/path/on/server/
```

Or you can also run rsync over ssh.

```shell
rsync -avz -e "ssh" ~/clone/ ssh_user@your.server.com:/path/on/server/
```

You can read more about the Rsync options in the [Rsync man page]({% man_url rsync %}).

## Run commands on a remote server via SSH

If you give a command as the last parameter to SSH it will run this command on the server and exit with the return status of that command. This can be used to start services or trigger a deployment on an external system.

To restart _Apache_ on a remote server, you could call e.g. the following command. (This would require the _deploy_ user to be able to call `sudo` without a password though.)

```shell
ssh deploy@your.server.com 'sudo service apache restart'
```
