---
title: Deploy to Heroku
weight: 90
layout: page
tags:
  - deployment
  - heroku
categories:
  - continuous-deployment
---
## Settings
Within Codeship you are able to configure [Deployment Pipelines]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-pipelines %}). You can easily add a Heroku Deployment choosing Heroku as deployment method.

You are asked to enter the **name of your Heroku application** and your **Heroku API key**. You need to create the application on Heroku first.

By clicking on **more options** you can configure additional settings.

### URL of your Heroku Application
After each deployment we check if your app is up. Therefore we call (```wget```) either the default ```*.herokuapp.com``` URL or the URL you specified here.

If this URL requires **basic auth** please enter: ```http://YOUR_USERNAME:YOUR_PASSWORD@YOUR_URL```

## Run migration after the app is deployed
You can specify to run the migration during the Heroku deployment within the ***more options*** section. If you want to run your migration after the deployment, you can add a [Script Deployment]({{ site.baseurl }}{% post_url continuous-deployment/2014-09-03-deployment-with-custom-scripts %}) under the Heroku deployment and run the migration there.

~~~shell
heroku_run bundle exec rake db:migrate my_herokuapp_name
~~~

![Migration after Heroku Deployment]({{ site.baseurl }}/images/continuous-deployment/script_deployment.png)

## Troubleshooting
- [check_url fails when deploying to Heroku]({{ site.baseurl }}{% post_url faq/2014-09-10-check_url-fails-for-heroku-deployment %})
- [My push to Heroku got rejected]({{ site.baseurl }}{% post_url faq/2014-09-10-push-to-heroku-rejected %})

## Related Content
On our blog you will find a full tutorial on how to [deploy a Rails app from GitHub to Heroku](http://blog.codeship.com/github-heroku-rails-deployment/).
The part about deploying to Heroku is the same for any application, framework, GitHub or Bitbucket.
