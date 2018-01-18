---
title: jet decrypt
menus:
  pro/jet:
    title: jet decrypt
    weight: 4
categories:
  - Jet CLI
tags:
  - jet
  - decrypt
  - cli
  - pro
---

## Description
Decrypt a file using an AES key

## Usage

```
jet decrypt /path/to/input_encrypted_file /path/to/output_file [flags]
```

## Flags
{% include jet_flag_table.html flags=site.data.jet.flags.decrypt %}

## Extended description
The `jet decrypt` function will take any encrypted file as input, and output a decrypted file using the key found in your _Project Settings_.

If you encounter the error `No AES key provided`, and you have already downloaded the key, verify that the file is named `codeship.aes` and in the same directory where you are executing `jet decrypt`, or you are passing in the correct `key-path` value.


## Examples

### Default Usage
```shell
$ jet decrypt env.encrypted env
```

This will create `env` from the `env.encrypted` file using the key in the `codeship.aes` file.

### encrypt with key-path

```shell
$ jet decrypt env.encrypted env --key-path PATH_TO_AES_KEY
```

This will create `env` from the `env.encrypted` file using the key located at `PATH_TO_AES_KEY`.
