---
title: Migrating From Jenkins To Codeship - Testing
menus:
  general/account:
    title: Jenkins To Codeship - Testing
    weight: 8
tags:
  - jenkins
  - testing
  - migrating
categories:
  - Account
---

* include a table of contents
{:toc}

In every project there is a need to test and confirm that functionality is working as planned. This takes the the form of numerous practices to determine: from unit, integration, or user interface testing to smoke testing, black box, or others. Some of these forms of testing are simple while some are complex in their configuration, management, and usage.

## Testing with Jenkins Systems

In the Jenkins system, there are a number of ways to initiate tests to run. There are plugins and other respective hacks, scripts, and webhooks to get unit tests or related actions to trigger. Jenkins does a pretty decent job performing unit tests or basic integration tests if you keep it simple.

However, having an environment in which tests are run in a singular pipeline can lead to side effects that require timely troubleshooting and problem-solving to fix. Because of this static server state versus running containers and rebuilding the environment every time, certain things get set, configured, or otherwise altered that do not mimic production environments.

The complexity of managing this in a set server build with Jenkins and the respective tests needed to manage that becomes a difficult task unto itself.

## Testing your Applications with Codeship Pro as Compared to Jenkins

With [Codeship Pro]({% link _pro/quickstart/getting-started.md %}), the testing options open up massively, without any plugins or extra configuration.

Codeship Pro’s simple configuration files ([codeship-services.yml]({% link _pro/builds-and-configuration/services.md %}) and [codeship-steps.yml]({% link _pro/builds-and-configuration/steps.md %})) can be run on the container instances that are completing the actual build. By association, not only does this provide testing insight into the Codeship build that is run but it also provides the ability to run the build locally using the Codeship Pro Jet CLI.

Simply set up the `codeship-steps.yml` file as shown.

```yaml
- name: deluge
  service: deluge_build
  command: echo 'A first build step for whatever.'
- name: deluge_tests
  service: go_tests
  command: go test
- name: deluge_another_test
  service: ruby_tests
  command: ruby tests
```

Now whenever the build is run, whether locally or via commit to the Codeship build process, the tests will be run and results displayed. For a recent setup, here are some of the results from a Codeship Pro build, when it is run with Codeship. The picture shows Codeship Pro’s web interface for the build output.

![Codeship Pro Build Example]({{ site.baseurl }}/images/jenkins-guide/build_example.png)

As mentioned, with the [Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) tool you can run your builds locally before you push to your source code management system or to help you debug. Here you can see the output in the console after using the `jet steps` command.

![Codeship Pro Jet CLI Output Example]({{ site.baseurl }}/images/jenkins-guide/jet_example.png)

With these steps, Codeship provides a means of unit test coverage for the build. This doesn’t provide a local build option, but tests could of course simply be executed manually via the Jet CLI, IDE, or whatever method for the local option.

## Testing your Applications with Codeship Basic as Compared to Jenkins

The most common testing mechanism is executing the unit tests within a code base. Let’s take a quick look at the setup of tests in [Codeship Basic](https://codeship.com/features/basic).

First, set the command within your project’s tests section of the interface.

![Codeship Basic Setup Example]({{ site.baseurl }}/images/jenkins-guide/basic_example_1.png)

Here is a quick code sample test for a Node.js application that we have [here](https://github.com/Adron/multi-cloud).

```javascript
var assert = require('assert');

describe('Where the important things happen', function () {
  describe('where the functional is good all', function () {
    it('should be good', function () {
      assert.equal(true, true);
    });
  });
});
```

## GitHub Testing Integration

When migrating to Codeship, once you added test commands in the Project Settings, as shown in the previous section, then any code pushed to your repository on any branch will trigger the source code management system’s interface to identify if the merge will build successfully.

For example, click the Compare & pull request button on GitHub.

![Codeship Basic Repo Integration Example]({{ site.baseurl }}/images/jenkins-guide/basic_example_2.png)

Next you’ll see the pending check running.

![Codeship Basic PR Example]({{ site.baseurl }}/images/jenkins-guide/basic_example_3.png)

Finally the build succeeds, and the green check box displays. The Merge pull request button turns green.

![Codeship Basic Repo Status Example]({{ site.baseurl }}/images/jenkins-guide/basic_example_4.png)

## Conclusion

In this document we’ve shown some of the power and options for testing on [Codeship Basic](https://codeship.com/features/basic) and [Codeship Pro]({% link _pro/quickstart/getting-started.md %}). It opens the door to add unit, integration, smoke, or other systems testing. Even further testing could be implemented by pushing deployment to utilize remote UI testing or other means.

Now that you know how to migrate your tests from Jenkins to Codeship we suggest looking into our other walk-throughs:

- [Migrating your Organizations, Users, and Permissions from Jenkins to Codeship](https://documentation.codeship.com/general/account/guides/migrating-from-jenkins-organizations/)
- [Migrating your Notifications from Jenkins to Codeship](https://documentation.codeship.com/general/account/guides/migrating-from-jenkins-notifications/)

You also might be interested in downloading these migration guides as PDFs. You can do so here.

- [Migrating your Tests from Jenkins to Codeship (pdf)](https://resources.codeship.com/hubfs/Codeship_Migrating_from_Jenkins_to_Codeship-Testing.pdf)
- [Migrating your Organizations, Users, and Permissions from Jenkins to Codeship (pdf)](https://resources.codeship.com/hubfs/Codeship_Migrating_from_Jenkins_to_Codeship-Organizations_Roles_and_Users.pdf)
- [Migrating your Notifications from Jenkins to Codeship (pdf)](https://resources.codeship.com/hubfs/Codeship_Migrating_from_Jenkins_to_Codeship-Testing.pdf)
