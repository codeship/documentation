---
title: Deploying Via SSH With Docker
shortTitle: Deploying With SSH
menus:
  pro/cd:
    title: Deploy Via SSH
    weight: 14
tags:
  - docker
  - deployment
  - ssh key
  - encryption
  - ssh
  - rsync
  - public key
  - private key
  - sftp
  - linode
  - digital ocean
categories:
  - Continuous Deployment
---

<div class="info-block">
To follow this tutorial on your own computer, please [install the `jet` CLI locally first]({{ site.baseurl }}{% link _pro/jet-cli/usage-overview.md %}).
</div>

* include a table of contents
{:toc}

## Using SSH/SCP To Deploy

To deploy using SSH and SCP with Codeship Pro, you will need to create a container that can connect to your server via SSH. Then, you will pass this container the necessary deployment commands.

To do this you need to set up an encrypted SSH Key that is available as either a [build argument]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}) or as an [environment variable]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}). It will also need to be able to write to the `.ssh` folder.

## Configuring SSH Deployments

### Creating Your SSH Key

The first thing you will need to do is generate a usable SSH key locally. If you have an existing key, you can use it, or you can use the following recommended commands to generate the key:

```shell
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f keyfile.rsa
```

When you run this command, it will generate two files in your local repository: `keyfile.rsa` and `keyfile.rsa.pub`.

- `keyfile.rsa`  contains the private key that you will add to your repository so that it can be used by your Codeship Pro build containers to authenticate with your external servers. Note the instructions below for encrypting this file to keep it secure at all times.

- `keyfile.rsa.pub` is the corresponding public key, which you will add to all resources that your Codeship Pro builds will be attempting to authenticate with.

### Encrypting The Key

Now that the you have the `keyfile.rsa` file, you will need to encrypt this file into either a [encrypted build arguments file]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}) or an [encrypted environment variable file]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) to saved in your repository and used during your builds.

- If you only need the SSH key to be available at _runtime_ - that is, via your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) after all of your containers have built successfully - then you will need to create an [encrypted environment variable file]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}).

- If you only need the SSH key to be available at _buildtime_ - that is, via your Dockerfile as your containers build - then you will need to create an [encrypted build arguments file]({{ site.baseurl }}{% link _pro/builds-and-configuration/build-arguments.md %}).

**Note** that you may need the key as both a build argument and an environment variable, since build arguments are _only_ available via the Dockerfile and environment variables are _only_ available via the [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) after your containers have built.

Whether using build arguments or environment variables, you will need to be sure to replace newlines with `\n` so that the entire SSH key is in one line. For example:

```
PRIVATE_SSH_KEY=-----BEGIN RSA PRIVATE KEY-----\nMIIJKAIBAAKCFgEA2LcSb6INQUVZZ0iZJYYkc8dMHLLqrmtIrzZ...
```

And here is a `docker run` command that will do the work of replacing your newlines with `\n`

```shell
docker run -it --rm -v ${PATH_TO_PRIVATE_KEY}:/key alpine sed -E ':a;N;$!ba;s/\r?\n/\\n/g' /key
```

To encrypt your key and add it to your build process, follow the specific tutorials for either [build arguments]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) or [environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) using your escaped key.

You will ultimately add the encrypted  key to a service with the `encrypted_env_file` option or the `encrypted_args_file` option.

For example:

```yaml
app:
  build: .
    encrypted_args_file: sshkey.args.encrypted
```

or:

```yaml
app:
  build: .
  encrypted_env_file: sshkey.env.encrypted
```

### Loading The Key For Use

Before running any command that requires the SSH key to be available, make sure to run the following commands in that container.

These commands will load the SSH key into the required container directory so that is available for use. This will usually happen inside your Dockerfile, although in some cases it may happen with via a script in your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}):

```shell
mkdir -p "${HOME}/.ssh"
echo "${PRIVATE_SSH_KEY}" >> "${HOME}/.ssh/id_rsa"
```

**Note** that `${PRIVATE_SSH_KEY}` will change depending on what you have specifically named your build argument or environment variable.

### Deploying Your Code

Now you will need to connect VIA SSH and deploy you code. This is accomplished via standard SSH commands set up as steps in your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}).

```yaml
- service: ssh
  command: scp -rp . ssh_user@your.server.com:/path/on/server/
```

Note that the `service` references on the step will be whatever service you have set your key up in via your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

Also note that you may run your SSH commands separately, as individual steps, or you may group them together as a single script that you call:

```yaml
- service: ssh
  command: ssh-deploy.sh
```

## Common Problems

### Authentication Failure

If your SSH authentication commands are failing, there are several troubleshooting steps to take.

- First, try connecting using that key locally to verify the key and the corresponding public key are configured and working as intended.

- Next, try running your deployments locally with [the local]() to see if you receive the same error messages.

- Often times these issues are related to character escaping or issues loading the key into the proper directory, so running `printenv` and `ls` commands will help you verify that the correct key has been loaded and that it is where you want it to be.
