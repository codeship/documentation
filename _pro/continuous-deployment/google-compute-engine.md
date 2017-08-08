---
title: Continuous Delivery to Google Compute Engine
shortTitle: Deploying To Google Compute Engine
menus:
  pro/cd:
    title: Google Compute Engine
    weight: 8
tags:
  - deployment
  - google
  - google cloud
  - google compute engine
  - compute engine
---

* include a table of contents
{:toc}

## Deploying To Google Compute Engine

To deploy to [Google Compute Engine](https://cloud.google.com/compute/), you will need to create a container that can authenticate with your Google Account, and with the appropriate Google product, as well as run the Google Cloud CLI to execute your intended commands.

We maintain an [example repository](https://github.com/codeship-library/google-cloud-deployment) with [an image stored on Dockerhub](https://hub.docker.com/r/codeship/google-cloud-deployment/) to simplify this process. You can copy setup instructions from this repo or reuse the Dockerfile, our [turnkey Google Cloud image](https://hub.docker.com/r/codeship/google-cloud-deployment/) or our [GCR authentication generator](https://hub.docker.com/r/codeship/gcr-dockercfg-generator/) simply by adding the necessary elements from our [Google Cloud repo](https://github.com/codeship-library/google-cloud-deployment) to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

## Authentication

To deploy to Compute Engine, you will need to define a Google _Service account_ as well as add your Google credentials to your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) so that the `gcloud` utility can authenticate approriately.

For full instructions, see the [authentication portion of our Google Cloud documentation]({{ site.baseurl }}{% link _pro/continuous-deployment/google-cloud.md %}#authentication).

### Codeship Public Key

Some Google Cloud services will require that you add your [Codeship public key]({{ site.baseurl }}{% link _general/projects/project-ssh-key.md %}) for authentication purposes.

**Note** that Google may fail authentication if you do not add the Google Cloud user the key is for to the end of the key. For example, if the Google Cloud user is `deploy@Codeship`, you will want to add `deploy@Codeship` to the end of the SSH key itself, otherwise Google will not load the key for the user appropriately.

## Commands And Deployments

### Creating Your Services

You will want to add a service which builds the [Google Cloud deployment image]((https://hub.docker.com/r/codeship/google-cloud-deployment/), which is maintained by Codeship, in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}). For example:

```yaml
googleclouddeployment:
  image: codeship/google-cloud-deployment
  encrypted_env_file: google-credentials.encrypted
  add_docker: true
  volumes:
    - ./:/deploy
```

**Note** that this example adds your Google Cloud account credentials as encrypted environment variables and mounts the repository as a [volume]({{ site.baseurl }}{% link _pro/builds-and-configuration/docker-volumes.md %}) to the `/deploy` folder inside the container so that it is usable as part of the build.

### Deployment Commands

After defining your authentication variables and your deployment service, you will want to run deployment commands via your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}).

Because each step runs in a separate group of containers, you will likely want to bundle you Google Cloud commands together in a script file that you add to your repository and call from a step:

```yaml
- name: google-cloud-deployment
  service: googleclouddeployment
  command: google-deploy.sh
```

Inside this deployment script will be all commands you want to run via the Google Cloud or Kubernetes CLI, both included in the [deployment image that we maintain]((https://hub.docker.com/r/codeship/google-cloud-deployment/).

Here is an example deployment script that you can use as a basis for your own deployments. Note that it authenticates at the top using the command discussed earlier.

```bash
#!/bin/bash

# Authenticate with the Google Services
codeship_google authenticate

# switch to the directory containing your app.yml (or similar) configuration file
# note that your repository is mounted as a volume to the /deploy directory
cd /deploy/

# deploy the application
gcloud compute copy-files "${LOCAL_PATH}" "${INSTANCE_NAME}:${REMOTE_PATH}"
```

Please see the [documentation for `gcloud compute copy-files`](https://cloud.google.com/sdk/gcloud/reference/compute/copy-files) on which options are available and how they affect the deployment.

## Deploying without the gcloud CLI

Since Google Compute Engine instances are regular VMs, you don't need the `gcloud` CLI to connect and deploy your application.

You can also add a SSH key pair to your Google account, and [apply this keypair to your Google Cloud project](https://cloud.google.com/compute/docs/instances/connecting-to-instance#generatesshkeypair). If you make the private key available to the deployment script, you can then use regular `ssh` and `scp` commands to copy files to your instances.

```bash
scp -i ~/.ssh/my-ssh-key "${LOCAL_PATH}" "${REMOTE_USERNAME}@${REMOTE_IP_ADDRESS}:${REMOTE_PATH}"
```

Please see our [article on SSH based deployments]({{ site.baseurl }}{% link _pro/continuous-deployment/ssh-deploy.md %})
