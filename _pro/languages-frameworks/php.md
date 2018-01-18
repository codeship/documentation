---
title: Using PHP In CI/CD with Docker and Codeship Pro
shortTitle: PHP
menus:
  pro/languages:
    title: PHP
    weight: 6
tags:
  - php
  - languages
  - docker
  - cakephp
  - laravel
categories:
  - Languages And Frameworks
redirect_from:
  - /docker-integration/php/
---

<div class="info-block">
We've got [quickstart repos, sample apps and a getting started guide]({% link _pro/quickstart/quickstart-examples.md %}) available to make starting out with Codeship Pro faster and easier.
</div>

* include a table of contents
{:toc}

## PHP on Codeship Pro

Any PHP framework or tool that can run inside a Docker container will run on Codeship Pro. This documentation article will highlight simple configuration files for a PHP-based Dockerfile and phpunit tests.

## Example Repo

We have a sample PHP/Laravel repo that you can clone or take a look at via the GitHub [codeship-library/php-laravel-todoapp](https://github.com/codeship-library/php-laravel-todoapp) repository. This may make a good starting point for your PHP-based projects.

## Services File

The following is an example of a [Codeship Services file]({% link _pro/builds-and-configuration/services.md %}). Note that it is using a [PostgreSQL image](https://hub.docker.com/_/postgres/) and a [Redis image](https://hub.docker.com/_/redis/) via the Docker Hub as linked services.

When accessing other containers please be aware that those services do not run on `localhost`, but on a different host, e.g. `postgres` or `mysql`. If you reference `localhost` in any of your configuration files you will have to change that to point to the service name of the service you want to access. Setting them through environment variables and using those inside of your configuration files is the cleanest approach to setting up your build environment.

```yaml
project_name:
  build:
    image: organisation_name/project_name
    dockerfile: Dockerfile
  links:
    - redis
    - postgres
  environment:
    - DATABASE_URL=postgres://postgres@postgres/YOUR_DATABASE_NAME
    - REDIS_URL=redis://redis
redis:
  image: redis:2.8
postgres:
  image: postgres:9.4
```

## Steps File

The following is an example of a [Codeship Steps file]({% link _pro/builds-and-configuration/steps.md %}).

Note that every step runs in isolated containers, so changes made on one step do not persist to the next step.  Because of this, any required setup commands, such as migrating a database, should be done via a custom Dockerfile, via a `command` or `entrypoint` on a service or repeated on every step.

```yaml
- service: php
  command: phpunit tests/unit
- service: php
  command: phpunit tests/integration
```

## Dockerfile

Following is an example Dockerfile with inline comments describing each step in the file. The Dockerfile shows the different ways you can install extensions or dependencies so you can extend it to fit exactly what you need. Also take a look at the PHP image documentation on [the Docker Hub](https://hub.docker.com/_/php/).

```dockerfile
# Start from PHP 5.6
# Take a look at the PHP image documentation on the Docker Hub for more detailed
# info on running the container: https://hub.docker.com/_/php/
FROM php:5.6

# Installing git to install dependencies later and necessary libraries for postgres
# and mysql including client tools. You can remove those if you don't need them for your build.
RUN apt-get update && \
    apt-get install -y \
      git \
      libpq-dev \
      postgresql-client \
      mysql-client

# Install tools and applications through pear. Binaries will be accessible in your PATH.
RUN pear install pear/PHP_CodeSniffer

# Install extensions through pecl and enable them through ini files
RUN pecl install hrtime
RUN echo "extension=hrtime.so" > $PHP_INI_DIR/conf.d/hrtime.ini

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Install extensions through the scripts the image provides
# Here we install the pdo_pgsql and pdo_mysql extensions to access PostgreSQL and MySQL.
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_mysql

# Set the WORKDIR to /app so all following commands run in /app
WORKDIR /app

# Copy composer files into the app directory.
COPY composer.json composer.lock ./

# Install dependencies with Composer.
# --prefer-source fixes issues with download limits on GitHub.
# --no-interaction makes sure composer can run fully automated
RUN composer install --prefer-source --no-interaction

COPY . ./
```

## Notes And Known Issues

Because of version and test dependency issues, it is advised to try using [the Jet CLI]({% link _pro/jet-cli/usage-overview.md %}) to debug issues locally via `jet steps`.

## Caching

You can enable caching per service in your Services file.

You can [read more about how caching works on Codeship Pro here]({{ site.baseurl }}{% link _pro/builds-and-configuration/caching.md %}).
