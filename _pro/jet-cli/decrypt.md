---
title: jet decrypt
shortTitle: jet decrypt
menus:
  pro/jet:
    title: jet decrypt
    weight: 3
tags:
  - jet
  - usage
  - cli
  - pro
  - decrypt
---

## Description
Decrypt a file using an AES key

## Usage

```
jet decrypt /path/to/input_encrypted_file /path/to/output_file [flags]
```

## Flags
{% include flags.html flags=site.data.jet.flags.decrypt %}

## Extended description
If your project is using an encrypted environment variable file, or any other encrypted file using the `codeship.aes` key, you can decrypt that file using `jet decrypt`.

The `jet decrypt` function will take any `codeship.aes` key encrypted file as input, and output a decrypted file.

<div class="info-block">
For a more in depth explanation of environment variables and encryption, you can [read more here](https://documentation.codeship.com/pro/builds-and-configuration/environment-variables/#encrypted-environment-variables).
</div>

## Examples
```
jet decrypt env.encrypted env
```

In this example `env.encrypted` is the name of the encrypted text file containing your environment variables, and `env` is the name of the decrypted file, with the `codeship.aes` key in the same folder.

```
jet decrypt env.encrypted env --key-path PATH_TO_AES_KEY
```
