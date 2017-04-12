---
title: PostgreSQL
layout: page
tags:
  - services
  - databases
  - postgresql

redirect_from:
  - /databases/postgresql/
  - /classic/getting-started/postgresql/
---

* include a table of contents
{:toc}

The default databases created for you are **development** and **test**.

PostgreSQL `9.2` runs on the default port and the credentials are stored in the `PGUSER` and `PGPASSWORD` environment variables.

We install the Ubuntu `postgresql-contrib` package. It includes the [extension modules](http://www.postgresql.org/docs/9.2/static/contrib.html) listed in the PostgreSQL Documentation.

You need to activate them with `CREATE EXTENSION` as explained in the [Extension Guide](http://www.postgresql.org/docs/9.1/static/sql-createextension.html).

## Versions

### 9.2

The **default version** of PostgreSQL on Codeship is **9.2**, which runs on the default port of `5432`. No additional configuration is required to use version 9.2.

### 9.3

In addition we also have version **9.3** installed and configured identically. You can use this version by specifying port `5433` in your database configuration.

For Rails based projects you also need to work around our auto-configuration. Please add the following command to your _Setup Commands_.

```shell
sed -i "s|5432|5433|" "config/database.yml"
```

### 9.4

Version **9.4** of the database server is running on port `5434` and configured identical to the others. If you want to use this version make sure to specify the correct port in your database configuration.

For Rails based projects, please add the following command to your _Setup Commands_ to work around the auto-configuration in place on the build VMs.

```shell
sed -i "s|5432|5434|" "config/database.yml"
```

### 9.5

PostgreSQL version **9.5** is running on port `5435` and configured (almost) identical to the others. Make sure to specify the correct port in your project configuration if you want to test against this version.

<div class="info-block">
PostgreSQL 9.5 includes PostGIS version 2.2 instead of 2.1, which is installed for the other PostgreSQL versions.
</div>

Similar to the other versions, you need to work around our auto-configuration for Rails based projects by adding the following command to your _Setup Commands_.

```shell
sed -i "s|5432|5435|" "config/database.yml"
```

### 9.6

PostgreSQL version **9.6** is running on port `5436` and configured (almost) identical to the others. Make sure to specify the correct port in your project configuration if you want to test against this version.

<div class="info-block">
PostgreSQL 9.6 includes PostGIS version 2.2 instead of 2.1, which is installed for the other PostgreSQL versions.
</div>

Similar to the other versions, you need to work around our auto-configuration for Rails based projects by adding the following command to your _Setup Commands_.

```shell
sed -i "s|5432|5436|" "config/database.yml"
```

### pg_dump
You may experience a `pg_dump` version mismatch with the PostgreSQL version you have configured.

```shell
pg_dump: server version: $YOUR_VERSION; pg_dump version: 9.2.19
pg_dump: aborting because of server version mismatch
```

This can be resolved by adding the following command in your **Setup Commands** before running your migrations:

```shell
export PATH=/usr/lib/postgresql/<PG_VERSION>/bin/:$PATH
```

## Run `psql` commands
You can run any SQL query against the PostgreSQL database. For example to create a new database:

```shell
psql -p DATABASE_PORT -c 'create database new_db;'
```

## Enable Extensions
You can enable extensions either via the your application framework (if supported) or by running commands directly against the database. E.g, you would add the following command to your setup steps to enable the `hstore` extension.

```shell
psql -d DATABASE_NAME -p DATABASE_PORT -c 'create extension if not exists hstore;'
```

### PostGIS
PostgreSQL versions 9.2 to 9.4 include PostGIS 2.0, PostgreSQL version 9.5 and newer include the newer PostGIS version 2.2.

## Framework-specific configuration

### Ruby on Rails
We replace the values in your `config/database.yml` file automatically to configuration matching the PostgreSQL 9.2 instance.

If your Rails application is in stored a subdirectory or you want to change the database configuration from our default values ,you can add the following data to a `codeship.database.yml` file (or any other filename) and commit that file to your repository.

```yaml
development:
  adapter: postgresql
  host: localhost
  encoding: unicode
  pool: 10
  username: <%= ENV['PGUSER'] %>
  template: template1
  password: <%= ENV['PGPASSWORD'] %>
  database: development<%= ENV['TEST_ENV_NUMBER'] %>
  port: 5432
  sslmode: disable
test:
  adapter: postgresql
  host: localhost
  encoding: unicode
  pool: 10
  username: <%= ENV['PG_USER'] %>
  template: template1
  password: <%= ENV['PG_PASSWORD'] %>
  database: test<%= ENV['TEST_ENV_NUMBER'] %>
  port: 5432
  sslmode: disable
```

In your _Setup Commands_, run the following command to copy the file to its target location.

```shell
cp codeship.database.yml YOUR_DATABASE_YAML_PATH
```

If you don't use Rails and load the database.yml file yourself, you might see a PSQL::Error message stating the raw username <%= ENV['PG_USER'] %> instead of the value of the environment variable. This is because the database.yml example includes ERB syntax. You need to load database.yml, and run it through ERB before you can use it first.

```ruby
# Sample error message
# PSQL::Error: Access denied for user '<%= ENV['PGUSER'] %>'@'localhost'
#
# Run the file through ERB before loading the YAML data
DATABASE_CONFIG = YAML.load(ERB.new(File.read("config/database.yml")))
```

### Django
You can use the following database configuration for Django based projects.

```python
DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.postgresql_psycopg2',
    'NAME': 'test',
    'USER': os.environ.get('PGUSER'),
    'PASSWORD': os.environ.get('PGPASSWORD'),
    'HOST': '127.0.0.1',
  }
}
```
