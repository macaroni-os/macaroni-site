---
author: "Daniele Rondina"
date: 2023-08-12
linktitle: Releases 23.08 is out!
title: New Macaroni-Security Repository is here!
tags:
  - macaroni
  - release
  - phoenix
weight: 5
---

**Finally, it's available the new `macaroni-security` repository!**

Considering that the Funtoo release 1.4-prime is in EOL, we will use
the `macaroni-security` repository to share security patches and
updates of Browsers, Devs tools, and other packages meantime we
rebooting Phoenix's branch to Funtoo Next.


Due to this change, **all users using Macaroni Phoenix MUST add
the `macaroni-security` repository before executing any update**.

```
$> luet repo update
$> luet i repository/macaroni-security
$> luet repo update
$> luet upgrade
```

The repository `macaroni-security` uses the new tree v2 which requires
luet version *0.37.0* or greather.

This repository is also a good example for the users about how could
create their repository starting from the Phoenix base layer and then
using *luet-build* and *luet-portage-converter* to generate their
packages.

# Macaroni OS enter on Docker-Sponsored Open Source Program

We are really happy to announce that we are entered into the annual
[*Docker-Sponsored Open Source Program*](https://docs.docker.com/docker-hub/dsos-program/).

The [`macaronios`](https://hub.docker.com/orgs/macaronios) docker user is now an organization.

We will complete the right setup in the next month.

Really, thanks to Docker Inc. for this opportunity.


# Phoenix 23.08 is out!

This release introduces updates about the available Browsers
and a lot of new packages for the development incoming with the
`macaroni-security` repository:

In particular, between the rest:

    * Firefox 116.0.2

    * Google Chrome 115.0.5790.110

    * Brave 1.56.20

    * Jenkins 2.410

    * Vivaldi 6.1.3035.257

    * Openssh v9.3p2 (CVE-2023-38408)

    * Thunderbird 115.1.0

    * Github Cli 2.32.1

    * MongoDB Compass 1.39.1

In addition, the new kernels are now available with the fix for CVE-2023-3269.

See the complete changelog of [Phoenix Security 23.08 release](https://github.com/macaroni-os/macaroni-security/releases/tag/v23.08-phoenix) and on Github.

The `macaroni-phoenix` repository will be freeze or with few updates
until the migration from Funtoo 1.4-prime to Next.

# Terragon 23.08 is out!

A new release of the Funtoo Next release for Container is out.

The new release contains the migration to luet tree v2 that improve 3x the repository update time:

```shell
minion ~ $> time luet repo update --force macaroni-terragon
🏠 Repository:              macaroni-terragon Revision: 208 - 2023-06-14 15:13:15 +0000 UTC

real	0m18.193s
user	0m4.807s
sys		0m1.236s

minion ~ $> time luet repo update --force macaroni-terragon-dev
🏠 Repository:          macaroni-terragon-dev Revision: 228 - 2023-08-11 15:15:06 +0000 UTC

real	0m6.312s
user	0m0.477s
sys		0m0.788s

```

This release is a maintenance release that contains between
the rest:

    * Rust v1.71.0

    * Grafana v10.0.3

    * Nodejs v20.5.0

    * Prometheus v2.46.0

    * Openssh v9.3p2 (CVE-2023-38408)

See the complete changelog of [Terragon 23.08 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.08-terragon)
on Github.

# What next?

Hereinafter, out hot points in our backlog:

1. The refactor of `luet-build` go ahead and we will rename our
   PMS at the end of this refactor with the new name
   `anise`/`anise-build`.

2. Considering that the Funtoo release 1.4-prime will be in EOL
   for the end of the year we will move soon both Eagle and Phoenix
   release to the new tree. We will share for 3 or 4 months
   the repository `macaroni-phoenix-legacy` and `macaroni-eagle-legacy`
   to permit users using the 1.4-prime to manage a more quiet
   migration but without updates.

3. At the moment the `luet-portage-converter` doesn't manage
   for the same package multiple versions. When the refactor
   of `luet-build` will be ended we will review this feature to
   support multiple version in the same repository (for example,
   having multiple release of Nodejs package).


# We waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
