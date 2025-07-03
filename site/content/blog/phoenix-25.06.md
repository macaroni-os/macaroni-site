---
author: "Daniele Rondina"
date: 2025-07-03
linktitle: Phoenix 25.06 Released!
title: Phoenix 25.06 Released!
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

# The Phoenix is reborn!

We are excited to share the new release of Phoenix 25.06 now based on MARK stack,
in particular based on `mark-iii` branch.

A long time is passed from the previous release, but because the team is been busy
with the big work done in the last year of the M.A.R.K. stack that have a lot to
improve but set the base of new features and characteristics that will permit to
the Macaroni OS to improve in the next years.

So, we are sorry for this log waiting but also if the evolution is not so visible,
a lot is changed in core services and our infrastructure that now use the lovely
CDN77 Object Storage with a better integration with the CD/CI tasks.

We are also happy to have reached **1.7Milion** requests and **1.5 TB** of data
in May 2025. Really, *thanks to CDN77 Sponsor and GARR to keep this possible*.


So, without lose other time in words, this new release come with GCC 12.3.0 and
LLVM 16.0.6 and due to this change all the packages are been recompiled to get
new optimizations from these new compilers.

Thanks to the work done in MARK, this release supply the releases of QT 5.15.16
and 6.8.3 but a lot must be done to upgrade at KDE 6, but stay tuned!

# New `mark` repository

In order to begin a better integration between MARK and Anise is been created the
`mark` repository that contains the Macaroni main tools and *anise* itself
compiled from the ebuild in order to install Portage metadata if the subset is enabled.

In the previous release, the *anise* binary is available through the `mottainai-stable`
repository as package build from scratch and with a different name.

So, to have a better integration with MARK new ISOs using `mark` repository instead
of `mottainai-stable`.

The current limitations are that the packages `utils/yq` (based on yq version 3.x) and
the `mottainai-cli` are not available and it's needed install `mottainai-stable` repo to
install these two packages and all Mottainai tools. We will resolve these limitations
soon.

To existing system these the steps to install the new repository:

```shell
$> anise repo update
$> anise i repository/mark -y
$> # Disable mottainai-stable repo
$> anise repo disable mottainai-stable
```

# Phoenix 25.06

The Phoenix 25.06 release is now supplied with kernel 6.12 and Nvidia Driver 565.

We will supply in the next months new flavor of our ISOs in order to using new
Nvidia Open Driver instead of proprietary as first installation.

Like in the past, also with the last releases of NVIDIA drivers things are always
near the unstability. I'm been surprised to see that new releases 570.x and 575.x
are broken on setting only hdmi output as primary output and poweroff the laptop
screen. At least for my laptop the only release that seems work correctly is the 565
choiced for the new releases of Phoenix. So, my adventure on supplies the
`gpu-configurator` tool and help users on find the right configuration pattern seems
that will continue. Unluckly, also with NVIDIA Open Driver this doesn't change.

### New ISOs naming convention

In the past release we have used the term *Devel* related to the subset defined at *anise* level to identify ISOs contain includes files.

This is not always so clear to the users and for this reason I used the term *Mark*
in the new ISOs to better identify this type of ISOs. This will help users that want have
access to both Sambuca and MARK stacks to identify correctly the right ISOs. Obviously,
considering the limitations described in the Documentation page of this two worlds.

### Changes on using Virtualbox

After upgrading to last Virtualbox it's possible that the VM will not start correctly.

It seems that there are conflicts on using VBox kernel driver together with the `kvm` and
`kvm_amd` driver. In order to correctly bootstrap the VM you need to remove KVM kernel
module with:

```
modprobe -r kvm_amd kvm
```

or add these modules in blacklist.

### Back to the past with Compiz style window

The new Gnome ISOs are configured with the Gnome Shell extension `Compiz windows effect`
to remember past years when the Compiz WM is born.

Users with an old installation could install it with:

```
$> # Install the Compiz gnome shell extension
$> anise i gnome-shell-extension-compiz-windows-effect
```

and later enable the extension.

### Upgrade steps

Considering that the full tree is been rebuilt, it's possible that inside the upgrade
process some post install hooks fail but this is not critical in this case.

But, in order to avoid break of the upgrade process it's better to add the flag
`--force` and follow these steps:

```shell
$> # Disable mottainai-stable repository, we use mark repo packages.
$> anise repo disable mottainai-stable
$> # Install mark repository
$> anise i repository/mark
$> anise repo update
$> anise upgrade --force --deep
```

and later the classic post install commands:

```shell
$> macaronictl etc-update
$> macaronictl env-update
$> macaronictl kernel geninitrd --all --set-links --purge --grub
```

This the command to migrate existing system with kernel 6.1 to kernel 6.12:

```shell
$> macaronictl kernel switch macaroni@6.12 --from 6.1
```

### Phoenix 25.06 major updates

In additional to the points described before, in evidence we have:

* GCC 12.3.0

* LLVM 16.0.6

* Incus 6.12

* Virtualbox 7.1.8.168469

* Blender 4.4.3

* Firefox 135.0

* Grafana 12.0.0

* Google Chrome 136.0.7103.113

* ZFS 2.3.0

* Go 1.22, 1.23.8, 1.24.2

* Nodejs 20.19.1, 22.14.0

* Deno 2.2.11

* Minio 2025.04.22

* Prometheus 3.4.0

* Apache 2.4.63

See the complete changelog of [Phoenix 25.06 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.06-phoenix).

-----------------------------------------------------------

# Terragon 25.03 is out!

The release Terragon 25.03 is now based on branch `mark-xl`, the testing repository of
MARK used for server/container images.

In evidence:

* LLVM 16.0.6

* Upx 5.0.0

* Go 1.22.12, 1.23.7, 1.24.1

* Apache 2.4.63

* OpenSSH 9.9

* MySQL Community 8.0.41

* Grafana 11.6.0

See the complete changelog of [Terragon 25.03 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.03-terragon).

-----------------------------------------------------------

# Eagle 25.04 is out!

The release Eagle 25.04 is now based on branch `mark-xl`, the testing repository of
MARK used for server/container images.

In evidence:

* Incus 6.11

* HaProxy 2.9.15

* Nodejs 20.19.0, 22.14.0

* Go 1.22.12, 1.23.7, 1.24.1

* PHP 8.1.32, 8.2.28

* Rust 1.85.0

* LLVM 16.0.6

* Openssh 9.9

See the complete changelog of [Eagle 25.04 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.04-eagle).

-----------------------------------------------------------

# M.A.R.K. Updates

Following the wish of the creator of Funtoo we have started the replace of all
Funtoo tools and. In particular, the `metatools` is been replaced by the tool `mark-devkit`
better described in the next months together with the M.A.R.K. documentation.
The next step will be replace `ego` and have something more aligned to the new
branches pattern available in MARK.

<div style="text-align: center; margin-bottom: 40px">

<img src="../../images/mark/mark-stack-2025.png" width="900">

</div>



# Thanks

Many thanks to all Developers and Contributors that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
