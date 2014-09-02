---
title: Coveralls Integration
layout: page
tags:
  - analytics
  - integrations
categories:
  - analytics
---
## [Coveralls Discount Code](#discount){:name="discount"}

Thanks to our partnership with Coveralls we can provide a 25% Discount for 3 months. Use the code **"coverallslovescodeship"** and [get started right away](https://coveralls.io/).

## [Setup for Ruby Project](#ruby){:name="ruby"}

Starting with Coveralls and Codeship is easy. Their docs do a great job of guiding you, but all there is to set up your Ruby app is add a .coveralls.yml file to your codebase that contains your Coveralls key:

~~~
repo_token: YOUR_COVERALLS_TOKEN
~~~

It is also possible to set this in the Environment setting of your Codeship project

~~~
COVERALLS_REPO_TOKEN=YOUR_COVERALLS_REPO_TOKEN
~~~

then simply require the Gem in your Gemfile

~~~
gem 'coveralls', require: false
~~~

and put the initializers into your spec_helper.rb or env.rb depending on which framework you use

~~~ruby
require 'coveralls'
Coveralls.wear!
~~~

If you want to combine the coverage data from different frameworks, add the following to your spec_helper.rb and env.rb (also take a look at Coveralls Docs – mentioned above – on that topic).

~~~ruby
# Coveralls with Rspec and Cucumber
require 'coveralls'
Coveralls.wear_merged!
SimpleCov.merge_timeout 3600

# MAKING SURE SIMPLECOV WORKS WITH THE PARALLEL_TESTS GEM
SimpleCov.command_name "RSpec/Cucumber:#{Process.pid.to_s}#{ENV['TEST_ENV_NUMBER']}"
~~~

Then you need to add a rake task that pushes your coverage report as soon as your build is finished.

~~~ruby
require 'coveralls/rake/task'
Coveralls::RakeTask.new
~~~

To push the data to Coveralls, add the following after your test commands on Codeship:

~~~ruby
bundle exec rake coveralls:push
~~~


## [Setup for other languages](#other){:name="other"}

Coveralls supports a lot of other languages. Check out their fantastic [documentation](https://coveralls.io/docs/supported_continuous_integration).
