---
title: Elixir
tags:
  - elixir
  - languages

---

* include a table of contents
{:toc}

## Versions And Setup

We currently don't have Elixir pre-installed on our build VMs so we'd recommend using our [Docker]({{ site.baseurl }}{% link pro/index.md %}) platform or downloading Elixir via the shell commands in your project's [setup commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}).

The easiest way to do this is by using our [scripts repository](https://github.com/codeship/scripts), specifically the [Erlang](https://github.com/codeship/scripts/blob/master/languages/erlang.sh) and [Elixir](https://github.com/codeship/scripts/blob/master/languages/elixir.sh) scripts both. After connecting your repository, you can add these setup commands that will automatically download Elixir and Erlang. Both are needed to be able to run Elixir.

```
source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/erlang.sh)"
source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/elixir.sh)"
```

The setup looks like this:
![Elixir Setup]({{ site.baseurl }}/images/languages/setupelixir.png)

## Dependencies

Installing dependencies via hex is supported once Elixir has been installed, as per the instructions above.

### Dependency Cache

We do not cache Elixir dependencies between builds.

## Notes And Known Issues

Due to Elixir version and build issues, you may find it helpful to tests your commands with different versions via an [SSH debug session]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}) if tests are running differently on Codeship compared to your local machine.

## Frameworks And Testing

Elixir frameworks such as Phoenix, and test tools
such as ExUnit, are all supported on Codeship. Note that you will need to manually install all tools needed, in your project's [setup commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}).

## Parallelization

In addition to parallelizing your tests explicitly [via parallel pipelines]({{ site.baseurl }}{% link _basic/getting-started/parallelci.md %}), some customers have found using ExUnit's built-in test parallelization is a good way to speed up your tests.

Note that aggressive parallelization can cause resource and build failure issues, as well.
