---
title: "Macaroni OS"
type: docs
---

# Why Macaroni OS?

Supply a binary distro that follow the Sabayon OS ideas and
permit to convert the rootfs to a pure Funtoo/MARK rootfs in a fast way if
it's needed for specific customizations or to help the distro fix issues.

You know, the world is buggy, it's better to have a way to check and
resolve the problems fast.

In the middle of the story, `Macaroni OS` wants to be an optimized
distro for LXD containers, Docker and Singularity.



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

To be a good start point for revolutions within the Linux OS space.

{{< /columns >}}

# Macaroni Releases

Following the core targets just described in Macaroni there are
different releases:

| Release Codename | MARK Release | Description |
| :----            |     :---:              | :---        |
| *Phoenix* | Next | The core release based on OpenRC/SysVinit for Server and Desktop |
| *Eagle*   | Next + patches | A Funtoo/MARK SystemD release. The idea is to use it only for Server target and as experimental base rootfs where we will develop an alternative tool that will replace SystemD probably written in Golang but that will be compatible with part of SystemD files. In this moment, this release has only Container based targets and Server services. |
| *Terragon* | mark-testing | The next release based on OpenRC/SysVinit Funtoo/MARK system with Container oriented use flags. |

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
MARK Next (previously was based on 1.4-prime) and so:

    * GCC 11.3.0
    * Glibc 2.33
    * Python 3.9
    * LLVM 13

The desktop environments available in this release are:

| Desktop Environment | Version | Status | ISO Available |
| :--- |  :---:  | :--- | :---: |
| Gnome | 3.36 | *stable* | yes |
| XFCE | 4.16 | *stable* | yes |
| LXQt | 1.4.0 | *stable* | yes |
| Enlightenment | 0.25.4 | *experimental* | no |
| KDE | Plasma 5.27.9 - KDE Apps 23.08.2 - KDE Framework 5.111.0 | *experimental* | yes |
| i3 | 4.22 | *experimental* | yes |


## Macaroni OS Eagle

The **Eagle** release is born to be used in container, it's based on
MARK *next* with patches to integrate SystemD as an init system.

Without the need to support the Desktop, the release is been compiled
with server-oriented and X-less use flags. This permits to have core
packages fewer dependencies and more optimized for containers.

Like *phoenix* also *eagle* is based on MARK next and so:

    * GCC 11.3.0
    * Glibc 2.33
    * Python 3.9
    * LLVM 13


## Macaroni OS Terragon

The **Terragon** release is born to be used in container and it's based
on MARK Next.

Like for *eagle* release the *terragon* release is been compiled with
server-oriented and X-less use flags.

Based on MARK Next some core packages are:

    * GCC 12.3.0
    * Glibc 2.33
    * Python 3.9

# Macaroni Repositories

We have three different repositories for any release: a stable repository, a
testing repository and, a development repository.

Hereinafter, a summary of our repositories and the packages related.

| <div style="width:200px">Repository</div>  | Stable | Testing | Development |
| ---------- |  :---: | :---: | :---: |
| *macaroni-commons* | repository/macaroni-commons | repository/macaroni-commons-testing | repository/macaroni-commons-dev |
| *mottainai* | repository/mottainai-stable | repository/mottainai-testing | repository/mottainai-dev |
| *macaroni-phoenix (ex macaroni-funtoo)*| repository/macaroni-phoenix | repository/macaroni-phoenix-testing | repository/macaroni-phoenix-dev |
| *macaroni-eagle (ex macaroni-funtoo-systemd)* | repository/macaroni-eagle | repository/macaroni-eagle-testing | repository/macaroni-eagle-dev |
| *macaroni-terragon* | repository/macaroni-terragon | repository/macaroni-terragon-testing | repository/macaroni-terragon-dev |
| *macaroni-security* | repository/macaroni-security | repository/macaroni-security-testing | repository/macaroni-security-dev |
| *macaroni-games* | repository/macaroni-games | repository/macaroni-games-testing | repository/macaroni-games-dev |

**NOTE:** The development repositories must be used only by the Staff and are
      attached to the Macaroni/Mottainai CD/CI flows. The origin server has limited
      bandwidth so please, use them only for emergencies and/or in
      collaboration with the Macaroni Team.

#### Macaroni Commons

The **macaroni-commons** repository contains the specs for building the
Macaroni OS packages common to all releases and all packages compiled
without Portage integration.

In particular, in this repository are maintained the Macaroni Kernels.

Normally, this repository is installed by default and present in all
Macaroni releases.

#### Mottainai

The Macaroni Team supports the [MottainaiCI](https://github.com/MottainaiCI/)
organization and the **mottainai-stable** repository is used to supply the
Mottainai tools and `anice`.

The `anice` PMS could be used inside other distributions and it makes sense
to avoid having a `macaroni-commons` repository to install and upgrade it.
This is the reason we have left our PMS in an independent repository.

Normally, this repository is installed by default.

#### Macaroni Phoenix

The **macaroni-phoenix** (previous **macaroni-funtoo**) repository is the
repository of the **Phoenix** release.

Normally, this repository is installed by default in all Phoenix installation.

#### Macaroni Eagle

The **macaroni-eagle** (previous **macaroni-funtoo-systemd**) repository is
the repository of the **Eagle** release.

Normally, this repository is installed by default in all Eagle installation.

#### Macaroni Terragon

The **macaroni-terragon** repository is the repository of the **Terragon**
release.

Normally, this repository is installed by default in all Terragon installation.


#### Macaroni Security

The **macaroni-security** repository is the repository of the **Pheonix** release
where we releases security updates and fast rollings packages (browsers, etc.).

It permits to release on stable branch new updates when the build cycle process
of the `macaroni-phoenix` repository is yet in progress.

Normally, this repository is installed by default in all Phoenix installation.

#### Macaroni Games

The **macaroni-games** repository is the repository of the **Pheonix** release
where we releases games (Scorched3D, Wesnoth, etc.).


# Macaroni Tags

In Macaroni the **tag** means that a specific release is been promoted for
the stable repository. Every stable repository contains only a tagged release.
There are very few exceptions where I pushed packages in the stable repository
that was not related to a tag, and this is been happen for emergency fixes
that are been follow soon by a new minor tag.

So, we could consider Macaroni as a rolling release distribution with periodic
tags and upgrades.

This choice has pros and cons:
1. A user that using stable release could easier integration their package
   based on known packages version and use the specific tree fetched by the
   tag of the macaroni-funtoo repository to build additional packages.
   Executing a backup of the Macaroni repository for a specific tag permits
   him to have a reproducible way to upgrade, install and build packages
   from a fixed point.

2. Having a static list of the package version for a specific tag helps IT
   Teams with the auditing of security issues to have uniform environments
   controllable.

3. Wait for a new tag for a security issue could be not an optimal condition,
   but from my experience, it's often more the time to wait for a fix than
   the time to release a new tag. By the way, to fix this issue the idea
   could be to prepare a `macaroni-security` repository to use in these
   emergency cases without waiting for a new tag that could be require more
   time if a build cycle is in progress.

4. In the Production environment I think that it's better to supply services
   over container LXD, Docker, or Singularity and thus ensure a more rapid
   fix of the security issues. In general, the releases Macaroni Terragon
   and Macaroni Eagle have a more fast build cycle and this permits us to
   push a more fast fix.

We want to try to follow these periodic tags on our Releases:

| Release | <div style="width:200px">Rolling Tags<div> |
| :--- |  :---:  |
| *Macaroni OS Phoenix* | every 3/4 months (when possible monthly with *macaroni-security* repository) |
| *Macaroni OS Terragon* | monthly |
| *Macaroni OS Eagle* | monthly |

It's also possible that minor releases will be tagged in addition to the
scheduled tags. The *Phoenix* for the Desktop requires a lot of effort
and testing, this is the reason why the release will be less frequent.
We're working to reorganize the tree to speed up the build cycle but this
is the job of the next months.
