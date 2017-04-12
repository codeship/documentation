---
title: Browser Testing
weight: 80
tags:
  - testing
  - continuous integration

redirect_from:
  - /continuous-integration/browser-testing/
---

* include a table of contents
{:toc}

## Firefox
Firefox 35 is installed and available in the PATH.

## Chrome
Chrome and Chromium are both available in the PATH and in `/usr/bin/google-chrome` and `/usr/bin/chromium-browser`

## Selenium
Firefox and Chrome both work with Selenium. To support Selenium with Chrome the [Chrome Driver](https://code.google.com/p/selenium/wiki/ChromeDriver) is installed as well. Please provide your own Selenium driver (e.g. [selenium-webdriver](https://github.com/vertis/selenium-webdriver) for Ruby) and keep it up-to-date. This will ensure that it will work with the latest version installed on Codeship.

### Standalone

If there are no packages available for your framework or you want to use the **Standalone** version, please take a look at the script available at [codeship/scripts](https://github.com/codeship/scripts/blob/master/packages/selenium_server.sh) on how to install a custom version.

If you are using **NodeJS**, you can use the project at [github.com/adamhooper/selenium-server-standalone-jar](https://github.com/adamhooper/selenium-server-standalone-jar) to keep your Selenium version updated to the latest available version.

## SauceLabs
You can use [SauceConnect](https://saucelabs.com/docs/connect) to connect the SauceLabs
browser testing service with the application running in your Codeship build.

There is no special integration necessary for SauceConnect on Codeship. Make sure you set the username and api key
or other necessary variables in the [environment configuration]({{ site.baseurl }}{% link _basic/getting-started/set-environment-variables.md %}). You can run your tests exactly the same
way as you would run them on your own development machine through SauceConnect.

## PhantomJS
Phantomjs 1.9.7 is installed and available in the PATH.

## CasperJS
Casperjs 1.1-beta3 is installed and available in the PATH.

## SlimerJS
SlimerJS 0.9.5 is installed and available in the PATH.
