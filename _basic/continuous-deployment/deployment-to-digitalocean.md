---
title: Deploy to DigitalOcean
layout: page
tags:
  - deployment
  - digital ocean

redirect_from:
  - /continuous-deployment/deployment-to-digitalocean/
---

* include a table of contents
{:toc}

## Different Ways to Deploy
DigitalOcean offers virtual servers (called Droplets).
There are various ways to deploy your application to DigitalOcean.

## Capistrano
If you have a Ruby on Rails Application the most common way to deploy to DigitalOcean is Capistrano.
Checkout our article on [Capistrano Deployment]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-capistrano.md %}) for that.

## SCP
A DigitalOcean droplet is very similar to a virtual server.
One way to deploy your application to DigitalOcean is to copy them via SCP to your Droplet.
Checkout our article on [SCP Deployment]({{ site.baseurl }}{% link _basic/continuous-deployment/deployment-with-ftp-sftp-scp.md %}) for that.
