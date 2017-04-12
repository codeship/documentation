---
title: Git Submodules
weight: 50
tags:
  - git
  - submodules

redirect_from:
  - /continuous-integration/git-submodules/
---

* include a table of contents
{:toc}

If your repository includes a `.gitmodules` file Codeship will automatically initialize and update the configured submodules. To do this, we run the following command after cloning your repository.

```bash
git submodule update --recursive --init
```

For submodules that are hosted as public repositories that should just work (and let us know if it doesn't).

If your submodule is however a **private repository** you'd need to make sure Codeship can clone the repository.

1. Make sure the projects public SSH key (from the _General_ settings page) has access to the submodule repository. See [how to provide access to other repositories]({{ site.baseurl }}{% link _general/projects/access-to-other-repositories-fails-during-build.md %}) if you're not sure how to achieve this.
2. Make sure the submodule is referenced via a SSH based URL (e.g. `git@github.com:codeship/documentation.git`). If you refence the submodule via a HTTPS based URL (e.g. `https://github.com/codeship/documentation.git`), the git client will ask for authentication credentials during the build and run into a timeout (as you can't provide them).

See the git documentation on [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for more information on working with submodules.
