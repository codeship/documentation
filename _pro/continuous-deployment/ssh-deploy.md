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
See the [example repo](pending) for a full example and further instructions on using SSH and SCP with Codeship Pro.
</div>

* include a table of contents
{:toc}

## Using SSH/SCP To Deploy

To deploy using SSH and SCP with Codeship Pro, you will need to create a container that can connect to your server via SSH. Then, you will pass this container the necessary deployment commands.

We provide a deployment container configured to making deploying with SSH and SCP via Docker in Codeship Pro easier to do.

## Configuring SSH Deployments

### Deployment Container

To get started deploying via SSH and SCP with Codeship Pro, first see our [deployment container](pending) for use in your [codeship-services.yml file]({% link _pro/builds-and-configuration/services.md %}).

This container is an image we maintain that you can pull is an additional service in your build and is pre-configured to help streamline SSH authentication.

In your [codeship-services.yml file]({% link _pro/builds-and-configuration/services.md %}), add the following:

```yaml
ssh:
  image: codeship/ssh
  encrypted_env_file: codeship.env.encrypted
  volumes:
    - ./:/keys/
deployment:
  image: trsouz/ssh
  volumes:
    - .ssh:/root/.ssh
```

These new services will help you write and use an SSH key so that you can pass along SSH and SCP commands for your deployments.

### Creating SSH Key

Now that the service is defined, you will want to add a new step at the top of your [codeship-steps.yml file]({% link _pro/builds-and-configuration/steps.md %}) to create and write your private key to a volume for your deployment to use:

```yaml
# codeship-steps.yml
- name: Write Private SSH Key
  service: ssh
  command: write
```

### Using SSH and SCP

Once the key has been written, you can use that key to run standard ssh commands in your [codeship-steps.yml file]({% link _pro/builds-and-configuration/steps.md %}):

```yaml
- name: Copy Files
  service: deployment
  command: ssh user@myserver.com command
```

## Common Problems

### Authentication Failure

If your SSH authentication commands are failing, there are several troubleshooting steps to take.

- First, try connecting using that key locally to verify the key and the corresponding public key are configured and working as intended.

- Next, try running your deployments locally with [the local]() to see if you receive the same error messages.

- Often times these issues are related to character escaping or issues loading the key into the proper directory, so running `printenv` and `ls` commands will help you verify that the correct key has been loaded and that it is where you want it to be.
