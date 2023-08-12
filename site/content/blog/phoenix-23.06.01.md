---
author: "Daniele Rondina"
date: 2023-06-24
linktitle: Releases 23.06 are out!
title: New features incoming with 23.06 releases!
tags:
  - macaroni
  - release
  - phoenix
  - terragon
weight: 5
---

**We have important news to share: the development of our PMS continues
and finally, we have rewritten the method used to bump a new revision
of the repository.**

This enhancement integrates a new way to create the tree tarball used
on `repo update` command. This new implementation breaks the existing
implementation. For this reason, we will migrate to the new
implementation in August or September. This will permit to users to
upgrade to the minimal luet version requires: version *0.37.0*.

The new implementation speed-up the command `repo update` that will
not require anymore a post-processing elaboration to generate the split
metadata. The consequence is that the repo update will consume a
limited amount of memory and will be faster. This is a mandatory step
to begin integration with the embedded world.

In addition, we have added another core feature for a PMS: it's now
possible to execute an upgrade that downgrades the packages with
the version available. This will help users to switch between the
testing and the stable repositories and to supply feedback if
something is broken.

Just an example in the Terragon release:

```shell
$> luet --version
luet version 0.38.0-geaaru-geff7f8a550ed32355a9725d878d43584688b5f55 2023-06-16 11:37:38 UTC - go1.20.3
```

```shell
$> luet repo list
geaaru-repo-index
  Macaroni Repository index
  Revision     6 - 2023-04-11 12:36:24 +0000 UTC
  Priority     1 - Type http
macaroni-commons
  Macaroni OS Commons Repository
  Revision   156 - 2023-06-08 05:58:34 +0000 UTC
  Priority    30 - Type http
macaroni-terragon-dev
  Macaroni OS Terragon Dev Repository
  Revision   208 - 2023-06-14 15:13:15 +0000 UTC
  Priority    10 - Type http
macaroni-terragon
  Macaroni OS Terragon Repository
  Revision   208 - 2023-06-14 15:13:15 +0000 UTC
  Priority    30 - Type http
mottainai-stable
  Mottainai official Repository
  Revision    97 - 2023-06-17 06:03:04 +0000 UTC
  Priority    30 - Type http

```

We add the `mottainai-dev` repository to upgrade luet to the last version:

```shell
$> luet i repository/mottainai-dev -y
🚀 Luet 0.38.0-geaaru-geff7f8a550ed32355a9725d878d43584688b5f55 2023-06-16 11:37:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   6 - 2023-04-11 12:36:24 +0000 UTC
🏠 Repository:               macaroni-commons Revision: 156 - 2023-06-08 05:58:34 +0000 UTC
🏠 Repository:          macaroni-terragon-dev Revision: 208 - 2023-06-14 15:13:15 +0000 UTC
🏠 Repository:              macaroni-terragon Revision: 208 - 2023-06-14 15:13:15 +0000 UTC
🏠 Repository:               mottainai-stable Revision:  97 - 2023-06-17 06:03:04 +0000 UTC
🧠 Solving install tree...
🍦 [  1 of   1] [N] repository/mottainai-dev::geaaru-repo-index                   - 20230317
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 7 µs).
🚚 Downloading 1 packages...
📦 [  1 of   1] repository/mottainai-dev::geaaru-repo-index                       - 20230317        # downloaded ✔ 
🧠 Sorting 1 packages operations...
🍻 Executing 1 packages operations...
🍰 [  1 of   1] repository/mottainai-dev::geaaru-repo-index                       - 20230317        # installed ✔ 
🎊 All done.
```

And now we upgrade to last version:

```shell
$> luet upgrade --sync-repos
🚀 Luet 0.38.0-geaaru-geff7f8a550ed32355a9725d878d43584688b5f55 2023-06-16 11:37:38 UTC - go1.20.3
ℹ️  Repository:          macaroni-terragon-dev is already up to date.
ℹ️  Repository:                  mottainai-dev is already up to date.
ℹ️  Repository:               mottainai-stable is already up to date.
ℹ️  Repository:               macaroni-commons is already up to date.
ℹ️  Repository:              macaroni-terragon is already up to date.
ℹ️  Repository:              geaaru-repo-index is already up to date.
🏠 Repository:              geaaru-repo-index Revision:   6 - 2023-04-11 12:36:24 +0000 UTC
🏠 Repository:               macaroni-commons Revision: 156 - 2023-06-08 05:58:34 +0000 UTC
🏠 Repository:          macaroni-terragon-dev Revision: 208 - 2023-06-14 15:13:15 +0000 UTC
🏠 Repository:              macaroni-terragon Revision: 208 - 2023-06-14 15:13:15 +0000 UTC
🏠 Repository:                  mottainai-dev Revision:  97 - 2023-06-18 05:27:14 +0000 UTC
🏠 Repository:               mottainai-stable Revision:  97 - 2023-06-17 06:03:04 +0000 UTC
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍬 [  1 of   1] [U] system/luet-geaaru-testing::mottainai-dev                     - 0.38.1 [0.38.0+3::mottainai-stable]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 100 µs).
Do you want to continue with this operation? [y/N]: y
🚚 Downloading 1 packages...
📦 [  1 of   1] system/luet-geaaru-testing::mottainai-dev                         - 0.38.1          # downloaded ✔
🧠 Sorting 2 packages operations...
🍻 Executing 2 packages operations...
♻️ [  1 of   2] system/luet-geaaru-testing::mottainai-stable                      - 0.38.0+3        # removed ✔ 
🍰 [  2 of   2] system/luet-geaaru-testing::mottainai-dev                         - 0.38.1          # installed ✔ 

```

Now, we can disable the `mottainai-dev` repository and downgrade to last available version.

```shell
$> luet repo disable mottainai-dev
mottainai-dev disabled: ✔️
$> luet upgrade --deep -y
🚀 Luet 0.38.1-geaaru-g0ca7b38eeb891b6a681fbf458db339f145815e5a 2023-06-17 08:45:47 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   6 - 2023-04-11 12:36:24 +0000 UTC
🏠 Repository:               macaroni-commons Revision: 156 - 2023-06-08 05:58:34 +0000 UTC
🏠 Repository:          macaroni-terragon-dev Revision: 208 - 2023-06-14 15:13:15 +0000 UTC
🏠 Repository:              macaroni-terragon Revision: 208 - 2023-06-14 15:13:15 +0000 UTC
🏠 Repository:               mottainai-stable Revision:  97 - 2023-06-17 06:03:04 +0000 UTC
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍭 [  1 of   1] [u] system/luet-geaaru-testing::mottainai-stable                  - 0.38.0+3 [0.38.1::mottainai-dev]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 61 µs).
🚚 Downloading 1 packages...
📦 [  1 of   1] system/luet-geaaru-testing::mottainai-stable                      - 0.38.0+3        # downloaded ✔
🧠 Sorting 2 packages operations...
🍻 Executing 2 packages operations...
♻️ [  1 of   2] system/luet-geaaru-testing::mottainai-dev                         - 0.38.1          # removed ✔
🍰 [  2 of   2] system/luet-geaaru-testing::mottainai-stable                      - 0.38.0+3        # installed ✔

```

Without the use of `--deep` option, the default logic is to maintain the last version installed.

# Kernels upgrades improvement

One of the things that was present on Sabayon was that on upgrading the kernel some files were left
under the directory `/lib/modules` and the `/boot` directory.

The cleanup of the `/boot/` directory is already done automatically from the `macaronictl` tool, but
with this new release the kernels contain an *uninstall* finalize that tries to clean up yet the
`/lib/modules` directory. This will work for the next upgrade but I will waiting for feedback if
something goes wrong.

# Phoenix 23.06 and 23.06.01 are out!

Meantime, we preparing the migration from Funtoo release
1.4-prime to the next release, we have create two maintenance
release to supply new packages and a better integration
with HP and Brother Printers.

In particular, between the rest:

    * LXD 5.14

    * ZFS 2.1.12

    * Gnome Maps is been fixed on both Funtoo and Macaroni

    * NTFSg3 package to support NTFS USB pendrive

See the complete changelog of [Phoenix 23.06 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.06-phoenix) and
[Phoenix 23.06.01 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.06.01-phoenix) on Github.

# Terragon 23.06 is out!

A new release of the Funtoo Next release for Container is out.
This release is a maintenance release that contains between
the rest:

    * Rust v1.70.0

    * Python v3.9.17

    * Nodejs v20.3.0

    * Git v2.41.0

    * Haproxy v2.6.14

See the complete changelog of [Terragon 23.06 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.06-terragon)
on Github.

# What next?

Hereinafter, out hot points in our backlog:

1. Go ahead with the rewrite of the `luet build` command and
   cleanup the old code. This will require at least three or four
   months (considering the summer stop period).

2. To complete the dismission of Python 2.7 on Eagle release.
   This job is now in progress.

3. Proceed with the improvement of the documentation.

4. To complete the setup of the `macaroni-security` repository
   that is in progress.


# We waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
