---
title: Access to other repositories fails during build
layout: page
tags:
  - faq
  - build error
  - ssh key
  - github
  - bitbucket
---
Some builds require access to other private repositories for example to use as a dependency. Every project on the Codeship gets an SSH Key you can use to give us access to other private GitHub or Bitbucket repositories. You can find the SSH Key in your project configuration on the general page.

By default we only add the SSH key to the repository you've set up. If you need to give access to more repositories you can either add it to your own user account or create a new GitHub user account you add the SSH key to. You can then add this new user to the repositories you want to give us access to them. This way you don't need to give us access to all of your repositories. GitHub calls it a machine user and you can read more about it in their [documentation](https://help.github.com/articles/managing-deploy-keys).

By adding the SSH key to your own account we then have access to all of your repositories.

An ssh key can only be added once to GitHub or Bitbucket, so make sure you remove it from the deployment keys of your GitHub repository first.

**Typical error messages are:**

~~~shell
remote: Repository not found
~~~

~~~shell
fatal: Could not read from remote repository
~~~

~~~shell
Permission denied (publickey).
~~~
