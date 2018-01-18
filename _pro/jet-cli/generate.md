---
title: jet generate
menus:
  pro/jet:
    title: jet generate
    weight: 6
categories:
  - Jet CLI
tags:
  - jet
  - generate
  - cli
  - pro
---

## Description
Generate an AES key for encrypting files.

## Usage

```
jet generate [flags]
```

## Extended description
The AES key created using `jet generate` will is not available in Codeship during the remote execution. You can use this command to create local keys for initial testing. Any files that should be decrypted remotely would need to use the key found in your _Project Settings_ during the execution of `jet encrypt`.
