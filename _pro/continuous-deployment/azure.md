---
title: Continuous Delivery to Azure Container Service
shortTitle: Deploying To Azure Container Service
menus:
  pro/cd:
    title: Azure Container Service
    weight: 6
categories:
  - Continuous Deployment
tags:
  - aks
  - kubernetes
  - deployment
  - azure
  - microsoft
  - Docker

---
<div class="info-block">
You can find a sample repo for deploying to the Azure Container Service with Codeship Pro on Github [here](https://github.com/codeship-library/azure-utilities).
</div>

* include a table of contents
{:toc}

## Continuous Delivery To Microsoft Azure

To make it easy for you to deploy your application to Azure Container Service, we’ve [built deployment images](https://github.com/codeship-library/azure-utilities) that have the Azure Container Service CLI installed and configured for use in the CI/CD process.

You will simply need to add one of the Azure deployment images as a service in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) so that you can run the commands you need.

## Prerequisites

Prior to getting started, please ensure you have the following:

- [An Understanding Of Codeship Pro]({% link _pro/quickstart/getting-started.md %})
- [Codeship's Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) installed locally
- [Docker](https://www.Docker.com/products/overview)
- [An Azure Container Service account ](https://azure.microsoft.com/account/)
- An understanding of using Azure Container Service

## Authenticating With Azure

To deploy to the Azure Container Service, you will need to add the following values to your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) that you encrypt and include in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}):

- `AZURE_USERNAME` - Your Azure username
- `AZURE_PASSWORD` - The password associated with your Azure user

These variables will be set on the [Azure deployment container](https://github.com/codeship-library/azure-utilities), which you can read more about below. This deployment container will use the environment variables as part of the authentication required by the Azure Container Service when you run your deployment commands.

### Configuring Deployment Service

Once you have created your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}), you will want to add a new service to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

This file will use [the image Codeship maintains](https://github.com/codeship-library/azure-utilities) for Azure-based deployments, and will read your code from a volume connected to your primary service.

This service will be used for all of your Azure Container Service deployment commands, and will use the [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) you created above.

```yaml
app:
  build:
    image: your-org/your-app
    path: .
    dockerfile_path: Dockerfile.app
  encrypted_env_file: env.encrypted
  volumes:
    - ./:/code

azure_deployment:
  build:
    image: codeship/azure-deployment
    path: ./deployment
    dockerfile_path: Dockerfile
  environment:
    - AZURE_RESOURCE_GROUP=cs-k8s
    - AZURE_CLUSTER_NAME=cs-k8s-testing
  encrypted_env_file: aks.env.encrypted
  volumes_from:
    - app
```

## Azure Container Registry

Using Azure Container Service usually involves pushing images to the Azure Container Registry as part of your CI/CD process.

We recommend reading [our guide for pushing to the Azure Container Registry]({{ site.baseurl }}{% link _pro/builds-and-configuration/image-registries.md %}#azure-container-service), as the deployment commands below will feature an image push based on those instructions.

## Deploying Your App

### Azure Container Service

Once you have added the deployment service to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}), you will now run Azure Container Service deployment commands from your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) using that service to execute the commands.

Note that in this example, all of the Container Service deployment commands have been moved to a script file named `kubernetes.sh` because the Azure Container Service uses Kubernetes to manage your application.

```yaml
- name: Azure Container Service Deployment
  service: azure_deployment
  command: kubernetes.sh
```

Inside the `kubernetes.sh` script, you will have something similar to the commands below:

```shell
#!/bin/bash

set -e

: "${AZURE_USERNAME:?Need to set your AZURE_USERNAME}"
: "${AZURE_PASSWORD:?Need to set your AZURE_PASSWORD}"
: "${AZURE_RESOURCE_GROUP:?Need to set your AZURE_RESOURCE_GROUP}"
: "${AZURE_CLUSTER_NAME:?Need to set your AZURE_CLUSTER_NAME}"

echo "Logging into Microsoft Azure using credentials for ${AZURE_USERNAME}"
az login --username "${AZURE_USERNAME}" --password "${AZURE_PASSWORD}"

# Configure kubectl
echo "Configuring access for kubectl"
az aks get-credentials --resource-group "${AZURE_RESOURCE_GROUP}" --name "${AZURE_CLUSTER_NAME}"

# run the commands required to deploy the application via `kubectl`
kubectl version
kubectl cluster-info
```
