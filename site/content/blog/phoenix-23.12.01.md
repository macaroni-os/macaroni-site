---
author: "Daniele Rondina"
date: 2024-01-20
linktitle: New releases 23.12.01 are out!
title: Phoenix 23.12.01, Eagle 23.12.01 and Terragon 23.12!
menu:
  main:
tags:
  - macaroni
  - release
  - phoenix
  - eagle
weight: 5
---


**Happy new year to all Macaroni OS and Funtoo users!**

We are happy to announce a new bugfix release for Phoenix and Eagle **23.12.01**
based on the tree of *23.12* and the release Terragon **23.12**:

1. We have autogen the Apache package, a fix that will be available for Funtoo users
   in `harvester/24.01` soon. This permits an upgrade to version 2.4.58
   with tons of security fixes. See later for the details.

2. Phoenix 23.12.01 supplies a new version of the Poppler package with a fix of
   the use flags used. Now the PDFs with JPEG or PNG are correctly visible.

3. The release v0.4.0 of the Incus project is now available in the tree of all
   our releases.

4. The kernel 6.6 is now available but without the NVIDIA driver for the moment
   caused by some issues with symbols exporting as described
   [here](https://www.phoronix.com/news/Linux-6.6-Illicit-NVIDIA-Change).

5. The kernel 6.7 is now been added in the tree without extra kernel modules.

6. The release Phoenix 23.12.01 uses Macaroni Security 24.01 tag.

7. We have fixed an important issue in the wrapper script of Google Chrome,
   Brave that now permits opening the browser with the clicked link.
   This fix needs `macaronictl v0.9.12`.


# Security

With the upgrade of the Apache package these the CVE fixed in all releases:

* CVE-2023-43622
* CVE-2023-45802
* CVE-2023-25690
* CVE-2023-27522
* CVE-2006-20001
* CVE-2022-23943
* CVE-2022-22721
* CVE-2022-22720
* CVE-2022-22719
* CVE-2022-31813
* CVE-2022-30556
* CVE-2022-30522
* CVE-2022-29404
* CVE-2022-28615
* CVE-2022-28614
* CVE-2022-28330
* CVE-2022-26377
* CVE-2021-44224
* CVE-2021-44790
* CVE-2021-42013
* CVE-2021-41524
* CVE-2021-41773


# Phoenix 23.12.01 is out!

In additional to the points described in the introduction, in evidence we have:

* Incus v0.4.0

* Apache 2.4.58

* Added package `dev-vsc/hub` 2.14.2 for CD/CI processes.

* VSCode v1.85.1

* VSCodium v1.85.1.23348

* PyCharm Community v2023.3.2

* Thunderbird v115.6.1

* Discord v0.0.40

* Github Cli v2.42.0

* Google Chrome v120.0.6099.216

* Vivaldi v6.5.3206.53

* Criu 3.19

See the complete changelog of [Phoenix 23.12.01 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.12.01-phoenix)
and [Security 24.01 release](https://github.com/macaroni-os/macaroni-security/releases/tag/v24.01-phoenix).


# Eagle 23.12.01 is out!

In additional to the points described in the introduction, in evidence we have:

* Incus v0.4.0

* Apache 2.4.58 with the fix of the logrotate file

* Added Numpy v1.21.5

See the complete changelog of [Eagle 23.12.01 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.12.01-eagle).


# Terragon 23.12 is out!

In additional to the points described in the introduction, in evidence we have:

* Incus v0.4.0

* Binutils v2.40

* GCC 12.3.0 is now available as optional compiler but for now we maintain
  11.3.0 as main system package.

* LXD v5.20

* MongoDB v4.4.27

* Rust v1.74.1

* Grafana v10.2.3

* Apache v2.4.58

* Vim v9.0.2184

* Prometheus v2.48.1

* Bind v9.18.21

* Haproxy v2.6.16

* Meson v1.3.0

* Funtoo Metatools v1.3.5

* Util Linux v2.93.3

* Caddy v2.7.6

See the complete changelog of [Terragon 23.12 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.12-terragon).

# What next?

Hereinafter, out hot points in our backlog:

1. The rewrite of the `anise-build` (luet-build) tool is in progress. We hope to
   have the new release in two or three months.

2. Continue the improvement of our documentation

# We are waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
