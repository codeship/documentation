---
title: Can't find a file in the repository, classpath or during tests
layout: page
tags:
  - faq
  - build error
---
When you get an error indicating that a file can't be found but you are sure
it exists in the repository it might be due to case sensitivity of
the file system on our machines.

## OSX and case sensitive file systems
By default OSX has a case insensitive file system, so *Testfile.xml* and *testfile.xml*
are treated the same. Our linux filesystem is case sensitive though, so those
would be two different files and the commands won't find the file if you don't
use the exact same file name in your code.


## How to fix
Whenever you see an error of a missing file make sure that the name of the file
on disk and the name used in your code are exactly the same, with no case
differences.
