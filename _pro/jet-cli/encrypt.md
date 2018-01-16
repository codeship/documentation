---
title: jet encrypt
shortTitle: jet encrypt
menus:
  pro/jet:
    title: jet encrypt
    weight: 4
tags:
  - jet
  - usage
  - cli
  - pro
---

## Description
Encrypt a file using an AES Key.

## Usage
```
jet encrypt INPUT_PATH OUTPUT_PATH [flags]
```

## Flags
{% include flags.html flags=site.data.jet.flags.encrypt %}

## Extended description
Typical usage of `jet encrypt` is for secrets management, such as an environment variable file.  You can encrypt any file you want using the `codeship.aes` key. During the build process, and encrypted environment variable file will be automatically decrypted and used during the build process.

The `jet encrypt` function will take any file as input, and output an encrypted file using the `codeship.aes` key.

<div class="info-block">
For a more in depth explanation of environment variables and encryption, you can [read more here](https://documentation.codeship.com/pro/builds-and-configuration/environment-variables/#encrypted-environment-variables).
</div>

## Examples

```
jet encrypt env env.encrypted
```

In this example `env` is the name of the text file containing your environment variables, and `env.encrypted` is the name of the encrypted file, with the `codeship.aes` key in the same folder.

```
jet encrypt env env.encrypted --key-path PATH_TO_AES_KEY
```
