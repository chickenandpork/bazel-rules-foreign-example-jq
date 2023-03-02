# rules_foreign_cc Example: jq

# TL;DR

Build directly, or use in your work?

## Build

0. install bazelisk as the command `bazel`
1. `bazel build //...`

It's Bazel.  Bazel is not new, I don't need to list the benefits, but to call out consistency:
`bazel {action} {stuff}`, whatever language.

## Use in your work

Just use `//{this-project}:jq` in your toolchain; that should get just the jq binary.

# More visible result

The binary `jq` will be built and filtered through the filegroup `jq`, but if you want to see it
rolled into a deliverable, take a look at the pkg_tar() also produced in the $workspace dir:

1. `bazel build //...`
2. `tar tf bazel-bin/tar.tar`

You should see a `jq` binary listed in the tarball.  You can just as easily use the result of this
project as your toolchains.

# Why?

https://github.com/stedolan/jq builds `jq`, but the latest version (1.6) was released before the
Apple created M1 Macs.  Lacking `jq` for Macs, but used everywhere, the suffering of various tools
is being worked-around in various random means.

Ths was an effort to simplify the build for M1s.  ...and hey, next time I can't pull a pre-built --
from Stephen Dolan's work or from my re-cut -- I can concievably just built it within the toolchain
call-out.  It might take longer on an empty cache, but it'll cache, and be available next time, and
the next, very consistently and predictably.

# Issues

Stephen's work has a number of useful features in the build process, including a wrapper script for
cross-platform compatibility.  This project doesn't do that yet.  It should adapt to the build
environment, building a host-compatible tool, but I haven't plumbed any cross-builds.  I felt a
Transition slice/array/matrix would be interesting to try.
