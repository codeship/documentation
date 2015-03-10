---
title: Deploy to Elastic Beanstalk
weight: 80
layout: page
tags:
  - deployment
  - elastic beanstalk
categories:
  - continuous-deployment
---
You can deploy your [Java]({{ site.baseurl }}{% post_url languages/2014-09-03-java-and-jvm-based-languages %}), [Ruby]({{ site.baseurl }}{% post_url languages/2014-09-03-ruby %}) or [Python]({{ site.baseurl }}{% post_url languages/2014-09-03-python %}) applications to Google App Engine through Codeship.

## Configuration

The first time you want to connect Codeship to Elastic Beanstalk, we will ask to insert your project's variables from your project configuration.

![Configure AWS Environment Variables]({{ site.baseurl }}/images/continuous-deployment/beanstalk_config.png)
	
## See also

+ [Latest `awscli` documentation](http://docs.aws.amazon.com/cli/latest/reference/)
+ [Latest Elastic Beanstalk documentation](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)
