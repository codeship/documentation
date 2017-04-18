---
title: Continuous Delivery to Google Cloud Platform with Docker
weight: 46
tags:
  - deployment
  - heroku
  - docker

redirect_from:
  - /docker-integration/google-cloud/
---

<div class="info-block">
You can find a sample repo for deploying to Google Cloud with Codeship Pro on Github [here](https://github.com/codeship-library/google-cloud-deployment).
</div>

* include a table of contents
{:toc}

## Authentication

For authenticating with the Google Cloud Platform we're going to create a *Service account*.

Go to the [GCP console](https://console.developers.google.com), select your project and go to *APIs & auth* &rarr; *Credentials*:

![Google Cloud Platform Credentials View]({{ site.baseurl }}/images/docker/credentials-link.png)

Now click *Add credentials* and add a Service account. Select the JSON download option when asked on the next page. You will download a json file that contains credentials for authentication later. This configuration file and other parameters need to be put into an encrypted environment file that can be used as part of the build.

## Setting up the environment

We're going to create an environment configuration file that sets the following keys:

```bash
GOOGLE_AUTH_JSON=...
GOOGLE_AUTH_EMAIL=...
GOOGLE_PROJECT_ID=...
```

Store the json file you received from the GCP console into a file named *google_deployment.env* in your repository. Make sure to remove all newlines from the file. On Linux and OSX you can use `tr '\n' ' ' < google_deployment.env` to get the line and copy it back into the file. Then prepend the single line with `GOOGLE_AUTH_JSON=`. You can find the `GOOGLE_AUTH_EMAIL` on the credentials page in the *Service accounts* section. It has to be from the *Service account* we just created. The `GOOGLE_PROJECT_ID` can be found on the Dashboard of your project in the Google developer console. Make sure to put the file into .gitignore so its never committed with

```bash
echo 'google_deployment.env' >> .gitignore
```

Now you can encrypt the env file into a file called `google_deployment.env.encrypted`. Take a look at the [encrypted environment files tutorial]({{ site.baseurl }}{% link _pro/getting-started/environment-variables.md %}) to encrypt the file properly.

Now we're all set with the environment file and can set up our deployment script, codeship-services.yml and codeship-steps.yml.

## Deployment Script

Before calling any commands against the GCP API we need to authenticate with the gcloud tool. The authentication does not get persisted across steps, so we need to run the provided authentication command at the beginning of each step that wants to use the gcloud or kubectl tool.

The `codeship/google-cloud-deployment` container provides a deployment command called `codeship_google authenticate`. If you set up the environment variables as described above it will automatically read them and set the configuration up for you. The following example script runs the `codeship_google authenticate` command first and then interacts with the `gcloud` tool to deploy your application. You can use this script as a starting point to write your own deployment script and use it in the later stages.

```bash
#!/bin/bash

# Authenticate with the Google Services
codeship_google authenticate

# Set the default zone to use
gcloud config set compute/zone us-central1-a

# Starting an Instance in Google Compute Engine
gcloud compute instances create testmachine

# Stopping an Instance in Google Compute Engine
gcloud compute instances delete testmachine -q
```

We're first authenticating, then setting the default zone to use and then starting an instance in the Google Compute Engine. Add any commands you need for your specific deployment integration with the Google Cloud Platform. You can also take a look at a [longer example we use for integration testing our container](https://github.com/codeship-library/google-cloud-deployment/blob/master/test/deploy_to_google.sh).

Make sure to put it into your repository so we can later on use it inside the Docker container for deployment.

## Services

The `codeship-services.yml` file uses the `codeship/google-cloud-deployment` container, sets the encrypted environment file and adds the repository folder as a volume at `/deploy` so we can use it as part of the build.

```yaml
googleclouddeployment:
  image: codeship/google-cloud-deployment
  encrypted_env_file: test/google_deployment.env.encrypted
  add_docker: true
  volumes:
    - ./:/deploy
```

## Steps

In the steps we're now calling the deployment script we created before in `scripts/deploy_to_gcp.sh` in your repository. This will authenticate with GCP and then let you interact with any resources in the Google Cloud.

```yaml
- service: googleclouddeployment
  command: /deploy/test/deploy_to_google.sh
```

Now you have a working integration with the Google Cloud that will automatically update with the latest `codeship/google-cloud-deployment` container.

## Google Container Engine

Our container also works with the Google Container Engine and Container Registry. At first we will set up a [push step]({{ site.baseurl }}{% link _pro/getting-started/image-registries.md %}) to push a container to the registry. Then a script will authenticate with Google and interact with kubectl to start the service.

First we define the [dockercfg generator service]({{ site.baseurl }}{% link _pro/getting-started/image-registries.md %}) container in the ***codeship-services.yml*** file which will create temporary credentials for us. You can check out the code behind the container in the [codeship-library/gcr-dockercfg-generator](https://github.com/codeship-library/gcr-dockercfg-generator) repository. Make sure the environment variables mentioned above are set up in the encrypted_env_file.

```yaml
gcr_dockercfg:
  image: codeship/gcr-dockercfg-generator
  add_docker: true
  encrypted_env_file: environment.encrypted
```

Now we can reference the service in the push step configuration and set up the deployment to the Google Container Registry.

```yaml
- service: app
  type: push
  image_name: gcr.io/company_name/container_name
  registry: https://gcr.io
  dockercfg_service: gcr_dockercfg
# Set up script that interacts with Gcloud after the container push
- service: deployment
  command: /deploy/test/deploy_to_google.sh
```

Here is an example script you could use to interact with the Google Cloud registry.

```bash
#!/bin/bash

set -e

GOOGLE_CONTAINER_NAME=gcr.io/codeship-production/google-deployment-example
KUBERNETES_APP_NAME=google-deployment
DEFAULT_ZONE=us-central1-a

codeship_google authenticate

echo "Setting default timezone $DEFAULT_ZONE"
gcloud config set compute/zone $DEFAULT_ZONE

echo "Starting Cluster on GCE for $KUBERNETES_APP_NAME"
gcloud container clusters create $KUBERNETES_APP_NAME \
    --num-nodes 1 \
    --machine-type g1-small

echo "Deploying image on GCE"
kubectl run $KUBERNETES_APP_NAME --image=$GOOGLE_CONTAINER_NAME --port=8080

echo "Exposing a port on GCE"
kubectl expose rc $KUBERNETES_APP_NAME --create-external-load-balancer=true

echo "Waiting for services to boot"

echo "Listing services on GCE"
kubectl get services $KUBERNETES_APP_NAME

echo "Removing service $KUBERNETES_APP_NAME"
kubectl delete services $KUBERNETES_APP_NAME

echo "Waiting After Remove"

echo "Stopping port forwarding for $KUBERNETES_APP_NAME"
kubectl stop rc $KUBERNETES_APP_NAME

echo "Stopping Container Cluster for $KUBERNETES_APP_NAME"
gcloud container clusters delete $KUBERNETES_APP_NAME -q
```
