---
title: Deploy to DigitalOcean
layout: page
tags:
  - deployment
  - digital ocean
categories:
  - classic-infrastructure
---
## Different Ways to Deploy
DigitalOcean offers virtual servers (called Droplets).
There are various ways to deploy your application to DigitalOcean.

## Capistrano
If you have a Ruby on Rails Application the most common way to deploy to DigitalOcean is Capistrano.
Checkout our article on [Capistrano Deployment]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-with-capistrano %}) for that.

## SCP
A DigitalOcean droplet is very similar to a virtual server.
One way to deploy your application to DigitalOcean is to copy them via SCP to your Droplet.
Checkout our article on [SCP Deployment]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-with-ftp-sftp-scp %}) for that.
