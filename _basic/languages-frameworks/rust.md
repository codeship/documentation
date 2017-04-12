---
title: Rust
tags:
- rust
- cargo
- languages

---

* include a table of contents
{:toc}

## Versions And Setup

[Rust](https://www.rust-lang.org/en-US) is not installed on the build VMs by default, but it can be easily added with a script.

To install the latest Rust version add [this command](https://github.com/codeship/scripts/blob/master/languages/rust.sh#L6) to your _Setup Commands_ and the script will automatically be called at build time.

Rust is installed via [rustup](https://github.com/rust-lang-nursery/rustup.rs) so after install `rustc`, `cargo` and `rustup` are all available in the environment.

## Dependencies

After installing Rust, fetching dependencies via Cargo should work as normal in your [setup commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}).


### Dependency Cache

We do not cache Rust dependencies between builds.

## Notes And Known Issues

As mentioned above, as Rust is not preinstalled you will need to manually install Rust and necessary dependencies yourself in your [setup commands]({{ site.baseurl }}{% link _basic/getting-started/getting-started.md %}).

## Frameworks And Testing

Frameworks such as Iron and testing via the standard Rust test attribute or via testing tools like Stainless are supported, but must be manually configured.

## Parallelization

Rust tests can be parallelized via our [ParallelCI]({{ site.baseurl }}{% link _basic/getting-started/parallelci.md %}) feature by manually specifying different test specs per pipeline.
