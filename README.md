# [Codeship Documentation](https://codeship.com/documentation/)

[![Codeship Status for codeship/documentation](https://codeship.com/projects/0bdb0440-3af5-0133-00ea-0ebda3a33bf6/status?branch=master)](https://codeship.com/projects/102044)
[![Waffle.io Board](https://badge.waffle.io/codeship/documentation.svg?label=ready&title=Ready)](http://waffle.io/codeship/documentation)
[![Dependency Status](https://gemnasium.com/codeship/documentation.svg)](https://gemnasium.com/codeship/documentation)
[![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/codeship/documentation/blob/master/LICENSE.md)

## Contributing

We are happy to hear your feedback. Please read our [contributing guidelines](CONTRIBUTING.md) and the [code of conduct](CODE_OF_CONDUCT.md) before you submit a pull request or open a ticket.

## Getting Started

## Prerequisites

* [Docker](https://docs.docker.com/engine/installation/)

We recommend using Docker to build and test the documentation. Running via Docker is only required if you plan to make changes to the styling or layout of the site.

For content related changes and fixes, it's easiest to use GitHubs [File Edit UI](https://help.github.com/articles/editing-files-in-another-user-s-repository/) to make the changes and create the pull request.

### Setup

We need to be brief,

```bash
git clone git@github.com:codeship/documentation.git
cd documentation
```

build the container and save it as a tagged image.

```bash
docker build --tag codeship/documentation .
```

You can then run commands via that container. By default, it will build the site and start the Jekyll development server.

```bash
docker run -it -p 4000:4000 -v $(pwd):/docs codeship/documentation
```

To access the site open http://IP_OF_YOUR_DOCKER_SERVER:4000 in your browser.

## Development

### Updating dependencies

To update Rubygem based dependencies, update the `Gemfile` (if required) and run

```bash
docker run -it -v $(pwd):/docs codeship/documentation bundle update
```

For NPM based dependencies, run the following two commands

```bash
docker run -it -v $(pwd):/docs codeship/documentation npm update && npm shrinkwrap
```

### Linting

#### SCSS

SCSS files are automatically linted using [scss-lint](https://github.com/causes/scss-lint). To run it, execute the following command

```bash
docker run -it -v $(pwd):/docs codeship/documentation bundle exec scss-lint
```

It's configured in [.scss-lint.yml](.scss-lint.yml) and the default configuration is [available online](https://github.com/causes/scss-lint/blob/master/config/default.yml) as well.

#### JSON

```bash
docker run -it -v $(pwd):/docs codeship/documentation gulp lint
```

#### Jekyll

```bash
docker run -it -v $(pwd):/docs codeship/documentation bundle exec jekyll doctor
```

## Markup

### Table of contents

If you want to include a table of contents, include the following snippet in the markdown file

```md
* include a table of contents
{:toc}
```

### URL Helpers
#### Tags

Generate a URL for the specified tag (_database_ in the example below). This function is also available as a filter and can be used with a variable (_tag_ in the example).

```
{% tag_url databases %}
{{ tag | tag_url }}
```

generate the output like the following (depending on configuration values)

```
/tags/databases/
```

#### Man Pages

Link to a particular Ubuntu man page. The Ubuntu version currently defaults to Ubuntu Trusty.

```
{% man_url formatdb %}
```

generates the following output

```
http://manpages.ubuntu.com/manpages/trusty/en/man1/formatdb.1.html
```
