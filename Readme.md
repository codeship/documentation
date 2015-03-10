# [Codeship Documentation](https://codeship.com/documentation/) [ ![Codeship Status for codeship/documentation](https://codeship.com/projects/59a737f0-1648-0132-c4e7-72c6c37b1f6e/status)](https://codeship.com/projects/33837)

[![Waffle.io Board](https://badge.waffle.io/codeship/documentation.svg?label=ready&title=Ready)](http://waffle.io/codeship/documentation)
[![Dependency Status](https://gemnasium.com/codeship/documentation.svg)](https://gemnasium.com/codeship/documentation)
[![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/codeship/documentation/blob/master/License.md)

## Getting Started

### Setup

Clone the repository, install needed gems and run Jekyll ;)

```bash
git clone git@github.com:codeship/documentation.git
cd documentation
bundle install
bundle exec guard
```

You can then access the site at [http://localhost:4000](http://localhost:4000)

### Linting

#### SCSS

SCSS files are automatically linted using [scss-lint](https://github.com/causes/scss-lint). To run it execute the following command

```bash
bundle exec scss-lint
```

It's configured in [.scss-lint.yml](.scss-lint.yml) and the default configuration is [available online](https://github.com/causes/scss-lint/blob/master/config/default.yml) as well.

### Contributing

1. [Fork it](https://github.com/codeship/documentation/fork)
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'```)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request

## Markup

### Table of contents

If you want to include a table of contents, include the following snippet in the markdown file

```md
* include a table of contents
{:toc}
```

### URL Helpers
#### Tags

Generate a URL for the specified tag (_database_ in the example below). This is also available as a filter to be used with a variable (_tag_ in the example).

```
{% tag_url databases %}
{{ tag | tag_url }}
```

generate the output like the following (depending on configuration values)

```
/tags/databases/
```

#### Man Pages

Link to a specific Ubuntu man page. This currently defaults to the Ubuntu Trusty version.

```
{% man_url formatdb %}
```

generates the following output

```
http://manpages.ubuntu.com/manpages/trusty/en/man1/formatdb.1.html
```
