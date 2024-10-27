---
author: "Daniele Rondina"
date: 2024-10-27
linktitle: Phoenix 24.08.01 Released!
title: Phoenix 24.08.01 Released!
menu:
  main:
tags:
  - mark
  - macaroni
  - release
  - phoenix
  - eagle
  - terragon
weight: 5
---

# Phoenix release have a new look!

We are happy to announce the `Macaroni Phoenix 24.08.01` release, a minor release with some cool
new changes.

This new release come with a new Plymouth Theme with Macaroni OS logo that will be installed
by default in all new installation.

<div style="text-align: center; margin-bottom: 40px">

<img src="../../images/install/macaroni-plymouth.png" width="600">

</div>

In this release the GTK default Theme is **Orchis** that together with the new **Papirus** icons gift a very new look and feel to the our DE based on GTK.

<div style="text-align: center; margin-bottom: 40px">

<img src="../../images/blogs/Gnome-orchis-papirus.png" width="600">

</div>

This release supply the new *Virtualbox 7.1* that seems finally a bit
more stable and without the tons of *dmesg* errors about DRM.
The cons is that the 3D option is now broken, we will waiting
for the new version with the hope that this will be fixed. But
considering that now it seems more stable we have move ahead things
with this new release. Having the 3D option broken we have permitted
to find an issue in the last release of Xorg server  that is been
patched and that permit to fix the unexpected close of Gnome Photo
and other X tools in some systems with poor video cards.

Another good news is that now *Firefox* package is build with CLANG
and uses system PNG library to have a better performance and integration.
The new Firefox release resolve the issues with DRM introduces in the
release 24.08.

# Phoenix 24.08.01

The Phoenix 24.08.01 is a patching release always based on MARK `next` branch.

The kernel drivers Virtualbox and NVIDIA are now available for the the kernel 6.10.
The new Kernel ZEN 6.11.2 is available for testing.

The new ISOs using NVIDIA Driver 560 as default version.

### Phoenix 24.08.01 major updates

In additional to the points described before, in evidence we have:

* ZFS 2.2.6

* Incus 6.5

* LXD 5.21.1

* Waydroid 1.4.3

* Blender 4.2.1

* Firefox 130.0

* Grafana 11.2.0

* Google Chrome 128.0.6613.137

* Vivaldi 5.9.3447.33


See the complete changelog of [Phoenix 24.08.01 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.08.01-phoenix).

### Setup new look in the existing system

In order to install the new Plymouth theme you need to follow these steps:

```
$> # Install the new plymouth theme
$> anise i plymouth-macaroni
$> # Rebuild the initrd image
$> macaronictl kernel gi --set-links --grub --purge --all
```

and later install the new Gnome Orchis Theme and the Papirus Icons:

```
$> anise i gnome-orchis-theme papirus-icon-theme
```

Based on the DE used configure the new Style `Orchis-Orange-Compact` or
`Orchis-Orange-Dark-Compact` and the `Papirus` icons. Enjoy!


# Terragon 24.10 is out!

We happy to share that this new release is been completly rebuild to upgrade GCC
to *12.3.0* and the starting *seed* for the compilation is now based on the MARK
stage3 tarball and on `mark-testing` branch of MARK.

Having Terragon based on MARK's `mark-testing` branch will help for testing
compilation process and to have soon a better integration with *anise* stack.

In evidence with the migration to GCC 12.3.0:

* Incus 6.5

* LXD 5.21.1

* Rust 1.81.0

* Nginx 1.26.2

* Python 3.9.20

* MariaDB 10.6.19 (columnstore feature is now available again!)

* PostgreSQL 16.4, 13.16

* Bash 5.2.37

See the complete changelog of [Terragon 24.10 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.10-terragon).


# Eagle 24.10 and 24.10.01 is out!

In evidence:

* Incus 6.5

* LXD 5.21.1

* HaProxy 2.9.11

* Minio Object Store 2024.10.02.08.27.28

* Nodejs 20.18.0

* Go 1.23.1

* PHP 8.2.24, 8.1.30

* FreeRadius 3.0.27

See the complete changelog of [Eagle 24.10 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.10-eagle) and
of [Eagle 24.10.01 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.10.01-eagle).

# M.A.R.K. Updates

A lot of updates are been introduces in the `mark-testing` branch
in order to organize things and later create the new stable releases.

In about one month we have closed 50 issues. Kudos to all people help on this!

In evidence some of the issues resolved by our team in the last period:

- *sys-apps/usbutils-018* now uses Meson for compilation. The autogen now follow this new way (*Thanks @borisp*)
- *app-crypt/xca* is been fixed (*Thanks @cuantor*)

- *app-emulation/incus* autogen is been reviewed

- new packages available: `app-backup/backrest`, `x11-themes/papirus-icon-theme`, `x11-themes/gnome-orchis-theme`, `dev-util/volk`.

- *sys-power/cpupower* autogen is been fixed

- the packages *sys-apps/baselayout* and *sys-apps/lsb-release* are been rebranding

- the old GCC ebuilds are been removed

- the XFCE Kit is now managed inside `kit-fixups` repository directly

- the Debian kernel ebuild are now autogen! See [PR#158](https://github.com/macaroni-os/kit-fixups/pull/158) (*Thanks @cuantar*)

- Go autogen is been pinned to version 1.22.7 and 1.23.1 (*Thanks @siris*)

- the `intel64-tremont` subarch is been added (*Thanks @cuantor*)

And a lot of other PR are been closed. See our repository for [details](https://github.com/macaroni-os/kit-fixups/pulls?page=3&q=is%3Apr+is%3Aclosed).

# Thanks

Many thanks to all Developers and Contributors that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
