---
title: "Macaroni Linux OS"
type: docs
---

# Why Macaroni OS?

Supply a binary distro that follow the Sabayon OS ideas and
permit to convert the rootfs to a pure Funtoo rootfs in a fast way if
it's needed for specific customizations or to help the distro fix issues.

You know, the world is buggy, it's better to have a way to check and
resolve the problems fast.

In the middle of the story, `Macaroni OS` wants to be an optimized
distro for LXD containers, docker and singularity.



So, in summary, these are the core targets of the **Macaroni OS Linux**:

{{< columns >}}

## Container Optimized

Through the `subsets` feature of the Luet tool will make it easy to have a thin
rootfs and customize the files installed from a package and
run CD/CI tasks and/or pipeline fast.

<--->

## Automation

Share a way to build packages without a giant infrastructure but
with the pros of CD/CI.
Macaroni developer teams share how it's possible to do this through
`lxd-compose` or with a more scalable solution through `Mottainai Server`.

<--->

## Revolution Hotspot

To be a good start point for revolutions within the Linux OS space with
the synergy of the Funtoo Team.

{{< /columns >}}

# Macaroni Releases

Following the core targets just described in Macaroni there are
different releases:

| Release Codename | Funtoo Release | Description |
| :----            |     :---:              | :---        |
| *Phoenix* | 1.4-prime | The core release based on OpenRC/SysVinit for Server and Desktop |
| *Eagle*   | 1.4-prime + patches | A Funtoo SystemD release. The idea is to use it only for Server target and as experimental base rootfs where we will develop an alternative tool that will replace SystemD probably written in Golang but that will be compatible with part of SystemD files. In this moment, this release has only Container based targets and Server services. |
| *Terragon* | next | The next release based on OpenRC/SysVinit Funtoo system with Container oriented use flags. |

Major differences about GCC, Python

## Macaroni OS Phoenix

The **Phoenix** release is the first release created and the only release
at the moment for the Desktop.
The codename *phoenix* is related to the immortal bird associated with
Greek mythology that cyclically regenerates or is otherwise born again.
Associated with the sun, a phoenix obtains new life by rising from the
ashes of its predecessor. This is the reason I choose this name: to describe
a new beginning and to remember us that also when others try to stop a
dream, with the commitment it's possible reborn and goes ahead.

In **phoenix** it's used the OpenRC as an init system, it's based on
Funtoo 1.4-prime and so:

    * GCC 9.2.0
    * Glibc 2.33
    * Python 3.7 (2.7 is available but will be dropped in the near future)
    * LLVM 11

The desktop environments available in this release are:

| Desktop Environment | Version | Status | ISO Available |
| :--- |  :---:  | :--- | :---: |
| Gnome | 3.36 | *stable* | yes |
| XFCE | 4.16 | *stable* | yes |
| Enlightenment | 0.25.4 | *experimental* | no |
| KDE | 5.22 | *experimental* | no |

As the first release a lot of things could be improved but it's also true
that the Desktop is something complex that requires a lot of effort and
computing. We will work to clean up things and speed up the building
phase that now it's very expensive, in particular for the build of the
*funtoo-base* seed based on Gnome Funtoo stage3.

## Macaroni OS Eagle

The **Eagle** release is born to be used in container, it's based on
Funtoo 1.4-prime with patches to integrate SystemD as an init system.

Without the need to support the Desktop, the release is been compiled
with server-oriented and X-less use flags. This permits to have core
packages fewer dependencies and more optimized for containers.

Like *phoenix* also *eagle* is based on Funtoo 1.4-prime and so:

    * GCC 9.2.0
    * Glibc 2.33
    * Python 3.7 (2.7 is available but will be dropped in the near future)
    * LLVM 11



## Macaroni OS Terragon

The **Terragon** release is born to be used in container and it's based
on Funtoo Next that is the more innovative release of Funtoo.

Like for *eagle* release the *terragon* release is been compiled with
server-oriented and X-less use flags.

Based on Funtoo Next some core packages are:

    * GCC 11.3.0
    * Glibc 2.33
    * Python 3.9
