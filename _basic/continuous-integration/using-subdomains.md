---
title: Custom DNS Resolution
weight: 60
tags:
  - subdomain
  - testing
  - dns
  - xip.io
  - lvh.me

redirect_from:
  - /continuous-integration/using-subdomains/
---

* include a table of contents
{:toc}

Sometimes you need to access your application at a specific URL during the build.

As it is not possible to modify the `/etc/hosts` file or run your own DNS server on the build VMs, we recommend you use a wildcard DNS service instead.

There are a couple different services available for you to use, the two we would recommend are `lvh.me` and [xip.io](http://xip.io).

## lvh.me

This service is very straight forward. Any request to a subdomain of `lvh.me` will resolve to `127.0.0.1`.

```bash
$ nslookup database.lvh.me
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	database.lvh.me
Address: 127.0.0.1
```

## xip.io

If you need more flexility with regards to the resolved IP address we recommend _xip.io_.

You can configure the IP address as part of the domain name. A name like `www.127.0.1.1.xip.io` will resolve to the `127.0.1.1` IP address.

```bash
$ nslookup database.127.0.0.1.xip.io
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	database.127.0.0.1.xip.io
Address: 127.0.0.1
```

In most cases this additional flexibility is not required, as you can't modify the IPs of the build VMs. You can however make use of this with other [loopback ip addresses](https://en.wikipedia.org/wiki/Localhost).
