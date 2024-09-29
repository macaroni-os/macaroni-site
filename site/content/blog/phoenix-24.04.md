---
author: "Daniele Rondina"
date: 2024-05-09
linktitle: Phoenix 24.04, Terragon 24.04 and Eagle 24.04 are out!
title: Releases 24.04 ready!
tags:
  - macaroni
  - release
  - phoenix
  - eagle
weight: 5
---

## **We are excited to announce the releases of Phoenix 24.04, Terragon 24.04 and Eagle 24.04!**

**Thank you to all people help on this!**

This release proves that we aren't only a distribution that uses Funtoo but
also tries to explore new areas for both the Funtoo Community and our users.
We want to help the Opensource world to increase its popularity and its features
or at least try. This is a hard mission, that requires time, but we believe in this and
we will always combat this.

We have finally a `macaronios.org` email accounts that helps to validate our works in our projects.

# Call to the Opensource World

In the last period, a somber story has been shared: the *xz backdoor*. I think that this is
one of the bad things that happened in the last period of the open-source world.
I hope that this will not influence people's choice of Linux, which in my opinion is one of
the best systems. Instead, I hope that people continue to support, help, and improve the
Opensource software in this difficult period where a lot of Opensource projects have
changed their licenses.

We need to help Opensource because this is the means that we permit to have open tools and
freedom. Not like in the proprietary software where other people choose what we can do with our
computer.

A few months ago I found an interesting [YouTube video](https://youtu.be/To8PJDL1k7M?t=1578) done by an
Italian Youtuber (aka **morrolinux**) with an interview with Lorenzo Faletra (aka **palinuro**) the Creator
of Parrot OS (an alternative to Kali Linux).
In this interview, *palinuro* shared that Opensource World had and has a decline not only for the
software but for the use of the Computer as a terminal. Youngs and professionals are more oriented
to an easy environment (easy only as an idea IMHO) that uses apps, Tablets, and mobiles. Products
for education are only available for Tablets and not for PCs. I agree with them that this is terrible
for the future and our children.
We need Opensource to share a tool that could be used not only to give us the freedom to write our
software but also that help us to understand how the computer works and what software is running when
we use it. We need to help users to open their creativity. Not just accept that the market share said
what is possible and we can't change it.

Just to avoid repeating things already felt I conclude this little preface with two important points:

    * We NEED support from young hackers and users to move ahead not only for Macaroni OS but for all
      Opensource OSs and Projects! Take a little slice of your time and help!

    * Opensource OSs Maintainers: we NEED to work together to resolve the gap between our OS and other
      proprietary OS in a way that normal users understand how much our system is more stable and efficient
      than the others and that this system could be used for daily work.

Thanks to *morrolinux* and *palinuro* to sharing this video.

# New Xorg and Xwayland servers

With the help of the Funtoo Developers and Contributors, we are happy to share that we have
upgraded Xorg and Xwayland to the latest version available. This is an important upgrade
that improves the support of the multi-GPU's system and it's a big step for the future
upgrade of the Gnome packages.
A lot of distributions have begun to move their default Desktop with Wayland technology
and we finally have a way to permit this integration also in Macaroni. At the moment, we
don't consider Wayland ready for Production for two important elements: the Pipewire
integration is not yet ready (but just because we need to engineer the solution but we
have already tested that it works); the NVIDIA support with the hardware tested it's pretty
terrible.

The new servers fix tons of CVEs and it's an important upgrade for the security.

Working with Wayland integration I see how much it's bad the integration of NVIDIA with
multi-GPUs laptop and I began to write a tool that helps to control the GPU configuration,
what drivers are available, and what kernel drivers are installed.
The tool is [`gpu-configurator`](https://github.com/macaroni-os/gpu-configurator) and
it's pretty young and incomplete but following what I did in the past in Sabayon about
detecting the right NVIDIA driver or Nouveau to use,
I'm trying to write something that could help normal users with the automatic configuration.
Another important aspect, that requires a review of the existing ebuild from Funtoo that
was born with a different target, is the possibility of installing at the same time
different NVIDIA drivers version and give a way to shift between one version and another
through `gpu-configurator` to help users on find the better setup. I saw how easy it is to
have an unstable NVIDIA setup just by changing the kernel branch and/or NVIDIA driver version
and to have a tool that helps easily the testing of the different versions it's a good point.

The `gpu-configurator` helps on retrieve the existing EGL and Vulkan ICD files availables
and disable NVIDIA GBM backend when it's broken.

An example with the command to show system configuration:

```bash

$> gpu-configurator show
Copyright (c) 2024 - Macaroni OS - gpu-configurator - 0.1.1
---------------------------------------------------------------------
Hostname:					nevyl
GPUs:						2
	- NVIDIA Corporation TU106M [GeForce RTX 2060 Mobile] [10de:1f15]
		kernel driver in use: nvidia
	- Advanced Micro Devices, Inc. [AMD/ATI] Picasso [1002:15d8]
		kernel driver in use: amdgpu

EGL External Platforms Configs Directories:
	- /usr/share/egl/egl_external_platform.d
		* 15_nvidia_gbm.json

Vulkan Layers Configs Directories:
	- /usr/share/vulkan/explicit_layer.d
		* VkLayer_khronos_validation.json
	- /usr/share/vulkan/implicit_layer.d
		* VkLayer_MESA_device_select.json
		* nvidia_layers.json

Vulkan ICD Configs Directories:
	- /usr/share/vulkan/icd.d
		* broadcom_icd.x86_64.json
		* intel_icd.x86_64.json
		* nvidia_icd.json
		* radeon_icd.x86_64.json

GBM Backend Librarires:
	- nvidia-drm_gbm.so (disabled)

NVIDIA Drivers:
	Active version: 535.86.05
	Available:
		- 535.86.05 (with kernel module)
NVIDIA Kernel Modules Available:
	* 535.86.05 - 6.1.87-macaroni
	* 535.86.05 - 6.6.28-macaroni
```

A more detailed description and guide will be available soon in our Documentation pages.

The previous notes about NVIDIA issues are not present in the Xorg server which remains for
now the stable setup.

# Waydroid on Macaroni

Related to the initial speech about the need to help users find a safe and creative environment
we have worked these months to integrate an interesting project like Waydroid with some patches.
Waydroid uses LXC technology to run a container with a LineageOS Android system. Through this
container, it is possible to run Android apps (for amd64 only atm) and supported Android Games
like Desktop applications that became available to the users like all other installed applications.
Waydroid uses Wayland technology that as described in the previous chapter is experimental but if
the video cards are well-supported it's very cool.

In addition, to have Waydroid work it's needed the `binder` kernel driver that is been added
by default in our kernels.

Considering that in Macaroni we have Gnome 3.36, Waydroid with some video cards suffers from
the Mutter RGB color issue described in the upstream website. We will try to patch this in the
next release.

To a complete list of the available features you could read the [official](https://waydro.id/) documentation.

# Flatpak integration

The new release improve the integration between `flatpak` and the Desktop. The flatpak application
could be managed by Gnome Software tool or in KDE from Discover.

Users with an already Macaroni installed system could be have these feature work correctly on enable
by default the `fuse` driver kernel:

```bash
$> echo "fuse" > /etc/modules.load.d/fuse.conf
$> anise i gnome-software
$> whip h gtk.postinst
```

Phoenix 24.04 supplies the last `flatpak` release 1.14.6 that fix CVE-2024-32462.

# NVIDIA Open Kernel Drivers

Considering that our work about stabilize the NVIDIA integration is yet in progress,
we have to integrate the NVIDIA kernel opensource driver as experiment and study.
The complete integration will be improved in the next releases.

With a speedy analysis, I saw that the NVIDIA Open Kernel Drivers don't resolve the
problems with Wayland.

To test the Open kernel driver you need to replace existing kernel driver with
the following steps:

```bash
$> anise rm  kernel-6.1/nvidia-kernel-modules
$> anise i kernel-6.1/nvidia-kernel-open-modules
$> # regenerate initrd images
$> macaronictl kernel gi  --all --set-links --purge --grub
```

# New ZEN Kernel available

We have added the new `linux-zen` kernel to our tree.

Zen Kernel is a fork of Linux that applies out-of-tree features, early backports,
and fixes, that impact desktop usage of Linux.
More details are available on upstream [FAQ](https://github.com/zen-kernel/zen-kernel/wiki/FAQ).

The installation of this kernel could be done through `macaronictl`.

# `macaronictl` v0.10.0 is out!

The `macaronictl` is been updated to support the new ZEN Kernels.
In particular, in our kernel packages, we have added the `kernel.type` labels
to identify new kernel types. This label is used to manage correctly the *zen* kernels.

```bash
$> macaronictl kernel availables
|  KERNEL  | KERNEL VERSION | PACKAGE VERSION |    EOL    |  LTS  |  RELEASED  |  TYPE   |
|----------|----------------|-----------------|-----------|-------|------------|---------|
| macaroni | 4.14.335       | 4.14.335        | Jan, 2024 | true  | 2017-11-12 | vanilla |
| macaroni | 5.10.215       | 5.10.215        | Dec, 2026 | true  | 2020-12-13 | vanilla |
| macaroni | 5.15.156       | 5.15.156        | Dec, 2026 | true  | 2021-10-31 | vanilla |
| macaroni | 5.4.274        | 5.4.274         | Dec, 2025 | true  | 2019-11-24 | vanilla |
| macaroni | 6.1.87         | 6.1.87          | Dec, 2026 | true  | 2022-12-11 | vanilla |
| macaroni | 6.6.28         | 6.6.28          | Dec, 2026 | true  | 2023-10-30 | vanilla |
| macaroni | 6.7.12         | 6.7.12          | N/A       | false | 2024-01-07 | vanilla |
| macaroni | 6.7.9-zen1     | 6.7.9+8         | N/A       | false | 2024-01-07 | zen     |
| macaroni | 6.8.7          | 6.8.7           | N/A       | false | 2024-03-10 | vanilla |
| macaroni | 6.8.6-zen1     | 6.8.6           | N/A       | false | 2024-03-10 | zen     |

```

# `anise-build` refactor started!

We are happy to share that finally the refactor of `anise-build` tool has started.

We begin to share new features incoming:

1. it reduces the number of Docker layers used between the pre-build
  and final Docker image

2. it uses the ENVS command using multiple environment variables in one
  single command. This reduces again the layers used.

3. it improves the integration with `tar-formers` library to speed up the export phase

4. it uses the new Helm render integration from `lxd-compose` project
   and helps diagnose with a preview of the rendered file.

We need to complete the solver integration for a first beta release but we think
that for this summer the new tool will be ready for production. This means that the
Macaroni ARM release will arrive soon.

A lot of new features will be added. Stay tuned!

# Gnome Wayland ISO

To helps the testing of Wayland integration we have create a new Gnome Wayland ISO
that uses XWayland by default.

# Phoenix 24.04 is out!

In additional to the points described in the introduction, in evidence we have:

* Open VM Tools 12.4.0

* Brave 1.65.114

* Firefox 125.0.3

* Google Chrome 124.0.6367.60

* Vivaldi 6.7.3329.9

* Github Cli 2.48.0

* Waydroid 1.4.2

* Prometheus 2.51.2

* Incus 6.0.0

* LXD 5.20

* Apache Server 2.4.59

* KDE Apps 23.08.2

* KDE Frameworks 5.111.0

* ZFS 2.2.3

* LxQt 1.4.0

* Funtoo Metatools 1.3.6

* Xorg Server 21.1.13

* XWayland 23.2.6

* OpenJDK 21.0.2

A lot of new packages are been added.

See the complete changelog of [Phoenix 24.04 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.04-phoenix).

The new ISOs will be available in the next weeks.

# Eagle 24.04 is out!

In evidence:

* Apache Server 2.4.59 (with Security fix)

* Incus 6.0.0

* NodeJS 20.12.12 (it's possible install Nodejs 14 with masking)

* Rust 1.77.2

* Prometheus 2.51.2

See the complete changelog of [Eagle 24.04 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.04-eagle).

# Terragon 24.04 is out!

In evidence:

* Apache Server 2.4.59 (with Security fix)

* Incus 6.0.0

* NodeJS 20.12.12

* Rust 1.77.2

* Prometheus 2.51.2

See the complete changelog of [Terragon 24.04 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.04-terragon).


# What next?

Hereinafter, out hot points in our backlog:

1. Complete the first beta release of new `anise-build` tool to finally rename
  `luet` in `anise`

2. Starting setup of `labs` repository

3. Continue the improvement of our documentation

4. Integrate Pipewire with Wayland and/or alternative of Pulseaudio

5. Improve `gpu-configurator` tool support NVIDIA cards setup.

6. Add Debian and XanMod kernels.

# We are waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
