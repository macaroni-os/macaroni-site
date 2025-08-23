---
title: "Macaroni OS"
type: docs
---

# Why Macaroni OS?

While the project is originated born to create a binary
distro following the idea of Sabayon years ago, the precious
experience with the Funtoo team and later with the Funtoo
shutdown itself give me a new idea of the targets of distro.

In this years where the AI technology from one side permits
to find details that was been hidden before from the other
side risk to automatize things and loose of some details to
users; we need to evolve but have an eye about past and how
things are started in order to continue to have a full
control of everythings. Inside this, trying to reboot from
scratch a system we can see details that before are been
developed in a way that was fine in the time where are been
created but that could be reviewed with new technologies
continuing to have a full control of the system.

In order to respect this idea, Macaroni OS want to be not
just a distro but a set di tecnologies to create an
Operating System and to permit studying of the layers needed
for this creation and give the power to users to easily
change things using existing technologies or creating new
technologies but without strictly dependencies that could
be blocking for the system itself.

So, to respond at the question about what is the base of
the Macaroni OS the response is: just based on other layers
of the Macaroni OS.

Every layer could be see as a specific Operating System with
specific features that is the base for another layer, etc.

The concept is already present from different years over the
cross-compilation, in different source-based distro, with the
creation of the stage1, stage2 and stage3:


* **Stage1 – Bootstrapping the Toolchain**

    Starts from a very minimal environment: only a bootstrap script
    and a few essential tools. The goal is to build the compiler
    (GCC), binutils, and the C standard library (libc or musl).
    Once you have a working compiler, you can rebuild everything else with it.
    To build of the stage1 help users to integration new architecture
    or rebuild literally everything from scratch.

* **Stage2 – Rebuilding the Toolchain + Base System**

    The freshly built toolchain from stage1 is used to rebuild itself,
    ensuring consistency (a full bootstrap cycle).
    Core system utilities (coreutils, bash, sed, grep, etc.) are then compiled.
    By the end of stage2, you have a coherent and working toolchain with
    a minimal userland.

* **Stage3 – Minimal Usable System (Starting Point for Users)**

    This is what you can download as tarball and creating it through
    *anise* tool.
    It already includes a working toolchain and a minimal base system.
    From here, you can use to build the kernel, desktop environment,
    and any other software.


In a similar way, the Macaroni OS wants build the stage3 through his
layers:

* **MFS** (**M**acaroni/**M**ark **F**rom **S**cratch): this layer is not yet available
for the users but is in the plan. It follow the FFS (Funtoo From Scratch)
idea but it uses *anise-build* to build the stage1 and stage2 toolchains.
`anise-build` uses Docker technologies to build and create packages.
Packages that are soon available as a repository that could be used
with `anise` to install a chroot or a minimal system.

* **M.A.R.K.** ( **M**acaroni **A**utomated **R**epositories **K**it ): It
follows the Funtoo concepts and it uses a Funtoo patched Portage engine and
kits with ebuild generated automatically from the `mark-devkit` tool.
It's the layer used as base for the Sambuca Anise stack. It wants to be a
source-based OS where easily apply patches to the upstream sources. At the
moment, it follow the Gentoo/Funtoo concepts but with changes oriented to be
more aligned to the Macaroni binary stack in order to be used together
with Macaroni's binary when needed. The name remember the Iron Man’s Armor MARK.

* **Sambuca Anise Stack**: the *original Macaroni OS layer* that was before
based on Funtoo and now based on MARK. It supplies binary packages created
with `anise-build` and managed by the `anise` tool. It uses different MARK
branches to supply the releases Macaroni OS **Phoenix**, **Terragon** and **Eagle**.


<div style="text-align: center; margin-bottom: 30px">

<img src="../../images/mark/mark-layers-2025.png" width="450">

</div>

The concept of the layers want to be also a way to divide the level of
complexity on using a Linux system. Starting with *Sambuca Anise Stack*
give to new users a fast way to create a working system without using a
compiler.
But keep an open door to integrate with the lower layer MARK. This gate
is one of the pros of the Macaroni OS. The MARK layer instead like Funtoo
before requires additional skill to prepare the system but give the
control to users to easily apply custom patches to upstream sources
and/or customize compilation flags to have a better performance of the system.
This is also one of the main difference of MARK with Funtoo before,
MARK is been created to join this two worlds and slowely create a
better integration between the two.

In the figure below is visible the relationship between the layers
and the Phoenix release for the desktop that use the *mark-iii* branch
to build packages. The MARK Stage3 is created through the anise packages
of the Phoenix release but could be created also using a previous
stage3 tarball of MARK itself or through the MFS packages generates
as stage1 and stage2 (at the moment not available) as source in
alternative of the packages available in Phoenix.

 
<div style="text-align: center; margin-bottom: 30px">

<img src="../../images/mark/mark-phoenix-flow.png" width="900">

</div>

A similar approach is used for the Terragon and Eagle releases
that instead using the *mark-xl* release.

<div style="text-align: center; margin-bottom: 30px">

<img src="../../images/mark/mark-terragon-flow.png" width="900">

</div>


The build process is like a circle that permits to create the
full system from scratch and the final node of the chain became
the source of the first node.

So, in summary, these are the core targets of the **Macaroni OS Linux**:

{{< columns >}}

## Container Optimized

Through the `subsets` feature of the Anise tool will make it easy to have a thin
rootfs and customize the files installed from a package and
run CD/CI tasks and/or pipeline fast.

<--->

## Automation

Share a way to build packages without a giant infrastructure but
with the pros of CD/CI.
Macaroni developer teams share how it's possible to do this through
`lxd-compose` or with a more scalable solution through `Mottainai Server`.
With `mark-devkit` we updates automatically our trees through
our bot that generates Github PR to our repositories. This permits to easily
add new versions or revert changes.

<--->

## Revolution Hotspot

To be a good start point for revolutions within the Linux OS space
through MARK, anise, mark-devkit and a lot of new technologies.

{{< /columns >}}


{{< columns >}}

## Knowledge Bridge

Share technologies and knowledge. Like research in multiple area, the
good way is share. Using Open Source and share knowledge is the right
way to evolve. We hope that our projects will be a base to improve life
and technologies of all our users, schools, research institute, etc.
We are only simple persons that gives their free time like before others
have done. We hope that our little effort will be useful in this world
and will enter in history as a gateway to a better world.


{{< /columns >}}

# Macaroni Releases

Following the core targets just described in Macaroni there are
different releases:

| Release Codename | MARK Release | Type | Description |
| :----            |     :---:    | :---: | :---        |
| *Phoenix* | mark-iii | binary | The core release based on OpenRC/SysVinit for Server and Desktop |
| *Eagle*   | mark-xl + patches | binary | A MARK SystemD release. The idea is to use it only for Server target and as experimental base rootfs where we will develop an alternative tool that will replace SystemD probably written in Golang but that will be compatible with part of SystemD files. In this moment, this release has only Container based targets and Server services. |
| *Terragon* | mark-xl | binary | The next release based on OpenRC/SysVinit MARK system with Container oriented use flags. |
| *Shotgun* | mark-xl | sources-based | The Mark-XL release is the testing release of Mark-V for server/containers. |
| *Suitcase Suit* | mark-v | sources-based | The Mark-V release wants to be specialized on improve Containers and Server rootfs. |
| *Nose Armor* | mark-iii | sources-based | The Mark-III release is the testing release of Mark-I for Desktop. |
| *Mark I Armor* | mark-i | sources-based | The Mark-I release is the stable release for Desktop. |
| *Hulkbuster Argonaut* | mark-31 | sources-based | The Mark-31 release is the unstable release for ARM/ARM64 with Desktop packages. |
| *Explorer Armor* | mark-unstable | sources-based | The Mark-Unstable release is the unstable release for both Container/Desktop releases. |


## *Are you ready to find your favorite layer and enjoy?*


