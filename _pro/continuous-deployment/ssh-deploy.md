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
See the [example repo](https://github.com/codeship-library/docker-utilities/tree/master/ssh-helper) for a full example and further instructions on using SSH and SCP with Codeship Pro.
</div>

* include a table of contents
{:toc}

## Using SSH/SCP To Deploy

To deploy using SSH and SCP with Codeship Pro, you will need to create a container that can connect to your server via SSH. Then, you will pass this container the necessary deployment commands.

We provide a deployment container configured to making deploying with SSH and SCP via Docker in Codeship Pro easier to do. This example will use our prebuilt SSH helper configuration, but you do _not_ have to configure your builds this way or use our helper image, as long as you can build a container with the tooling that has access to your key.

## Configuring SSH/SCP

### SSH Helper Image

To get started deploying via SSH and SCP with Codeship Pro, first see our [SSH helper repo](https://github.com/codeship-library/docker-utilities/tree/master/ssh-helper). Clone this repo locally and build the helper image by running `docker build -t codeship/ssh-helper`.

### Creating Keys

Next, use the SSH helper image to create a new SSH key and write the key files to your current directory. The filenames will be `codeship_deploy_key` for the private key and `codeship_deploy_key.pub` for the public one. To create your keys, run the following command:

```
docker run -it --rm -v $(pwd):/keys/ codeship/ssh-helper generate "<YOUR_EMAIL>"
```

**Note** that you will want to insert your email address into the above command for the purposes of signing the key.

### Adding Your Key To Your Builds

To deploy with SSH or SCP on Codeship Pro, you'll need to load your SSH keys into your build via [environment variables]({% link _pro/builds-and-configuration/environment-variables.md %}) in your [codeship-services.yml file]({% link _pro/builds-and-configuration/services.md %}).

The following command will take the private key we generated above (`codeship_deploy_key`) and create a file to use in your Codeship builds, which will be named `codeship.env`:

```
docker run -it --rm -v $(pwd):/keys/ codeship/ssh-helper prepare
```

**Note** that once you have this file, you will most likely want to encrypt it using our [encrypted environment file method]({% link _pro/builds-and-configuration/environment-variables.md %}).

### Configuring Your Builds

Now that you've created and formatted your keys, you can add them ton your build. We will also be adding Codeship's prebuilt SSH helper image to assist with deployments, though this is not mandatory. This image is simply built with the SSH tooling installed, and you are welcome to build your own or to use any other image with the tooling you need.

In your [codeship-services.yml file]({% link _pro/builds-and-configuration/services.md %}), add the following:

```yaml
ssh:
  image: codeship/ssh-helper
  encrypted_env_file: codeship.env.encrypted
  volumes:
    - ./:/keys/

deployment:
  image: codeship/ssh-helper
  volumes:
    - .ssh:/root/.ssh
    - .:/app
```

Then, in your [codeship-steps.yml file]({% link _pro/builds-and-configuration/steps.md %}):

```yaml
# codeship-steps.yml
- name: Write Private SSH Key
  service: ssh
  command: write
```

This step is using the `ssh` service to process our keys and write them out to a host volume. Then, our `deployment` service can read the key from the volume and run SSH/SCP commands using this key.

### Deploying

After the configuration is complete, you can add SSH/SCP deploy commands to the [codeship-steps.yml file]({% link _pro/builds-and-configuration/steps.md %}):

```yaml
- name: Copy Files
  service: deployment
  command: scp -r /app/ user@myserver.com:app/
- name: Restart Server
  service: deployment
  command: ssh user@myserver.com restart_server
```

**Note** that in this configuration, it will read the SSH key from the volume as described above.

## Common Problems

### Authentication Failure

If your SSH authentication commands are failing, there are several troubleshooting steps to take.

- First, try connecting using that key locally to verify the key and the corresponding public key are configured and working as intended.

- Next, try running your deployments locally with [the local]() to see if you receive the same error messages.

- Often times these issues are related to character escaping or issues loading the key into the proper directory, so running `printenv` and `ls` commands will help you verify that the correct key has been loaded and that it is where you want it to be.
