---
title: Getting Started With Codeship Pro Part 2
layout: page
weight: 12
tags:
  - docker
  - jet
  - codeship pro  
  - introduction
  - getting started
  - tutorial
  - getting started jet

redirect_from:
  - /docker-guide/getting-started-part-two/
---

* include a table of contents
{:toc}

The source for the tutorial is available on Github as [codeship/ci-guide](https://github.com/codeship/ci-guide/) and you can clone it via

```bash
git clone git@github.com:codeship/ci-guide.git
```

## Getting Started With Codeship Pro (Part 2)

One of the most essential parts of any CI process is running your tests. With Codeship Pro, we wanted to make building your CI/CD pipeline easy, so we made debugging and troubleshooting - both locally and remotely - as straightforward as we could.

## Running Your Tests

Let's go back in to our code example for a minute and add a simple test.

In our case, we're just going to check for an existent environmental variable. This isn't a particularly real-world scenario, but it will help demonstrate exactly what Codeship does with your tests and what you should look for.

So, first we're going to...

### Create An Environment Variable

Opening up our `codeship-services.yml`, we'll add the following:

```yaml
demo:
  build:
    image: myapp
    dockerfile: Dockerfile
  links:
    - redis
    - postgres
  environment:
    TEST_TOKEN: Testing123
```

This new `environment` directive creates a new environment variable in our build named `TEST_TOKEN`. Note that even though we're explicitly declaring our environment variables here, in a production application we'd actual prefer to [encrypt them]({% link _pro/getting-started/environment-variables.md %}).

### Look For The Variable

With our environment variable set, let's write a test to look for it.

Create a new file called `test.rb` and open up it. In our new file, we'll write:

```ruby
if ENV['TEST_TOKEN'].nil?
   puts "Our Variable Is Not Working"
   exit 1
else
   puts "Our Variable Is Working"
   exit 0
 end
```

What we're doing here is checking to see if our new environment variable is nil. If it is, we have a problem and we exit with a status code 1 to let the CI/CD process know we have an error. If it's not nil, we're in business and we exit with a status code 0 to indicate a success.

### Update Steps

Now that we have a working test script, we need to run it. Let's open up our `codeship-steps.yml` file and modify it to the following:

```yaml
- type: parallel
  steps:
    - name: checkrb
      service: demo
      command: bundle exec ruby check.rb
    - name: test
      service: demo
      command: bundle exec ruby test.rb
```

As you can see we're now running our two scripts under a new `parallel` modifier. This means they will run side-by-side on separate containers, letting us move through multiple steps in our pipeline more quickly.

### Run And See!

Now, after configuring your tests, let's go back to your terminal and run `jet steps`

This will run your CI process as defined in `codeship-steps.yml`.

You should see something like this indicating our tests ran and passed:

![Screenshot of local test log output]({{ site.baseurl }}/images/gettingstarted/part2working.png)

## After Testing, Push Images And/Or Deploy!

So, now we have images building, a working script and a working test! The next step is to move from CI to CD: [pushing images and deploying your code.]({% link _pro/getting-started/getting-started-part-three.md %})
