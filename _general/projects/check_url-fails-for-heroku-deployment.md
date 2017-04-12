---
title: check_url fails for Heroku deployment
layout: page
tags:
  - faq
  - build error
  - heroku

redirect_from:
  - /faq/check_url-fails-for-heroku-deployment/
---
After each deployment we check if your app is up. Therefore we call (`wget`) either the default `*.herokuapps.com` URL or the URL you specified here.

If the build fails during `check_url YOUR_URL` it's usually because your application does not respond with a HTTP/2xx status code at the URL you provided (or the default URL for the deployment if you didn't provide any).

## Solutions

* Respond with a HTTP/200 status code at the root of your application.
* Configure a URL that will respond with such an status code in the advanced deployment configuration.
* Enter a generic URL(e.g. `http://google.com`) in the deployment configuration if you want to _disable_ the check entirely.
