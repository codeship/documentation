---
title: How to enable access for Codeship on your Firewall
layout: page
tags:
  - faq
  - firewall
  - ip addresses
  - iam

redirect_from:
  - /faq/enabling-access-to-servers/
---
## IP Addresses

Codeship is hosted on AWS EC2 us-east-1 region. Because of this, Codeship services do not have a static IP address. AWS publishes their most up-to-date [IP Address Ranges](http://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html) in [JSON format](https://ip-ranges.amazonaws.com/ip-ranges.json).

You can enable access for those ranges on your own server's firewall settings.
