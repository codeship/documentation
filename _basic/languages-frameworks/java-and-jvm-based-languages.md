---
title: Java and JVM based languages
tags:
  - java
  - scala
  - languages

redirect_from:
  - /languages/java-and-jvm-based-languages/
---

* include a table of contents
{:toc}

## Versions And Setup

### JDKs

The following JDKs are installed:

* OpenJDK 7
* Oracle JDK 7
* Oracle JDK 8

We provide the function `jdk_switcher`, available as a setup command, to choose the JDK for your builds.
This function can take one of two commands, `use` or `home`:

* `use` will select the given JDK by changing the java executables, and setting JAVA_HOME and JRE_HOME.
* `home` will print out the value of JAVA_HOME for a given JDK (but make no modifications).

The valid values for `use` or `home` are _openjdk7_, _oraclejdk7_, and _oraclejdk8_.
By default, OpenJDK 7 is selected. The following would be the resulting Java version, JAVA_HOME, and JRE_HOME for each JDK:

### OpenJDK 7 (default)

```shell
jdk_switcher home openjdk7
# /usr/lib/jvm/java-7-openjdk-amd64
jdk_switcher use openjdk7
echo $JAVA_HOME
# /usr/lib/jvm/java-7-openjdk-amd64
echo $JRE_HOME
# /usr/lib/jvm/java-7-openjdk-amd64/jre
java -version
# java version "1.7.0_65"
# OpenJDK Runtime Environment (IcedTea 2.5.3) (7u71-2.5.3-0ubuntu0.14.04.1)
# OpenJDK 64-Bit Server VM (build 24.65-b04, mixed mode)
```

### Oracle JDK 7

```shell
jdk_switcher home oraclejdk7
# /usr/lib/jvm/java-7-oracle
jdk_switcher use oraclejdk7
echo $JAVA_HOME
# /usr/lib/jvm/java-7-oracle
echo $JRE_HOME
# /usr/lib/jvm/java-7-oracle/jre
java -version
# java version "1.7.0_72"
# Java(TM) SE Runtime Environment (build 1.7.0_72-b14)
# Java HotSpot(TM) 64-Bit Server VM (build 24.72-b04, mixed mode)
```

### Oracle JDK 8

```shell
jdk_switcher home oraclejdk8
# /usr/lib/jvm/java-8-oracle
jdk_switcher use oraclejdk8
echo $JAVA_HOME
# /usr/lib/jvm/java-8-oracle
echo $JRE_HOME
# /usr/lib/jvm/java-8-oracle/jre
java -version
# java version "1.8.0_25"
# Java(TM) SE Runtime Environment (build 1.8.0_25-b17)
# Java HotSpot(TM) 64-Bit Server VM (build 25.25-b02, mixed mode)
```

### Build Tools

The following tools are preinstalled in our virtual machine. You can add them to your setup or test commands to start your build:

* ant (1.9.2)
* maven (3.1.1)
* gradle (1.10)
* sbt (0.13.5)
* leiningen (2.4.0)

### JVM-based languages

Scala , Clojure, Groovy and other JVM based languages should run without issue on Codeship, as well. [Let us know](https://helpdesk.codeship.com) if you find something that doesn't work as expected.

## Dependencies

Installing dependencies through Maven is fully supported.

## Dependency Cache

Codeship automatically caches the `$HOME/.ivy2` and `$HOME/.m2/repository` directories between builds to optimize build performance. You can [read this article to learn more]({{ site.baseurl }}{% link _basic/getting-started/dependency-cache.md %}) about the dependency cache and how to clear it.

## Notes And Known Issues

Due to Java version issues, you may find it helpful to tests your commands with different versions via an [SSH debug session]({{ site.baseurl }}{% link _basic/getting-started/ssh-access.md %}) if tests are running differently on Codeship compared to your local machine.

## Frameworks And Testing

All build tools and test frameworks, such as Junit, will work without issue as long as they do not require root access for custom machine configuration.

## Parallelization

In addition to parallelizing your tests explicitly [via parallel pipelines]({{ site.baseurl }}{% link _basic/getting-started/parallelci.md %}), some customers have found using the parallel features in Junit and other testing frameworks to be a good way to speed up your tests.

Note that aggressive parallelization can cause resource and build failure issues, as well.
