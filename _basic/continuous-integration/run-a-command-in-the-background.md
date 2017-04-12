---
title: Run a command in the background
weight: 85
tags:
  - testing
  - faq

redirect_from:
  - /continuous-integration/run-a-command-in-the-background/
---

* include a table of contents
{:toc}

If you need to run a process in the background during your builds (e.g. to run a service not available by default, or to run a development server provided by your application framework) you can use the following templates to do so.

```shell
nohup bash -c "YOUR_COMMAND 2>&1 &"
```

The above command will run the next step as soon as it finishes. In many cases the server you started isn't yet fully ready. To allow the server a bit more time to get ready add a `sleep` command. How large the argument `sleep` needs to be depends on the service you start and you probably need to tweak it.

```shell
nohup bash -c "YOUR_COMMAND 2>&1 &" && sleep 4
```

If you run a command via `nohup` it will not print any log output to standard out or standard error. Instead you will see a log line like this.

```
nohup: ignoring input and appending output to ‘nohup.out’
```

You also won't see any error messages printed by the service during startup (or later).

To show error messages during startup, make sure to print the `nohup.out` file during your build.

```shell
nohup bash -c "YOUR_COMMAND 2>&1 &" && sleep 4
cat nohup.out
```

For more information see the Ubuntu [`nohup` man page]({% man_url nohup %}).
