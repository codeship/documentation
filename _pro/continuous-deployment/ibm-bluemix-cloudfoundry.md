---
title: Continuous Delivery to IBM Cloud Foundry with Docker
shortTitle: Deploying To IBM Cloud Foundry
menus:
  pro/cd:
    title: IBM Cloud Foundry
    weight: 16
categories:
  - Continuous Deployment        
tags:
  - deployment
  - ibm
  - cloud foundry
  - bluemix
  - ibm cloud
  - blue mix

---
<div class="info-block">
You can find a sample repo for deploying to IBM Cloud with Codeship Pro on Github [here](https://github.com/codeship-library/ibm-bluemix-utilities).
</div>

* include a table of contents
{:toc}

## Continuous Delivery To IBM Cloud Foundry

To make it easy for you to deploy your application to IBM Cloud Foundry, we’ve [built deployment images](https://github.com/codeship-library/ibm-bluemix-utilities) that have the IBM Cloud CLI installed and configured for use in the CI/CD process.

You will simply need to add one of the IBM deployment images as a service in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}) so that you can run the commands you need.

## IBM Cloud Deployment Container

### Prerequisites

Prior to getting started, please ensure you have the following:

- [An Understanding Of Codeship Pro]({% link _pro/quickstart/getting-started.md %})
- [Codeship's Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) installed locally
- [Docker](https://www.Docker.com/products/overview)
- [An IBM Cloud Account](https://www.ibm.com/cloud-computing/bluemix/)
- An understanding of using IBM Cloud Foundry and the required manifest and database files for a Cloud Foundry application

### Authentication

To deploy to IBM, you will need to add authentication credentials to your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}), which you will encrypt and include in your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

For the example deployment in this documentation, we will add the following:

- BLUEMIX_API_ENDPOINT
- BLUEMIX_CONTAINER_SERVICE_HOST
- BLUEMIX_CONTAINER_SERVICE_CLUSTER_NAME
- BLUEMIX_ORGANIZATION
- BLUEMIX_SPACE

These variables will be set on the [IBM deployment container](https://github.com/codeship-library/ibm-bluemix-utilities), which you can read more about below. This deployment container will use the environment variables as part of the authentication required by the IBM Cloud CLI when you run your deployment commands.

You can name these variables anything you'd like depending on the specifics of your scripts, and different configurations may not require all of them to be used.

### Configuring Deployment Service

Once you have created your [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}), you will want to add a new service to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}).

This file will use [the image Codeship maintains](https://github.com/codeship-library/ibm-bluemix-utilities) for IBM-based deployments, and will read your code from a volume connected to your primary service.

This service will be used for all of your Cloud Foundry deployment commands, and will use the [encrypted environment variables]({{ site.baseurl }}{% link _pro/builds-and-configuration/environment-variables.md %}) you created above.

```yaml
app:
  build:
    image: your-org/your-app
    path: .
    dockerfile_path: Dockerfile.app
  encrypted_env_file: ibm.env.encrypted
  volumes:
    - ./deployment/tests:/tests

deployment:
  image: codeship/ibm-bluemix-deployment
  encrypted_env_file: ibm.env.encrypted
  volumes:
    - ./deployment/tests:/tests
  ```

## Deploying Your App

Once you have added the deployment service to your [codeship-services.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/services.md %}), you will now run Cloud Foundry deployment commands from your [codeship-steps.yml file]({{ site.baseurl }}{% link _pro/builds-and-configuration/steps.md %}) using that service to execute the commands.

Note that in this example, all of the Cloud Foundry deployment commands have been moved to a script file named `deploy_via_cloudfoundry.sh`.

```yaml
  - name: Cloud Foundry Deployment
    service: deployment
    command: /tests/deploy_via_cloudfoundry.sh
```

Inside the `deploy_via_cloudfoundry.sh` script, you will have something similar to:

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

# check that the CloudFoundry CLI is available via the IBM Cloud CLI wrapper
bluemix cf version

# list available CloudFoundry applications
bluemix cf apps

# push the application
bluemix cf push
```

**Note** that the specifics of your deployment scripts may vary depending on what you are trying to do, and the above is intended only as an example and a starting place.

## See Also

To learn more:

- [Visit the IBM Cloud Foundry documentation](https://console.bluemix.net/docs/)

- [View our example repository](https://github.com/codeship-library/ibm-bluemix-utilities)
