---
title: Browser testing
layout: page
weight: 47
tags:
  - docker
  - jet
  - tools
  - browser
redirect_from:
  - /docker/browser-testing/
---

* include a table of contents
{:toc}

Running on Codeship Pro, you have many different options to set up browser testing. Following we will describe how you can install different browsers. Please check the language documentation for specifics on how to test with your browser in a specific language.

## Xvfb
Before going into the details of setting up various browsers make sure to include [Xvfb](https://en.wikipedia.org/wiki/Xvfb) in your build. Running Xvfb before your browser sets up a virtual display the GUI of the various browsers can use.

Add the following to your Dockerfile to make sure Xvfb is properly started. If you use a non Debian based Linux distribution please install the Xvfb package through the available package manager.

```
RUN apt-get install -y xvfb
```

```bash
# The server will listen for connections as server number 1, and screen 0 will be depth 16 1600x1200.
Xvfb :1 -screen 0 1600x1200x16 &
export DISPLAY=:1.0
```

Now you can start any browser that needs a screen available.

## Firefox

There are two ways to install Firefox in your Dockerfile. Either through the available package manager or by downloading it directly from Mozilla. At first we're going to install it through the available package manager. Add the following to your Dockerfile:

```bash
# Starting from Ubuntu Trusty
FROM ubuntu:trusty

RUN apt-get install -y firefox
```

Now the Firefox version installed from your package management will be available. As this sometimes doesn't fit the exact version of Firefox you want to use you can set it by downloading and installing a specific version. We will still install Firefox through the package management system as this makes sure all necessary libraries are installed. We will set the PATH to use our specific version of Firefox though.

```bash
# Starting from Ubuntu Trusty
FROM ubuntu:trusty

# We need wget to download the custom version of Firefox, xvfb to have a virtual screen and Firefox so all necessary libraries are installed.
RUN apt-get install -y wget xvfb firefox

# Setting the Firefox version and installation directory through environment variables.
ENV FIREFOX_VERSION 40.0
ENV FIREFOX_DIR $HOME/firefox
ENV FIREFOX_FILENAME $FIREFOX_DIR/firefox.tar.bz2

# Create the Firefox directory, download the custom Firefox version from Mozilla and untar it.
RUN mkdir $FIREFOX_DIR
RUN wget -q --continue --output-document $FIREFOX_FILENAME "https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2"
RUN tar -xaf "$FIREFOX_FILENAME" --strip-components=1 --directory "$FIREFOX_DIR"

# Setting the PATH so our customer Firefox version will be used first
ENV PATH $FIREFOX_DIR:$PATH
```

Now Firefox is installed in your path and available to use for any of your browser tests.

## Chrome

To get the latest Chrome simply install it from their [debian repository](http://www.ubuntuupdates.org/ppa/google_chrome) in your Dockerfile. Additionally you need to install [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads) if you want to use Selenium with Chrome.

```
# Starting from Ubuntu Trusty
FROM ubuntu:trusty

# We need wget to set up the PPA and xvfb to have a virtual screen and unzip to install the Chromedriver
RUN apt-get install -y wget xvfb unzip

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable

# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 2.19
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR

# Download and install Chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH
```

Now Chrome is installed in your path and available to use for any of your browser tests.

## PhantomJS

PhantomJS is a headless browser, thus we don't need any Xvfb setup to run tests. We simply download it from the official site, unpack it and put it into the PATH.

```
# Starting from Ubuntu Trusty
FROM ubuntu:trusty

# We need wget to download PhantomJS and other libraries that need to be installed for PhantomJS to work
RUN apt-get install -y wget libfontconfig1 libfreetype6

# Set up Environment variables for PhantomJS
ENV PHANTOMJS_VERSION 1.9.8
ENV PHANTOMJS_DIR /phantomjs

# Download and untar PhantomJS
RUN wget -q --continue -P $PHANTOMJS_DIR "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2"
RUN tar -xaf $PHANTOMJS_DIR/phantomjs* --strip-components=1 --directory "$PHANTOMJS_DIR"

# Set the PATH to include PhantomJS
ENV PATH $PHANTOMJS_DIR/bin:$PATH
```

## Selenium Server

To use the standalone Selenium Server you need to download the Selenium jar file in you Dockerfile first.

```
# Starting from Ubuntu Trusty
FROM ubuntu:trusty

# Install Wget to download the selenium-server.jar and openjdk-7-jdk
RUN apt-get install -y wget openjdk-7-jdk

# Set Environment variables that are used for running the Selenium build
ENV SELENIUM_PORT 4444
ENV SELENIUM_WAIT_TIME 10

# Download the seleium-wever.jar with wget
RUN wget --continue --output-document /selenium-server.jar "http://selenium-release.storage.googleapis.com/2.47/selenium-server-standalone-2.47.1.jar"
```

Then as part of your build script you simply start the Selenium Server with the jar file and wait a few seconds for it to properly load.

```bash
java -jar /selenium-server.jar -port "${SELENIUM_PORT}" ${SELENIUM_OPTIONS} 2>&1 &
sleep "${SELENIUM_WAIT_TIME}"
echo "Selenium ${SELENIUM_VERSION} is now ready to connect on port ${SELENIUM_PORT}..."
```
