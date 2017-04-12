---
title: Access to other repositories fails during build
layout: page
tags:
  - faq
  - build error
  - ssh key
  - github
  - bitbucket
  - gitlab
  - private repository

redirect_from:
  - /faq/access-to-other-repositories-fails-during-build/
---
Some builds require access to other private repositories for example to use as a dependency. Codeship creates a SSH key pair for each project when you first configure it. You can view the public key on the _General_ page of your project settings and it gets automatically added as a deploy key to your GitHub or BitBucket repository.

If you need access to other (private) repositories besides this main repository, you need to follow these steps:

1. Remove the Codeship deploy key from the main repository
2. Create a [machine user](https://developer.github.com/guides/managing-deploy-keys/#machine-users)
3. Add the public key from your projects _General_ settings page to the machine user (this is the key that was previously added as a deploy key)
4. Add the machine user to both repositories on GitHub.

Even though we reference only GitHub above, the procedure is the same when your project is hosted on BitBucket.

As an alternative you can also add the SSH key from the Codeship project to your personal GitHub / BitBucket user account instead of a machine user. Keep in mind that this will allow the project to access any repository which you are allowed to access on those services.

## Typical error messages for this error

```shell
remote: Repository not found
```

```shell
fatal: Could not read from remote repository
```

```shell
Permission denied (publickey).
```
