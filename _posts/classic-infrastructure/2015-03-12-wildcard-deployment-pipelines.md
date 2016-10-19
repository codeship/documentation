---
title: Wildcard Deployments
layout: page
tags:
  - deployment
  - wildcard
categories:
  - classic-infrastructure
---

Get more flexible deployment workflows with wildcard deployment pipelines that trigger if a branch starts with a certain prefix. Use one deployment configuration for multiple branches and automatically deploy your feature, release, QA, etc. branches to the corresponding environments.

See our article on [deployment pipelines]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-pipelines %}) for a general introduction on how to use deployments on Codeship.

## Static Branch Deployment Pipelines

If you choose _Branch is exactly_ the branch name will need to match exactly the branch that is currently being tested for the deployment to be triggered.

## Wildcard Branch Deployment Pipelines

When you add a new branch to be deployed you can choose whether you are specifying an exact branch name or if this is a **wildcard deployment**. For the latter select _Branch starts with_ from the dropdown and then specify the common part of the branches you want to deploy.

![Wildcard Deployment Pipeline Configuration]({{ site.baseurl }}/images/continuous-deployment/wildcard_deployment_pipelines_configuration.png)

If, for example you want to deploy all branches starting with `feature/` to your staging environment you could add this as the branch name and the deployment would be triggered for any of the following branch names

* feature/wildcard-deployments
* feature/feature-b

But not for _feature-a_, as it is missing the _/_ at the end of `feature/`.

**Note**, if you have another wildcard deployment pipeline configured for `fe`, both the deployments (for `fe` as well as  `feature/`) will be triggered and run in sequence.

See the following screenshot for a comparison of a configured wildcard deployment pipeline (for _feature/_) to a static branch deployment pipeline (for _master_).

![Configured Wildcard Deployment Pipelines]({{ site.baseurl }}/images/continuous-deployment/wildcard_deployment_pipelines_finished.png)
