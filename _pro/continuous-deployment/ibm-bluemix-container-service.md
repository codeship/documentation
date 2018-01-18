---
title: Continuous Delivery to IBM Cloud Container Service
shortTitle: Deploying To IBM Cloud Container Service
menus:
  pro/cd:
    title: IBM Cloud Container Service
    weight: 17
categories:
  - Continuous Deployment   
tags:
  - deployment
  - ibm
  - bluemix
  - bluemix container service
  - blue mix

---
<div class="info-block">
You can find a sample repo for deploying to IBM Cloud with Codeship Pro on Github [here](https://github.com/codeship-library/ibm-bluemix-utilities).
</div>

* include a table of contents
{:toc}

## Continuous Delivery To IBM Cloud Container Service

To make it easy for you to deploy your application to IBM Cloud Container Service, we’ve [built deployment images](https://github.com/codeship-library/ibm-bluemix-utilities) that have the IBM Cloud CLI installed and configured for use in the CI/CD process.

You will simply need to add one of the IBM deployment images as a service in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) so that you can run the commands you need.

## IBM Cloud Deployment Container

### Prerequisites

Prior to getting started, please ensure you have the following:

- [An Understanding Of Codeship Pro]({% link _pro/quickstart/getting-started.md %})
- [Codeship's Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) installed locally
- [Docker](https://www.Docker.com/products/overview)
- [An IBM Cloud Account](https://www.ibm.com/cloud-computing/bluemix/)
- An understanding of using IBM Cloud Container Service and the required manifest and database files for a Container Service application

### Authentication

To deploy to IBM, you will need to add the following values to your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) that you encrypt and include in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}):

- BLUEMIX_API_ENDPOINT
- BLUEMIX_CONTAINER_SERVICE_HOST
- BLUEMIX_CONTAINER_SERVICE_CLUSTER_NAME
- BLUEMIX_ORGANIZATION
- BLUEMIX_SPACE

These variables will be set on the [IBM deployment container](https://github.com/codeship-library/ibm-bluemix-utilities), which you can read more about below. This deployment container will use the environment variables as part of the authentication required by the IBM Cloud CLI when you run your deployment commands.

### Configuring Deployment Service

Once you have created your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}), you will want to add a new service to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

This file will use [the image Codeship maintains](https://github.com/codeship-library/ibm-bluemix-utilities) for IBM-based deployments, and will read your code from a volume connected to your primary service.

This service will be used for all of your Container Service deployment commands, and will use the [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) you created above.

```yaml
app:
  build:
    image: your-org/your-app
    path: .
    dockerfile_path: Dockerfile.app
  encrypted_env_file: ibm.env.encrypted
  volumes:
    - ./deployment/tests:/tests

dockercfg_generator:
  image: codeship/ibm-bluemix-dockercfg-generator
  add_docker: true
  encrypted_env_file: bluemix.env.encrypted

deployment:
  image: codeship/ibm-bluemix-deployment
  encrypted_env_file: ibm.env.encrypted
  volumes:
    - ./deployment/tests:/tests
  ```

## Container Registry

Using IBM Cloud Container Service usually involves pushing images to the IBM Cloud Container Registry as part of your CI/CD process.

We recommend reading [our guide for pushing to the IBM Cloud container registry]({{ site.baseurl }}{% link _pro/builds-and-configuration/image-registries.md %}#ibm-bluemix-registry), as the deployment commands below will feature an image push based on those instructions.

## Deploying Your App

Once you have added the deployment service to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}), you will now run Container Service deployment commands from your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) using that service to execute the commands.

Note that in this example, all of the Container Service deployment commands have been moved to a script file named `deploy_to_kubernetes.sh`. The reason it is named `deploy_to_kubernetes.sh` is because the IBM Cloud Container Service uses Kubernetes to orchestrate container deployments, so you will use Kubernetes commands in your deployment commands.

```yaml
- name: Push To IBM Cloud Container Registry
  service: app
  type: push
  image_name: registry.ng.bluemix.net/your-org/your-image
  registry: registry.ng.bluemix.net
  dockercfg_service: dockercfg_generator  

- name: IBM Cloud Container Service Kubernetes Deployment
  service: deployment
  command: /tests/deploy_to_kubernetes.sh
```

Inside the `deploy_to_kubernetes.sh` script, you will have something similar to:

```shell
#!/bin/bash

set -e

# login to IBM Cloud via credentials provided via (encrypted) environment
# variables
bluemix login \
  --apikey "${BLUEMIX_API_KEY}" \
  -a "${BLUEMIX_API_ENDPOINT}" \
  -o "${BLUEMIX_ORGANIZATION}" \
  -s "${BLUEMIX_SPACE}"

bluemix cs init \
  --host "${BLUEMIX_CONTAINER_SERVICE_HOST}"

# Get the required configuration for `kubectl` from Bluemix and load it
bluemix cs cluster-config \
  --export "${BLUEMIX_CONTAINER_SERVICE_CLUSTER_NAME}" \
  > .kubectl_config
source .kubectl_config && rm -rf .kubectl_config

# run the commands required to deploy the application via `kubectl`
kubectl version
kubectl cluster-info
```

## See Also

To learn more:

- [Visit the IBM Cloud Container Service documentation](https://console.bluemix.net/docs/)

- [View our example repository](https://github.com/codeship-library/ibm-bluemix-utilities)
