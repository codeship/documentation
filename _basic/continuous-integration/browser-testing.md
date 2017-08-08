---
title: Browser Testing During CI/CD With Codeship Basic
shortTitle: Browser Testing
menus:
  basic/ci:
    title: Browser Testing
    weight: 1
tags:
  - browsers
  - browser testing
  - visual testing
  - frontend
  - front-end
  - chrome
  - chromium
  - chromedriver
  - firefox
  - geckodriver
  - phantomjs
  - selenium
  - capybara

redirect_from:
  - /continuous-integration/browser-testing/
---

* include a table of contents
{:toc}

## Chrome
Current versions of Google Chrome and Chromium are installed by default.

Google Chrome is at version 60 and is located at `/usr/bin/google-chrome`.

Chromium is at version 59 and is located at `/usr/bin/chromium-browser`.

There is a `chrome` symlink in the PATH that defaults to calling Google Chrome. You can change it to point to Chromium by adding these commands to your build steps:

```
ln -sf /usr/bin/chromium-browser /home/rof/bin/chrome
ln -sf /usr/bin/chromium-browser /home/rof/bin/Chrome
```

### Headless Chrome
Beginning in Google Chrome 59, you can run Chrome in [headless mode](https://developers.google.com/web/updates/2017/04/headless-chrome). To take advantage of this be sure your build is targeting Google Chrome and using ChromeDriver 2.30 or greater.  Your application will also need to pass the `headless` and `disable-gpu` flags to Chrome.

## ChromeDriver
[ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver) 2.31 is installed by default and available in the PATH.

To install a [custom ChromeDriver version](https://github.com/codeship/scripts/blob/master/packages/chromedriver.sh) add the following commands to your build steps:

```
export CHROMEDRIVER_VERSION=YOUR_DESIRED_VERSION

\curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/chromedriver.sh | bash -s
```

## Firefox
Firefox 35.0.1 is installed by default and available in the PATH.

To install a [custom Firefox version](https://github.com/codeship/scripts/blob/master/packages/firefox.sh) add the following commands to your build steps:

```
export FIREFOX_VERSION=YOUR_DESIRED_VERSION

\curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/firefox.sh | bash -s
```

## geckodriver
geckodriver 0.11.1 is installed by default and available in the PATH.

To install a [custom geckodriver version](https://github.com/codeship/scripts/blob/master/packages/geckodriver.sh) add the following commands to your build steps:

```
export GECKODRIVER_VERSION=YOUR_DESIRED_VERSION

source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/rust.sh)"

\curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/geckodriver.sh | bash -s
```

## Selenium
Chrome and Firefox both work with Selenium. To support Selenium with Chrome be sure to update ChromeDriver to the desired version for your application. Please provide your own Selenium driver in your application and keep it current.

### Selenium Standalone Server
If there are no packages available for your framework or you want to use the standalone version there is a [script](https://github.com/codeship/scripts/blob/master/packages/selenium_server.sh) available for installing a custom version.

## Sauce Labs
You can use [Sauce Connect](https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy) to connect the Sauce Labs browser testing service with the application running in your Codeship build.

There is a [script](https://github.com/codeship/scripts/blob/master/packages/sauce_connect.sh) available for installing Sauce Connect in the build environment. Make sure you set the username and API key or other necessary variables in the [environment configuration]({{ site.baseurl }}{% link _basic/builds-and-configuration/set-environment-variables.md %}). You can run your tests exactly the same way as you would run them on your own development machine through Sauce Connect.

## PhantomJS
[PhantomJS](http://phantomjs.org) 1.9.7 is installed by default and available in the PATH.

To install a [custom PhantomJS version](https://github.com/codeship/scripts/blob/master/packages/phantomjs.sh) add the following commands to your build steps:

```
export PHANTOMJS_VERSION=YOUR_DESIRED_VERSION

\curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/phantomjs.sh | bash -s
```

## SlimerJS
[SlimerJS](https://slimerjs.org) 0.9.5 is installed by default and available in the PATH.

## CasperJS
[CasperJS](http://casperjs.org) 1.1.0-beta3 is installed by default and available in the PATH.
