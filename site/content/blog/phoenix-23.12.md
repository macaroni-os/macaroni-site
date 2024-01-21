---
author: "Daniele Rondina"
date: 2023-12-25
linktitle: Phoenix 23.12 and Eagle 23.12 are out!
title: Phoenix 23.12 and Eagle 23.12!
tags:
  - macaroni
  - release
  - phoenix
  - eagle
weight: 5
---

**Macaroni OS is about two years old and we want to thank all the people who helped
to reach this result.**

**Thank you!**

For this reason, without to have a complete build pipeline for a new
version of the Phoenix release, we want to tag the release **23.12** of
Macaroni Phoenix with anothers big steps:

1. This releaes contains the upgrade of ZFS to version 2.2.2 with
   important bugfix of the release 2.2. We suggest to upgrade to this release
   really soon. The details are in the official [site](https://github.com/openzfs/zfs/releases/tag/zfs-2.2.2) with important fix for a data corruption bug.

2. We are happy to announce that after an intensive work, Macaroni supply a
   KDE based ISO! We consider this first integration experimental but there
   are a lot of applications of the KDE family and we love the KDE Connect tool
   that permits to integration remote control from mobile devices or
   The ISO by default uses a Wayland based integration related to a patched
   Xorg release with the same version available in Funtoo where the Xwayland
   binary was yet supplied by the same package.
   The new versions of the Xorg server supply two different tarballs for Xwayland
   and X11 and we hope to autogen all these stuff in 2024.
   Considering this, could be possible that could be better to use the X11
   implementation if you have issues with your video card, but could be helpfull
   to receive feedback about how it works from users in our Bug tracker.

3. With the release of the new ZFS version and the new LXD version is now possible
   to create storage pool *vdev* where setup a specific filesytem, like XFS for a
   native integration for Docker over LXD/Incus.
   The new Topix node uses this solution to build packages!

4. This release contains the experimental package of the **Incus** containers manager at
   version 0.3, the fork project started from LXD.
   We hope to complete the autogen file of this package soon and to add
   the package in the Funtoo Community.

5. The package `neofetch` now contains the Macaroni OS patch with our logo,
   package that will be replaced by `hyfetch` in the near future.
   The original project (`dylanaraps/neofetch) seems no longer maintained.
   See our [PR](https://github.com/dylanaraps/neofetch/pull/2424) for details.

**So, before the news about our new releases, we wish to all Macaroni and Funtoo users
an Happy New Year!**

# Phoenix 23.12 is out!

In additional to the points described in the introduction, in evidence we have:

* Open VM Tools 12.3.5

* Krita 5.1.5

* Brave 1.60.125

* Firefox 120.0

* Google Chrome 119.0.6045.199

* Vivaldi 6.4.3160.47

* Github Cli 2.39.2

* Inkscape 1.3.2

* Blender 4.0.1

* i3 4.23

* Funtoo Metatools 1.3.5

A lot of new packages are been added.

See the complete changelog of [Phoenix 23.12 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.12-phoenix).

The new ISOs will be available in the next weeks.

# Macaroni Games 23.11 is out!

We are happy to share that in the previous month we have tagged the first release
of th Macaroni Games repository.

In evidence:

* Scorched 3D 44

* Wesnoth 1.16.10

* Warzone 2100 3.2.3

We will work on integrate emulators in 2024.

See the complete changelog of [Macaroni Games 23.11 release](https://github.com/macaroni-os/macaroni-games/releases/tag/v23.11-phoenix).

Hereinafter, the step to add this new repository:

```bash
$> anise install repository/macaroni-games
$> anise repo update
```

# Eagle 23.12 is out!

Finally, also the Eagle release is been moved to Funtoo Next, this includes all
improved described in the previous blog about Phoenix 23.11 (GCC 11.3.0, Python 3.9, etc.)
and a lot of Security fix.

We suggestion to move soon to the release 23.12.

See the complete changelog of [Eagle 23.12 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.12-eagle).

# Funtoo LXD/Incus images

Many changes happen in the last period around the [Linux Containers](https://discuss.linuxcontainers.org/t/important-notice-for-lxd-users-image-server/18479) world.

In the middle of this, we fixed an [issue](https://github.com/lxc/lxc-ci/pull/801) in the
last Funtoo Next tarball related to the DHCPCD tool that has been downgraded as visible
in the Funtoo Bug tracker.

So, we think that the Funtoo Next images will be available again in 2024 on the
Linux Containers Image server.

# What next?

Hereinafter, out hot points in our backlog:

1. Will be our first priority to complete the first rewrite of the `anise-build` (luet-build)
   tool and improve our building process to complete the rebranding of our Package Manager.

2. Starting setup of `labs` repository

3. Continue the improvement of our documentation

# We are waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
