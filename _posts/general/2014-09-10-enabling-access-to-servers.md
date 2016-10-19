---
title: How to enable access for Codeship on your Firewall
layout: page
tags:
  - faq
  - firewall
  - security group
  - ip addresses
  - iam
categories:
  - general
---
## IP Addresses

Codeship is Hosted in the US-East region of EC2. You can find all the IP Addresses allocated to EC2 in their [Developer Forum](https://forums.aws.amazon.com/ann.jspa?annID=1701).

You can enable access for those ranges on your own servers firewall settings.

## AWS Security Group and account ID

* Account ID: *841076584876*
* Security group ID: *sg-64c2870c*

To add it as a source to your EC2 Security group set the Source to Custom-IP and add the following snippet as the source.

```shell
841076584876/sg-64c2870c
```

Be aware that security groups don't work across AWS regions, so for the above settings to be applicable to your account, you'd need to host your instances on `us-east-1` as well. Also, security groups won't work with instances hosted in a Virtual Private Cloud (VPC) at all.

## Access from RDS instances

Different to the settings mentioned above you need to provide the name of the security group, instead of the ID. Please add the following access rules

* Account ID: *841076584876*
* Security group name: *default*

Note, that this doesn't work with VPCs or across regions either.
