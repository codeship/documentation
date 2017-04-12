---
title: Node.JS
weight: 80
tags:
  - nodejs
  - iojs
  - npm
  - yarn
  - framework

redirect_from:
  - /languages/nodejs/
---

* include a table of contents
{:toc}

## Versions And Setup

We use **nvm** to manage different node versions. We read the node version you set in your **package.json** and install the appropriate one. You can use **nvm** in your [setup commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}), such as:

```shell
nvm install NODE_VERSION
```

If the version isn't already pre-installed on the build VMs `nvm` will download the version from the official repositories and make it available to your build.

### Default Version
The default version when we can't find a setting in your `package.json` is the latest version of the `0.10` release.

### Pre-installed versions
We have the latest versions of the following NodeJS releases pre-installed on our build VMs: `0.8.x`, `0.9.x`, `0.10.x`, `0.11.x`, `0.12.x`, `4.x`, `5.x` and `6.x`.

Please note that we only install the latest version for each of those releases. You can however install any custom version via the `nvm install` command mentioned above.

## Dependencies

You can use npm to install your dependencies. We set the `$PATH` to include the `node_modules/.bin` folder so all executables installed through npm can be run.

If you have a npm version specified in your `package.json` file, it won't get picked up by *nvm* automatically. Please include the following snippet in your setup steps to install the specified version.

```shell
npm install --global npm@"$(jq -r '.engines.npm' package.json)"
```

If you simply want to upgrade `npm` to the latest available version add the following command to your setup steps.

```shell
npm install -g npm@latest
```

### npm Private Modules

In order to use private NPM modules, you'll need to login on your local machine and take a look at your `~/.npmrc` file. You'll find a registry URL as well as an authentication token.

`~/.npmrc` file example:

```shell
//localhost:4873/:_authToken="Pfd0FZsrT89l5xyJmB/3Lg=="
```

Once you have these, configure them as environment variables in your **Project Settings** > **Environment** page

![npm Private Module Environment Variables]({{ site.baseurl }}/images/languages/npm-private-env-var.jpeg)

+Add the following script to the _Setup Commands_ section of your test configuration.

```shell
echo "//${REGISTRY_URL}/:_authToken=${AUTH_TOKEN}" > "${HOME}/.npmrc"
```

### Dependency Cache

Codeship automatically caches the `$REPO_ROOT/node_modules` directory between builds to optimize build performance. You can [read this article to learn more]({{ site.baseurl }}{% link _basic/getting-started/dependency-cache.md %}) about the dependency cache and how to clear it. We also configure `yarn` to write into `$HOME/cache/yarn`, which is also cached.

### Caching Globally Installed Dependencies

If you want to cache packages installed via the `-g` switch as well, please add the following command to your setup steps.

```shell
npm config set cache "${HOME}/cache/npm/"
export PATH="${HOME}/cache/npm/bin/:${PATH}"
export PREFIX="${HOME}/cache/npm/"
```

### Scoped Packages

<div class="info-block">
Scoped packages are only avalaible for versions of `npm` greater than 2.7.0.
</div>

To create a scoped package, you simply use a package name that starts with your scope.

```json
{
  "name": "@username/project-name"
}
```

If you use `npm init`, you can add your scope as an option to that command.

```shell
npm init --scope=username
```

If you use the same scope all the time, you will probably want to set this option in your `~/.npmrc` file.

```shell
npm config set scope username
```

### Yarn

You can also use [Yarn](https://yarnpkg.com/en) to install your dependencies as an alternative to npm. Yarn is pre-installed on the build VMs and requires Node.js 4.0 or higher.

## Notes And Known Issues

Due to Node version issues, you may find it helpful to tests your commands with different versions via an [SSH debug session]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}) if tests are running differently on Codeship compared to your local machine.

### Running grunt

Do not run `npm test` to execute grunt tests. When a grunt test fails, it will return a non-zero exit code to `npm`. `npm` will ignore this exit code and return with an exit code of zero. We determine the status of your test commands based on the exit code of that command. An exit code of zero will make the command succeed, even if your tests failed.

Instead of `npm test` run your test commands directly via `grunt` using the following command.

```shell
grunt test
```

## Frameworks And Testing

All versions of node run on Codeship. Additionally, all tools and test frameworks, such as karma, mocha, grunt or any other node-based tool should work without issue. You will need to be sure to install them via `npm` before using them, however.

### io.js

If you want to use [io.js](https://iojs.org/) simply add the following step to your setup commands.

```shell
nvm use iojs-v3
```

You can then either use the `node` or the `iojs` binary to run your applications.

If you want to us a more specific version you need to add the following steps to your setup commands:

```shell
export NVM_IOJS_ORG_MIRROR="https://iojs.org/dist"
nvm install "$(jq -r '.engines.node' package.json)"
```

Combined with setting the engine to e.g `iojs-v1.5.1` this installs and selects the required version.

## Parallelization

In addition to parallelizing your tests explicitly [via parallel pipelines]({{ site.baseurl }}{% link _basic/getting-started/parallelci.md %}), some customers have found using the [mocha-parallel-tests npm](https://www.npmjs.com/package/mocha-parallel-tests) is a great way to speed up your tests.

Note that we do not officially support or integrate with this module and that it is possible for this to cause resource and build failure issues, as well.
