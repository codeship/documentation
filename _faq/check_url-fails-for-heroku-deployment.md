---
title: check_url fails for Heroku deployment
layout: page
tags:
  - faq
  - build error
  - heroku
---
After each deployment we check if your app is up. Therefore we call (```wget```) either the default ```*.herokuapps.com``` URL or the URL you specified here.

If the build fails during ```check_url YOUR_URL``` it's usually because of these reasons:
+ Your app does not respond with HTTP status code 200 at your root path.
+ An application error occurred.

## Solutions
+ Respond with *anything* (HTTP status code 200) on your root path.
+ Enter a URL that's supposed to be available all the time into the heroku deployment configuration, for example http://google.com.
