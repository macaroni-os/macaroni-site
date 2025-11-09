---
author: "Daniele Rondina"
date: 2025-11-08
linktitle: MARK-V, Terragon and Eagle 25.10 Released!
title: MARK-V, Terragon and Eagle 25.10 Released!
menu:
  main:
tags:
  - mark
  - macaroni
  - release
  - terragon
  - eagle
weight: 5
---


A fast post just to share the new releases in the Container area. 

# MARK-V 25.10 is here!

We are excited to share that the second release of `mark-v` is been completed.

A lot of CVEs are been fixed and thanks to our Docker Sponsor we easily check that
core packages are now CVE free.

The two new *python-build-tools-kit*, *ai-kit* kits are been added to the tree and a lot of
new packages will be added in the next future.

My special thanks go to the Macaroni's Developers that continue to be present and continue
to improve the OS, they are part of the milestone and of this success. Thank you very much!

The list of all packages available on MARK are visible through the
[meta-repo](https://github.com/macaroni-os/meta-repo/releases/tag/v25.10-mark-v) repository
where are linked the tags of all kits available in the tree mark-v.

# Terragon 25.10 and 25.10.1 released!

The Terragon releases 25.10 and 25.10.1 is the last releases based on OpenSSL 1.1.1
(upgraded now to last public release 1.1.1w). We will soon propagate the OpenSSL 3.0
release available in `mark-unstable` from months.

This release contains a complete suites of different Opensource tools to create a local Github/Gitlab style
server. In particular, are now available to the users:

* Gitea 1.24.6

* Gogs 0.13.3

* Forgejo 12.0.4

In addition, like did for mark-v, thanks to the new `ai-kit` the packages Ollama and Llama-cpp are available
in Terragon and easily configurable.

See the complete changelog of [Terragon 25.10 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.10-terragon)
and [Terragon 25.10.1 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.10.1-terragon).


# Eagle 25.10 released!

Also Macaroni OS Eagle follow the upgrade available thanks to the `mark-v` release where a lot of CVEs are been fixed.

See the complete changelog of [Eagle 25.10 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.10-eagle).

## Security CVE fixed in evidence:

CVE-2024-12797 - Cryptography 42.0.8

CVE-2025-50181 - urlib3 1.26.20

CVE-2024-47081 - requests 2.32.3

CVE-2025-58185 - Go 1.24.6

CVE-2025-58188 - Go 1.24.6

CVE-2025-61723 - Go 1.24.6

CVE-2025-61725 - Go 1.24.6

CVE-2025-58189 - Go 1.24.6

CVE-2025-47912 - Go 1.24.6

CVE-2025-58186 - Go 1.24.6

CVE-2025-61724 - Go 1.24.6

CVE-2025-47273 - Setuptools 70.3.0


# Thanks

Many thanks to all Developers and Contributors that are the sap of all this and to all
people that helps us with testing and donations.

A [Became a Contributor]({{< relref "/docs/mark/contributors" >}}) section is available in our
website and we hope to have a lot of contributors soon.

<div style="text-align: center; margin-bottom: 20px">

<img src="../../images/macaroni_wait4you.png" width="300">

</div>

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG)!




# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru) or through the
[Liberay](https://liberapay.com/geaaru/) page.

