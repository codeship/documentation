---
title: Support For Mobile Applications on Codeship
layout: page
tags:
  - mobile
  - osx
  - android
  - ios
  - swift
  - objective-c

---
Codeship does not officially support any mobile development on either Codeship Basic or Codeship Pro. This includes both iOS and Android.

Some customers have had success manually installing older versions of the Android SDK on Codeship Basic, or building the Android SDK in a Docker image on Codeship Pro - but neither is officially documented or supported.

At this time there is no viable workaround for native iOS application builds, either. Some frameworks for building non-native applications, such as [fabric.io](https://get.fabric.io), have been used successfully, though.
