---
title: MongoDB
layout: page
tags:
  - services
  - databases
  - mongodb
category: Databases
redirect_from:
  - /databases/mongodb/
  - /classic/getting-started/mongodb/
---
MongoDB **2.6.4** runs on the default port and doesn't require any credentials.

If you need to test against another version of MongoDB, see the [MongoDB script](https://github.com/codeship/scripts/blob/master/packages/mongodb.sh) on the [codeship/scripts](https://github.com/codeship/scripts) GitHub repository.

Simply set the `MONGODB_VERSION` environment variable and include the script via the following command in your setup steps.

```shell
\curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/mongodb.sh | bash -s
```

This will start a MongoDB server on port `27018`. (You can change the port via the `MONGODB_PORT` environment variable, if you want to.)
