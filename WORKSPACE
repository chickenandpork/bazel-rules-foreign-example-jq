load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_gazelle",
    sha256 = "ecba0f04f96b4960a5b250c8e8eeec42281035970aa8852dda73098274d14a1d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.29.0/bazel-gazelle-v0.29.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.29.0/bazel-gazelle-v0.29.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
    ],
)

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3",
    strip_prefix = "buildtools-4.2.2",
    urls = [
        "https://github.com/bazelbuild/buildtools/archive/refs/tags/4.2.2.tar.gz",
    ],
)

http_archive(
    name = "com_google_protobuf",
    sha256 = "3bd7828aa5af4b13b99c191e8b1e884ebfa9ad371b0ce264605d347f135d2568",
    strip_prefix = "protobuf-3.19.4",
    urls = [
        "https://github.com/protocolbuffers/protobuf/archive/v3.19.4.tar.gz",
    ],
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "dd926a88a564a9246713a9c00b35315f54cbd46b31a26d5d8fb264c07045f05d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.38.1/rules_go-v0.38.1.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.38.1/rules_go-v0.38.1.zip",
    ],
)

http_archive(
    name = "rules_foreign_cc",
    sha256 = "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
    strip_prefix = "rules_foreign_cc-0.9.0",
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.9.0.tar.gz",
)

http_archive(
    name = "rules_pkg",
    sha256 = "8c20f74bca25d2d442b327ae26768c02cf3c99e93fad0381f32be9aab1967675",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.8.1/rules_pkg-0.8.1.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.8.1/rules_pkg-0.8.1.tar.gz",
    ],
)

################################################
# Import "rules_foreign_cc".

# Group the sources of the library so that CMake rule have access to it
all_content = """filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])"""

# This sets up some common toolchains for building targets. For more details, please see
# https://bazelbuild.github.io/rules_foreign_cc/0.9.0/flatten.html#rules_foreign_cc_dependencies

#load("@rules_foreign_cc//:workspace_definitions.bzl", "rules_foreign_cc_dependencies")
load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

# Workspace initialization function; includes repositories needed by rules_foreign_cc,
# and creates some utilities for the host operating system
rules_foreign_cc_dependencies()

load("@io_bazel_rules_go//go:deps.bzl", "go_download_sdk", "go_register_toolchains", "go_rules_dependencies")

# We give the SDK keys and SHA256s to reduce the delay during Analysis to hit a remote server and
# dynamically choose from its responses.  Also avoids impact of sunset versions disappearing from
# the live query we're processing.
go_download_sdk(
    name = "go_sdk",
    sdks = {
        # NOTE: In most cases the whole sdks attribute is not needed.
        # There are 2 "common" reasons you might want it:
        #
        # 1. You need to use an modified GO SDK, or an unsupported version
        #    (for example, a beta or release candidate)
        #
        # 2. You want to avoid the dependency on the index file for the
        #    SHA-256 checksums. In this case, You can get the expected
        #    filenames and checksums from https://go.dev/dl/
        "linux_amd64": ("go1.19.5.linux-amd64.tar.gz", "36519702ae2fd573c9869461990ae550c8c0d955cd28d2827a6b159fda81ff95"),
        "darwin_amd64": ("go1.19.5.darwin-amd64.tar.gz", "23d22bb6571bbd60197bee8aaa10e702f9802786c2e2ddce5c84527e86b66aa0"),
        "darwin_arm64": ("go1.19.5.darwin-arm64.tar.gz", "4a67f2bf0601afe2177eb58f825adf83509511d77ab79174db0712dc9efa16c8"),
    },
    #goos = "linux",
    #goarch = "amd64",
    version = "1.19.5",
)

go_rules_dependencies()

go_register_toolchains()  # version defaults to that given in ":go_sdk" above

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies(
    go_repository_default_config = "@//:WORKSPACE",
    go_sdk = "go_sdk",
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

################################################
# Import build rules for Boost
http_archive(
    name = "boost",
    build_file_content = all_content,
    sha256 = "da3411ea45622579d419bfda66f45cd0f8c32a181d84adfa936f5688388995cf",
    strip_prefix = "boost_1_68_0",
    urls = ["https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz"],
)

http_archive(
    name = "jq",
    build_file_content = """filegroup( name = "all_src", srcs = glob(["**"]), visibility = ["//visibility:public"])""",
    sha256 = "5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72",
    strip_prefix = "jq-1.6",
    urls = [
        "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz",
    ],
)

http_archive(
    name = "oniguruma",
    build_file_content = """filegroup( name = "all_src", srcs = glob(["**"]), visibility = ["//visibility:public"])""",
    sha256 = "28cd62c1464623c7910565fb1ccaaa0104b2fe8b12bcd646e81f73b47535213e",
    strip_prefix = "onig-6.9.8",
    urls = [
        "https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz",
    ],
)
