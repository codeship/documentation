---
title: Continuous Delivery to Microsoft Azure with Docker
weight: 47
tags:
  - deployment
  - azure
  - microsoft
  - Docker


---
<div class="info-block">
You can find a sample repo for deploying to Microsoft Azure with Codeship Pro on Github [here](https://github.com/Codeship-library/azure-deployment).
</div>

* include a table of contents
{:toc}

## Continuous delivery to Azure with Docker

To make it easy for you to deploy your application to Azure we’ve built a container that has the AzureCLI installed. We will set up a simple example showing you how to configure any deployment to Azure.

## Codeship Azure deployment container

The Azure deployment container lets you plugin your deployment tools without the need to include that in the testing or even production container. That keeps your containers small and focused on the specific task they need to accomplish in the build. By using the Azure deployment container, you get the tools you need to deploy to any Azure service and still have the flexibility to adapt it to your needs.

We will use the [microsoft/azure-cli](https://hub.Docker.com/r/microsoft/azure-cli/) Docker image throughout the documentation to interact with various Azure services.

## Prerequisites

Prior to getting started, please ensure you have the following installed in your local linux/unix environment.

- [An Understanding Of Codeship Pro]({% link _pro/getting-started/getting-started.md %})
- [Codeship's Jet CLI]({% link _pro/getting-started/cli.md %})
- [Docker](https://www.Docker.com/products/overview)
- [A Microsoft Azure Account](https://azure.microsoft.com/)

## Using other tools

While the container we provide for interacting with Azure gives you an easy and straight forward way to run your deployments it is not the only way you can interact with Azure services. You can install your own dependencies, write your own deployment scripts, talk to the Azure API directly or bring 3rd party tools to do it for you. By installing those tools into a Docker container and running them you have a lot of flexibility in how to deploy to Azure.

## Authentication

Before setting up the `codeship-services.yml` and `codeship-steps.yml` file we’re going to create an encrypted environment file that contains a service principal, password, and tenant ID.

## Azure Authentication

Take a look at Codeship's [encrypted environment files documentation]({% link _pro/getting-started/environment-variables.md %}) and add a `azure.env.encrypted` file to your repository. The file needs to contain an encrypted version of the following file:

```
spn=service_principal_name
password=service_principal_password
tenant=azure_tenant_id
```

You can get the spn, password, and tenant ID from running the [Service Principal Creation Script](https://github.com/codeship-library/azure-deployment/blob/master/local_scripts/create_serviceprincipal.sh) on your local machine with Azure-Cli installed.

To learn more about the script, [click here](https://github.com/codeship-library/azure-deployment/blob/master/local_scripts/create_serviceprincipal.md).

## Virtual Machine Authentication

You will also need to create an encrypted environment file for the credentials to your Azure Docker Virtual Machine you will setup in the next step. We have generated a script to help you get started. You can run the [VM Credential Creation Script](https://github.com/codeship-library/azure-deployment/blob/master/local_scripts/create_vm_creds.sh) and it will generate something similar to the following:

```
adminusername=username_here
adminpassword=password_here
Auzre Deployment Service Definition and Examples
```

Before reading through the documentation, please take a look at the Services and Steps documentation page so you have a good understanding how services and steps on Codeship work.

The `codeship-services.yml` file uses the `microsoft/azure-cli` container and sets the encrypted environment file created by running the Service Principal Creation Script. Additionally, it sets the resource group name (`resource`) and location (`location`) through the environment config setting. We set up a [volume]({% link _pro/getting-started/docker-volumes.md %}) that shares `./` (the repository folder) to `/deploy`. This gives us access to all files in the repository in `/deploy/...` for the following deployment step.

Note: The following step only deploys out infrastructure in Azure with a pre-built Ubuntu 16.04 virtual machine and the Docker engine pre-configured.

```
azuredeployment:
  image: microsoft/azure-cli
  encrypted_env_file: azure.env.encrypted
  environment:
  - Resource=resource_group_name
  - Location=eastus
  volumes:
  - ./:/deploy
```

To interact with different Azure services you can simply call the Azure command directly. You can use any Azure service or command provided by the [AzureCLI](https://docs.microsoft.com/en-us/azure/xplat-cli-install). You can use [environment variables or command arguments](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates) to set the `Azure Datacenter Location` or other parameters.

Take a look at the [Steps documentation page](({% link _pro/getting-started/steps.md %})) so you have a good understanding how steps on Codeship work and how to set it up in your  `codeship-steps.yml`.

The following script will use the [Azure GitHub QuickStart Templates](https://github.com/Azure/azure-quickstart-templates) to deploy your new Docker virtual machine and resource group. The deployment script can access any files in your repository through `/deploy`. To confirm, the [Azure Deployment Script](https://github.com/codeship-library/azure-deployment/blob/master/deployment/azure_deploy.sh), stands up an AzureRM resource group with all necessary dependencies for an Ubuntu 16.04 image with Docker pre-installed.

Disclaimer: It is always recommended to read any script thoroughly before executing it in your environment. These scripts are provided for demo purposes only.

## Deploying Your App

Now that you can authenticate with Azure and build Azure infrastructure, you will want to deploy your application. There are multiple ways to do this, so we have sample projects showing two easy and popular deployment configurations:

- You can SSH into your Azure instance and either deploy your code as normal, without Docker, or run Docker commands to build your containers after copying your code. [See here for an example.](https://github.com/codeship-library/azure-deployment/tree/ssh_deploy)

- You can use Azure Container Service to deploy with Docker Swarm to Azure.[See here for an example.](https://github.com/codeship-library/azure-deployment/tree/acs-swarm)

- You can use Azure Container Service and Kubernetes to deploy to Azure. [See here for an example.](https://github.com/codeship-library/azure-deployment/tree/acs-kubernetes)

## See also

- [Create a Docker environment in Azure using the Docker VM extension](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-Dockerextension)
