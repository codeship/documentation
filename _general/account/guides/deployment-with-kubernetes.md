---
title: Continuous Deployment With Docker, Kubernetes And Codeship Pro
weight: 48
tags:
  - kubernetes
  - notifications
  - deployment

---
<div class="info-block">
This was originally featured [as an eBook](https://resources.codeship.com/ebooks/deploy-docker-kubernetes-codeship-aw) in our[Resources Library](https://resources.codeship.com).
</div>

## What Is Kubernetes?

According to the official website, Kubernetes is a system that groups containers into logical units, which makes management of containers across multiple nodes "as simple as managing containers on a single system." Kubernetes essentially acts as a digital datacenter, allowing you to seamlessly manage hundreds of servers across as many nodes without ever having to step foot inside an overly air-conditioned clean room.

Beyond simply managing a complex container architecture, Kubernetes also packs some powerful automated deployment and scaling functionality, giving you the ability to roll out new code and resize your datacenter with minimal configuration.

Because Kubernetes introduces a relatively new way to interact with a cluster of containers, there are likely some new terms that I will mention in this article. These new terms can be very ambiguous when you're just starting out, so it is important to be aware of them early on. To help visualize the definition of each of these terms, we'll borrow a diagram from the Kubernetes documentation.

![Kubernetes Diagram]({{ site.baseurl }}/images/kubernetes/kubernetes-diagram.png)

In a nutshell, here's what this diagram is showing:

- A Cluster is a collection of physical and/or virtual machines called Nodes.

- Each Node is responsible for running a set of Pods.

- A Pod is a group of networked Docker-based containers.

Outside of the parent-child chain are **Deployments** (which we'll get to below) and **Services**. Services are logical sets of Pods with a defined policy by which to access them (read: microservice). A service can span multiple Nodes within a Kubernetes Cluster.

## Deployments (uppercase) vs. deployments (lowercase)

When it comes to actually launching containers, Kubernetes provides tools to automatically roll out new code by updating Deployment definitions. It is important to mention here that the word "Deployment" in Kubernetes-speak is really just a fancy (and a bit ambiguous) word for a recipe that describes how containers should be configured and launched. Because this article deals with delivering and launching updated Docker images to Kubernetes using Codeship, there is bound to be some confusion over terminology, so to keep things clear(ish) we'll be using the lowercase "deployment" to refer to the act of delivering product, and the uppercase "Deployment" to refer to the Kubernetes definition of the word.

In Kubernetes, updating a Deployment involves rolling out an updated Docker image to a previously defined Deployment. Kubernetes makes it clear in [their documentation](https://kubernetes.io/docs/user-guide/deployments/#updating-a-deployment) that an automated rollout to a Deployment is only triggered when the defined label or container image is updated, which means that simply updating a Docker image in the registry won't trigger a Deployment update unless we specifically tell it to. Don't worry if this seems a bit confusing at first, we'll be going into more detail about how this whole process works later.

We should point out that, even though Deployment updates need to be triggered in a specific way, there is very little risk of downtime in a multi-container environment. Thanks to the way Deployments are built, Kubernetes will ensure that no downtime is suffered by bringing down only a fraction of the Pods at a time. While the load won't necessarily be as efficiently distributed during these updates, the consumers of your application won't suffer any outages.

## Integrating Codeship with Kubernetes

So, given a functioning Kubernetes Deployment, how do we integrate it in to your Codeship work now? The answer to this question ultimately depends on your Kubernetes host, but because the official documentation uses [Google Cloud](https://documentation.codeship.com/pro/continuous-deployment/google-cloud/) as an example, this is the platform we'll address. To make this easier we've built out some Google Cloud integrations into Codeship Pro that we can use to authenticate and deploy new images to Google Cloud.

Before we can do anything, however, we need to create an encrypted environment file using the [Jet CLI]({% link _pro/getting-started/cli.md %}) tool in order to authenticate to Google Cloud. We have a [documentation article](https://documentation.codeship.com/pro/getting-started/encryption/) on how to do this, so we won't go over it here - but the environment variables that need to be set are:

- a Google Cloud Key – `GOOGLE_AUTH_JSON`
- a Google Authentication Email – `GOOGLE_AUTH_EMAIL`
- a Google Project ID – `GOOGLE_PROJECT_ID`

Once we have an encrypted environment file (and have saved your Google Cloud environment variables to `gc.env.encrypted`), we next need to define the Google Cloud service in the `codeship-services.yml` file.

```
google_cloud_deployment:
  image: codeship/google-cloud-deployment
  add_docker: true
  encrypted_env_file: gc.env.encrypted
  volumes:
    - ./:/deploy

gcr_dockercfg:
  image: codeship/gcr-dockercfg-generator
  add_docker: true
  encrypted_env_file: gc.env.encrypted
```

Notice that there are two services defined, rather than one. This is because one is for interacting with Google Cloud services ( `google_cloud_deployment` ), while another is used to enable Docker image push functionality to the Google Cloud Registry ( `gcr_dockercfg` ). This is only half of the puzzle, however, because although it creates the necessary services for interacting with Google Cloud, it doesn't automatically deploy newly built images or update a Kubernetes Deployment.

## Google Container Registry Pushing

Your `codeship-steps.yml` file supports `push` steps, to make pushing Docker images to a remote registry more efficient. We'll use a `push` step to push to your Google Container Registry account.

Using the `gcr_dockercfg` service defined above, all we need to do is add a step to the `codeship-steps.yml` file with your Google Container Registry URL as the destination. It's important to remember here that we will be deploying your application image, so be sure to replace the app service name with the name of the service your own application is running on.

```
- service: app
  type: push
  image_name: gcr.io/project-name/app-name
  registry: https://gcr.io
  dockercfg_service: gcr_dockercfg
```

The parameters above should be pretty self-explanatory, but the basic idea is that the `app` image gets pushed up to the Google Container Registry using the previously defined `gcr_dockercfg` service for authentication.

While this step does push updated images to the registry, there is a problem with it as currently defined. Without a set Docker image tag, we will push updated images to the `latest` tag by default. Now, this isn't a bad thing in and of itself (in fact, it's expected), but in order to trigger automatic Kubernetes Deployment updates, we need to be able to set a distinct `tag` for each push.

To accomplish this, we provide an `image_tag` declaration that allows you to set any tag other than `latest` to push your image up to. We also provide a list of variables that can be dynamically used for this declaration; however, to keep things simple, lets use the current build's Unix timestamp because it is relatively unique and repeatable. With the new `image_tag` declaration, the previous step should now look like this:

```
- service: app
  type: push
  image_name: gcr.io/project-name/app-name
  image_tag: "{% raw %}{{ .Timestamp }}{% endraw %}"
  registry: https://gcr.io
  dockercfg_service: gcr_dockercfg
```

Now, when we push up your app image to the Google Container Registry, it will be tagged with the current build's Unix timestamp.

## Updating Kubernetes Deployments

Once your `push` step is defined, we need to tell Kubernetes to update the appropriate Deployment to roll out the new image. This is where the previously defined `google_cloud_deployment` service comes into play. Thanks to this service, we are able to easily run authenticated commands against Google Cloud Platform without any additional overhead, which means that manipulating your Kubernetes platform from within Codeship is no different than working with it directly.

Before we set up the actual step, though, let's take a look at how updating a Kubernetes Deployment actually works. According to the Kubernetes documentation (and as touched upon above), triggering a Deployment update is as simple as updating the Deployment's defined label or container image. For now, let's assume that we already have a defined Deployment for an Nginx server as per the documentation. All we have to do to roll out an updated Docker image to the Deployment is to change the defined image using the `kubectl` command like so:

```
$ kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1 deployment "nginx-deployment" image updated
```

Because we tagged your image pushes above, this type of update will be relatively easy for us to set up. But, this is just a command – it doesn't show us how to actually update Deployments from your build. All it takes to accomplish this is a small script to run the few necessary commands to authenticate to the Google Cloud Platform and trigger a Kubernetes Deployment update.

Now, the script we need to write consists of only a small handful of commands:

```
#!/bin/bash
set-e

# authenticate to google cloud
codeship_google authenticate

# set compute zone
gcloud con g set compute/zone us-central1-a

# set kubernetes cluster
gcloud container clusters get-credentials cluster-name

# update kubernetes Deployment
GOOGLE_APPLICATION_CREDENTIALS=/keycon g.json kubectl set image deployment/
deployment-name app=gcr.io/project-name/app-name:$CI_TIMESTAMP
```

You can find the complete repository including the `codeship-steps.yml` and the `codeship-services.yml` files here: [https://github.com/codeship/codeship-kubernetes-demo](https://github.com/codeship/codeship-kubernetes-demo)

Let's step through the above script really quick. The first important command is the authentication piece. The `google_cloud_deployment` service needs to be authenticated with the Google Cloud Platform before we can run any commands. Since we set up the necessary environment variables already, all it takes to authenticate is to run the `codeship_google authenticate` command at the beginning of your script.

Next, we need to set the compute zone. This example shows `us-central1-a`, but you should change this to suit your needs. The next set of commands is the actual Kubernetes interactions. The first sets the Kubernetes cluster that we need to interact with, while the second is the actual Deployment update command. As you can see, it's not very different from the example provided by Kubernetes itself.

It's important to note here that Codeship provides an environment variable of the current build's timestamp, which allows us to correlate the Kubernetes command with the registry push step above.

Now that we have your deployment script set up (I've saved mine to the root of my project as `deploy.sh`), all we have left to do is to add a step to the `codeship-steps.yml` file that calls it:

```
- service: google_cloud_deployment
  command: /deploy/deploy.sh
```

## To Learn More

[Get stared with Codeship Pro.]({% link _pro/getting-started/getting-started.md %})=
