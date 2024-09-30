---
author: "Daniele Rondina"
date: 2024-09-29
linktitle: M.A.R.K. is here together with 24.08!
title: M.A.R.K. is born!
menu:
  main:
tags:
  - mark
  - macaroni
  - release
  - phoenix
  - eagle
weight: 5
---

# Funtoo is dead, long live to M.A.R.K.!

Is just in the previous post that I wrote about how many communities are in difficult and that is need new lymph from young developers and at the begin of July with a pain in the heart that I received the news shared from Daniel Robbins about the Funtoo shutdown.

These the words shared by him: *"All Good Things Must Come to an End"*.

Unluckly, these words are bitterly true but I hope that how a door
is closed a new door will be open.

**My infinite thanks will be always to Daniel Robbins that help me on
bootstrap Macaroni OS Project and I wish all the best to him and his
family. Thanks for what you do in all these years as a part of the
Linux history.**

In order to cheer up the Macaroni OS users, on the ashes of the Funtoo
Project I'm happy to announce the born of the **M.A.R.K.** Stack as a
part of the Macaroni Project and as a new point of the revolution
where  improve Macaroni itself.


The **M.A.R.K.** (**M**acaroni **A**utomated **R**epositories **K**it) Stack,
that remember the name of the Iron Man's Armor MARK is the set of all tools
that permits to maintain and update Kits and to create a better integration
between the Macaroni binary Stack (now called *Sambuca* stack) and the
Portage level.

As visible in the image, before the Funtoo shutdown was clear the separation
between the Funtoo world and the Sambuca Stack. The *anise-build* (before
*luet-build*) is used to create the binary packages using the Portage
engine or from scratch.

<div style="text-align: center; margin-bottom: 40px">

<img src="../../images/mark/funtoo-mark-stack.png" width="900">

</div>


The M.A.R.K. Stack is **NOT** a fork of Funtoo, it wants to be a start point based
of the technologies created in the Funtoo world where study and improve a
technology born inside the Gentoo world to be more innovative and more
easy to maintain and to modify. Obviously, Macaroni was based in Funtoo and we can
not be replace Funtoo in few weeks, these the reason because a lot of things following
the structure and the behaviour of the Funtoo before but with an eye in the future
to be more integrated with the existing Macaroni tools.

<style>
li {
    font-size: 16px;
}
</style>
These the first changes:

1. the Funtoo <b>metro</b> tool is been replaced by <b><a href="https://github.com/macaroni-os/mark-devkit">mark-devkit</a></b> that permits
   generate stage tarball like before with a starting stage tarball, but it permits
   to use <b>anise</b> directly to create a starting chroot path directly from
   binary packages. This will help in the near future to create a stage tarball
   from a stage1 rootfs build from *anise-build* like FFS before.
   The specs to build Stage3 tarball are available in the
   <b><a href="https://github.com/macaroni-os/mark-stages">mark-stages</a></b> repository.

2. in Funtoo, there is a strict relationship between the release, the python-kit
   profile to use and the branch to use.This could be a limitation if we want to share
   a common release name between different branches used to work with new features
   indipendently that will be merged later. To do this we had changed the code of
   the `ego` tool to permit through the configuration of the file `/etc/ego.conf`
   to continue using the attribute `release` to define the branch of the `meta-repo`
   repository to use but using the attribute `python_kit_profile` to identify the
   name of the profile to use for python-kit.

3. in Macaroni releases we use rootfs with a separated directory for `/lib` and
   `/usr/lib`, and to have a better integration with Anise binary packages we had
   force the using of the `SYMLINK_LIB=no` option to compile *glibc* with separated
   `/lib` directory. Other distributions follow this pattern and we don't consider
   this choice wrong, having `anise` permits to restore a broken system easily.
   But we don't suggest to convert old Funtoo system without we have find a valid
   migration workflow. To continue using links a Funtoo user can configure:

   ```
   SYMLINK_LIB="yes"
   ```

   on `/etc/portage/make.conf`.

4. today the world of the services it's strictly connected to containers and virtualization
   in order to supply more reproducible system and fast deployable. Personally, I don't see
   reasons to have a Production service without a container also over a normal Macaroni
   rootfs but the possibility to deploy and redeploy a service with automatic services
   (lxd-compose, docker-compose, kubernetes) is the defacto one of the best practices.
   For this reason, we will organize things to have ready to use containers for users for
   different technologies. Thanks to the Docker-Sponsored Open Source program for Docker
   we will supply a good experiance, like using our Simplestreams server for LXD.

A lot of others things are in progress and we have in plan but we will organize and improve
documentation soon. As you can imagine reboot Funtoo in less of two months is been impegnative
and a lot of work must be done. In about one or two months we have closed more of one hundread
PR and this seems a wonderful begin, thank you very much to all developers and contributors
that helps on this.

Continuing to follow the previous division the MARK Stack and the Sambuca Stack will be two
different subset but with a better intersection. I like the idea to use *anise* as rescue
tool for MARK users when something goes wrong. Funtoo users lovers of the build from sources
can continue their path using only MARK like before with Funtoo but we will work to improve,
keep only things AS-IS will only define the end, the change is needed to improve and grow
what was before Funtoo.

We aren't a company, we are only people with a passion for the *fun*, things could be go ahead
slowly but I hope the new contributors will help in the path to continue the wonderful
Funtoo's milestone.

Now that I'm writing this blog I see how much documentation is needed to cover all tools used
in MARK and it's hard to write everything in this *post*. So, we will add a MARK section over
the Macaroni Documentation page soon.

## M.A.R.K. Branches

Before describe the details about migration a running Funtoo It's better share an important
note; like described before, MARK uses a different approach on manage releases and branches,
so, in order to reach new frontiers we need to work with multiple branches but with specific
targets. Using multiple Kits already in part helps on manage this use case but not for everything.

It's true that some packages of our tree are old, in particular for the Desktop environment,
but attention, this doesn't mean that are broken (or at least not all :) ). In order to continue
to have a stable condition but improve the tree we dont' see any better path that to divide
branches and releases oriented for a Container target from the branches of the Desktop,
like we have in Sambuca stack with Terragon and Eagle releases for containers and Phoenix
for Desktop. Just upgrading core packages (glibc, GCC, etc.) it's high probable that old
packages will be broken. We think that it's important detach this relationship to have a
minimal subset of packages for Server and Container where more fast improve and test new
packages and more branches for Desktop where in a planned mode to do big changes. It's also
true that at some point this difference will reach a slim level and things will could become
togegher but not in this particular moment.
This is the first important reason because we have modified the behaviour of the Funtoo to be
more easy switch and work with multiple branches.

We are yet working on organize the developers process but I share an preliminary view of all
branches that we will supply:

<table class"table" width="100%" style="margin-top: 15px; margin-bottom: 15px;">
<thead>
    <tr>
        <th style="width: 110px;">Branch</th>
        <th style="width: 100px;">Target</th>
        <th>Description</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td>next</td>
        <td>server, desktop</td>
        <td>Funtoo landing branch before move to MARK</td>
    </tr>
    <tr>
        <td>mark-testing</td>
        <td>server, desktop</td>
        <td>The Mark Testing release could be used to push packages candidates for production and/or without a major impact if not explicit in the Planned project.</td>
    </tr>
    <tr>
        <td>mark-i</td>
        <td>server, desktop</td>
        <td>The Mark-I release could be considered the stable release more similar to the Funtoo next release.
            We will create it in the near future after the stabilization of MARK tools. <i>Not yet available.</i>
            Our target is to remove all gentoo-staging stuff from this release.
        </td>
    </tr>
    <tr>
        <td>mark-ii</td>
        <td>server, container</td>
        <td>The Mark-II release will be based on only autogenned packages or curated packages. It will be our super-stable release. Could be possible to maintain this with only pinned packages that are updated only after a testing chain. When ready will support desktop too.
        </td>
    </tr>
    <tr>
        <td>mark-v</td>
        <td>server, container</td>
        <td>The Mark-V release aslo knows as the <b>Suitcase Suit</b> wants to be specialized on improve Containers and Server rootfs. <i>Not yet available.</i>
        </td>
    </tr>
    <tr>
        <td>mark-xl</td>
        <td>server, container</td>
        <td>The Mark-XL release aslo knows as the <b>Shotgun</b> is the testing release of Mark-V. <i>Not yet available.</i>
        </td>
    </tr>
    <tr>
        <td>mark-unstable</td>
        <td>server, desktop</td>
        <td>The MARK Unstable release is the world of the chaos. We can push PR to upgrade and break everything. But better in an organized mode if it's possible. :)
        </td>
    </tr>
    <tr>
        <td>mark-funtoo</td>
        <td>server</td>
        <td>The MARK Funtoo branch is used to help Funtoo on upgrade/maintain server packages over exiting Funtoo Kits.
            Will be based on Macaroni `next` branch. This will not be autogen but only managed on Macaroni
            `kit-fixups` repository.
        </td>
    </tr>

</tbody>
</table>

Changes are possible in the path because we are yet in an stabilization phase where the tools that
we need, that will be developed and to improve will clarify the behavior.


## Migrating from Funtoo to MARK

Before describe the details about migration a running Funtoo rootfs we clarify what are the
mandatory requirements to use the new MARK branches.
As described before, there are different behaviour about the use of python-kit branch and the
release, in order to use the new branches you need to upgrade `ego` with our fork at the version
`2.8.8_pre20240817`. To do this step you can use the `next` branch of Macaroni and later move of
`mark-testing` branch or another.
Another important upgrade to do is the Portage package that requires updates in order to
use the Macaroni CDN as default mirror.

**We suggest to execute a backup before the migration. We can't to know how this change will be
managed by all available profile/mix-in configuration.**

So, the migration is quite easy:

1. Edit `/etc/ego.conf` and change the `sync_base_url`:

```shell
$> cat /etc/ego.conf
[global]
release = next
sync_base_url = https://github.com/macaroni-os/{repo}
```

2. Delete the old Funtoo `meta-repo` dir:

```shell
$> sudo rm -rf /var/git/meta-repo
```

3. Re-sync your meta-repo to the new MARK `next` release:

```shell
$> sudo ego sync
```

4. Upgrade `ego`:

```shell
$> emerge ego --nodeps -pv

These are the packages that would be merged, in order:

[ebuild   R    ] app-admin/ego-2.8.8_pre20240817::core-kit [2.8.7::core-kit] USE="-zsh-completion" PYTHON_SINGLE_TARGET="python3_9 -python3_10 -python3_7 -python3_8" PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 381 KiB

$> emerge ego --nodeps -j
```

5. Upgrade `sys-apps/portage` in order to use Macaroni CDN:

```shell
$> emerge portage --nodeps -j
>>> Verifying ebuild manifests
>>> Running pre-merge checks for sys-apps/portage-3.0.14-r12
 * Determining the location of the kernel source code
 * Unable to find kernel sources at /usr/src/linux
 * Please make sure that /usr/src/linux points at your running kernel, 
 * (or the kernel you wish to build against).
 * Alternatively, set the KERNEL_DIR environment variable to the kernel sources location
 * Unable to calculate Linux Kernel version for build, attempting to use running version
 * Checking for suitable kernel configuration options...                                                                                                                                                     [ ok ]
>>> Emerging (1 of 1) sys-apps/portage-3.0.14-r12::core-kit
>>> Installing (1 of 1) sys-apps/portage-3.0.14-r12::core-kit
```


6. Now you can migrate to `mark-testing` branch again editing the `/etc/ego.conf` file:

```shell
$> cat /etc/ego.conf
[global]
release = mark-testing
sync_base_url = https://github.com/macaroni-os/{repo}
python_kit_profile = mark
```

For all MARK branches we use `mark` profile for `python_kit_profile`.

7. Again cleanup `meta-repo` directory and re-run a sync:

```shell
$> sudo rm -rf /var/git/meta-repo
$> sudo ego sync
```

These steps are pretty the same when you need to migrate from a MARK branch to another.

8. Setup `ego` profile:

```shell
$> ego profile build mark
WARNING: Previous value: next -- typically, user should not change this.

=== Enabled Profiles: ===

        arch: x86-64bit
       build: mark
     subarch: generic_64
      flavor: core
     mix-ins: (not set)

>>> Set build to mark.
Updating profiles at /etc/portage/make.profile/parent...

$> etc-update && env-update
```

At the moment, there aren't particular changes about the support of multiple arches. It's pretty
the same of Funtoo.

9. If you have `/lib` and `/usr/lib` as symbolic link then you need to add this on `/etc/portage/make.conf`:

```shell
$> cat /etc/portage/make.conf 
SYMLINK_LIB="yes"
```

# New developers joined Macaroni Organization

In order to help the evolution of M.A.R.K. Stack we are very happy to announce that the
following developers joined Macaroni Developers Team:

- Boris Pigin aka [borisp](https://github.com/org-tekeli-borisp)

- Kevin P. Wilson aka [cuantar](https://github.com/cuantar)

- Raphael Bastos aka [coffnix](https://github.com/coffnix)

- Rob Wheatley aka [r0b](https://github.com/linuxexplorer)

**Thank you to all new developers to be part of Macaroni adventure!**

<div style="margin-top: 30px;"></div>

# Sponsors area

## **CDN77** is sponsor of Macaroni OS Linux

We are happy sharing to our users that CDN77 is now sponsor of Macaroni OS.
We will use their services to improve both MARK and Sambuca Stack.
Really, thank you very much to CDN77 for this opportunity.
We are working in improve the CDN77's services integration to share a better experience
to all users.

## Docker-Sponsored Open Source program renew

The Docker-Sponsored Open Source program expire after one year but
it's been renew this August.

<div style="margin-top: 30px;"></div>

# Sambuca Stack News

In order to identify better the set of tools and technologies used in Macaroni to build
binary packages and related to our Package Manager System *anise* we will use the term
Sambuca Stack. The Macaroni release Phoenix, Terragon and Eagle are part of Sambuca Stack.

The term *Sambuca* is related to an Italian liquor that uses the *anise*.

## `gpu-configurator` v0.2.8 is out!

With Phoenix 24.08 release we have finally review completely  the management of the NVIDIA
Drivers, proprietary and opensource. In particular, the installation of NVIDIA Drivers are
now managed with different SLOT for *major* release. This permits to have at the same time
multiple versions of NVIDIA drivers for different kernel versions activable on demand.
The new release of `gpu-configurator` integrates new methods to better configure the NVIDIA
Drivers and the kernel drivers.

It doesn't support yet the tuning of the Nouveau driver but we will integrate this soon.

The setup of the drivers is done automatically from the finalizer of the binary packages but
could be review from the admin.

A fast summary of the new commands:

```bash
$> gpu-configurator nvidia kernel 560.35.03 6.7.9-zen1-macaroni

$> gpu-configurator nvidia kernel --purge 560.35.03 6.7.9-zen1-macaroni

$> gpu-configurator nvidia configure --with-video-group 535.183.01

$> gpu-configurator nvidia configure --with-video-group 535.183.01 --purge
```

In particular, it's now easy to understand what NVIDIA drivers are installed
and active and what kernels NVIDIA driver with the new output of
the *show* command and catch orphans kernel drivers:

```bash
$> gpu-configurator show
Copyright (c) 2024 - Macaroni OS - gpu-configurator - 0.2.8
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
		* radeon_icd.x86_64.json
		* broadcom_icd.x86_64.json
		* intel_icd.x86_64.json
		* nvidia_icd.json
	- /etc/vulkan/icd.d
		* nvidia_icd.json

GBM Backend Librarires:
	- nvidia-drm_gbm.so
	- nvidia_gbm.so

NVIDIA Drivers:
	Active version: 555.58.02
	Available:
		- 555.58.02 (with kernel module)
NVIDIA Kernel Modules Available:
	* 555.58.02 - 6.1.109-macaroni
NVIDIA Kernel Modules Active:
	* 555.58.02 - 6.1.109-macaroni
	* 535.86.05 - 6.6.18-macaroni
	* 550.54.14 - 6.7.9-zen1-macaroni
NVIDIA Open Kernel Modules Available:
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Open Kernel Modules Active:
	* 535.86.05 - 6.6.28-macaroni
	* 555.58.02 - 6.6.50-macaroni

```

In conclusion, the new `gpu-configurator` release now show NVIDIA cards visible
in the system as `3D Controller` and not only as `VGA Controller`.

We will integrate the use of `gpu-configurator` on MARK stack too soon.

## `anise` v0.41.1 is out!

The new `anise` release introduce a rewrite of the box backend that integrates
the use of `fchroot` to run command over a specific chroot.
This feature is used on `mark-devkit` to generate stage tarballs.

Funtoo users know that fchroot is a wrapper that use QEMU for arches not matching
the native arch and the command *chroot* for native arch. This feature will help
on generate MARK stages tarball for not native arches in the near future.

This release review the download URL generation in order to correctly download
packages from the CDN77 Object Store.

In particular, it's pretty easy now to create a chroot where install packages
with or without *anise* metadata from an empty directory:

1. Ensure that fchroot is installed in your host/container:

```bash
$> anise i fchroot qemu yq4
# or for MARK users (with anise too if not available)
$> emerge fchroot qemu anise app-misc/yq-go
```

2. Create the target chroot directory:

```bash
$> mkdir /mychroot
```

3. Prepare the `anise` configuration file:

```bash
$> echo '
general:
  debug: false
  client_timeout: 0

# This option permits to
# read configuration files from
# host (when true) or inside chroot
# (when false).
config_from_host: false
# On generate a fresh stage3 we
# can ignore protected files.
config_protect_skip: true
system:
  tmpdir_base: "/var/tmp/anise"
  rootfs: /mychroot

subsets:
  enabled:
    - portage
    - devel

box:
  backend: fchroot
  fchroot_opts:
    verbose: true
    debug: false

repos_confdir:
  - /etc/luet/repos.conf.d
subsets_defdir:
  - /etc/luet/subsets.def.d

tar_flows:
  max_openfiles: 300
  copy_buffer_size: 128

repositories:
- name: "geaaru-repo-index"
  description: "Macaroni Repository index"
  type: "http"
  enable: true
  cached: true
  priority: 1
  urls:
    - "https://dl.macaronios.org/repos/geaaru-repo-index"
    - "https://cdn2.macaronios.org/repos/geaaru-repo-index"
    - "https://macaronios.mirror.garr.it/repos/geaaru-repo-index"
    - "https://cdn.macaronios.org/mottainai/geaaru-repo-index"
    - "https://raw.githubusercontent.com/geaaru/repo-index/gh-pages"
' > config.yml
```

In this configuration file, `anise` uses the chroot path to install
the medatada. If you want to create the chroot in a way similar to a
firmware without anise *metadata* you can set the option `config_from_host`
to *true*, modify the *anise* database path through the
`system.database_path` option and to modify the `repos_confdir` and
`subsets_dir` to read for a custom directory.
In this way the installed chroot will contains only the files of the
packages but with the anise database managed outside the chroot.
We will share a more detailed howto in the near future for this use case.

4. Install the needed repositories:

```bash
$> anise --config config.yml install --sync-repos -y \
        repository/mottainai-stable \
        repository/macaroni-terragon-testing \
        repository/macaroni-commons-testing
```

5. Update the repositories metadata (or just use `--sync-repos` option in the next point):

```bash
$> anise --config config.yml repo update
```

6. Install all the packages you need in your chroot:

```bash
$> anise --config config.yml install -y \
        system/luet-geaaru-thin \
        sys-apps/baselayout \
        sys-apps/lsb-release \
        app-misc/ca-certificates \
        system/entities \
        sys-apps/shadow \
        sys-apps/sed \
        app-shells/bash \
        sys-libs-2.2/glibc \
        sys-devel-11.3.0/gcc \
        sys-apps/coreutils \
        sys-apps/iproute2 \
        whip \
        whip-catalog \
        whip-profiles/macaroni \
        macaroni-release/terragon \
        virtual/sh \
        virtual/baseh \
        virtual-entities/base \
        app-admin/macaronictl-thin \
        app-arch/xz-utils
```

7. Ensure the generation of ld.so.cache:

```bash
$> anise --config config.yml box exec --rootfs /mychroot/ --entrypoint macaronictl env-update
```

8. Copy the anise configuration file on chroot in order to be used inside the chroot:

```bash
$> cp config.yml /mychroot/etc/luet/luet.yml
$> # Set rootfs path to /
$> yq4 '.system.rootfs = "/"' /mychroot/etc/luet/luet.yml -i
```

We use yet `luet` name until we will complete the refactor of `anise-build` tool.

9. Cleanup cache

```bash
$> anise --config config.yml cleanup
```

10. Use your chroot:

```bash
$> fchroot /mychroot /bin/bash
```

# Phoenix 24.08 is out!

The Phoenix 24.08 release is now based on MARK `next` branch.

As described before the new release 24.08 supplies a new way to configure NVIDIA
driver through the new features of the the `gpu-configurator` but how every new feature
is added it's better to follow the upgrading process at least the first time.

So, i will share a little howto about correctly upgrade the system in order to uses
from begin the boost from CDN77 services that requires the last release of `anise`
tool before execute the upgrade and later validate the NVIDIA driver setup before
reboot.

1. As described in our FAQ a fast way to upgrade the `anise` leave only the
minimal number of repositories:

```bash
$> anise repo disable macaroni-commons macaroni-phoenix
$> # the only available repos will be
$> anise repo list --enabled
geaaru-repo-index
  Macaroni Repository index
  Revision    14 - 2024-08-21 21:49:14 +0000 UTC
  Priority     1 - Type http
mottainai-stable
  Mottainai official Repository
  Revision   139 - 2024-09-14 16:47:38 +0000 UTC
  Priority    30 - Type http
```

2. Upgrade anise:

```bash
$> anise upgrade --sync-repos
```

3. Restore the disable reposistories:

```bash
$> anise repo enable macaroni-commons macaroni-phoenix
```

4. Upgrade the system:

```bash
$> anise upgrade --sync-repos
```

5. Merge the protected files:

```bash
$> macaronictl etc-update
```

6. Check the correct setup of NVIDIA driver (if you have an NVIDIA card)
   in order to verify that the installed kernel has the kernel NVIDIA
   driver active:

```bash
$> gpu-configurator show
Copyright (c) 2024 - Macaroni OS - gpu-configurator - 0.2.8
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
	- /etc/vulkan/icd.d
		* nvidia_icd.json

GBM Backend Librarires:
	- nvidia-drm_gbm.so
	- nvidia_gbm.so

NVIDIA Drivers:
	Active version: 555.58.02
	Available:
		- 555.58.02 (with kernel module)
NVIDIA Kernel Modules Available:
	* 555.58.02 - 6.1.109-macaroni
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Kernel Modules Active:
	* 555.58.02 - 6.1.109-macaroni
	* 550.54.14 - 6.7.9-zen1-macaroni
NVIDIA Open Kernel Modules Available:
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Open Kernel Modules Active:
	* 555.58.02 - 6.6.50-macaroni
```

In the example the kernel `6.1.109-macaroni` uses NVIDIA proprietary kernel driver and instead the
kernel `6.6.50-macaroni` uses the NVIDIA Open source driver. This is visible from the *Active* kernel
voices.

In order to switch from the Opensource to the proprietary kernel the steps are:

```bash
$> # Disable the opensource kernel
$> gpu-configurator nvidia kernel --purge --proprietary=false 555.58.02  6.6.50-macaroni
Removing kernel driver for kernel 6.6.50-macaroni and NVIDIA version 555.58.02...
Running /sbin/depmod -a 6.6.50-macaroni...
All done.
$> # Enable proprietary kernel
$> gpu-configurator nvidia kernel 555.58.02  6.6.50-macaroni
Running /sbin/depmod -a 6.6.50-macaroni...
All done.
```

The result of the *gpu-configurator show* will be:

```bash
...
NVIDIA Drivers:
	Active version: 555.58.02
	Available:
		- 555.58.02 (with kernel module)
NVIDIA Kernel Modules Available:
	* 555.58.02 - 6.1.109-macaroni
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Kernel Modules Active:
	* 555.58.02 - 6.1.109-macaroni
	* 555.58.02 - 6.6.50-macaroni
	* 550.54.14 - 6.7.9-zen1-macaroni
NVIDIA Open Kernel Modules Available:
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Open Kernel Modules Active:
	* 535.86.05 - 6.6.28-macaroni
```

If something goes wrong or if you want reset the setup of the NVIDIA driver you can:

```bash
$> # Force the cleanup of the setup of the NVIDIA driver
$> gpu-configurator nvidia configure --purge  555.58.02 --force
Purging version 555.58.02...
Nvidia generated files purged.
```

The *gpu-configurator show* will not shot an active version:

```bash
$> gpu-configurator show
Copyright (c) 2024 - Macaroni OS - gpu-configurator - 0.2.8
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

Vulkan ICD Configs Directories:
	- /usr/share/vulkan/icd.d
		* broadcom_icd.x86_64.json
		* intel_icd.x86_64.json
		* radeon_icd.x86_64.json
	- /etc/vulkan/icd.d
		* nvidia_icd.json

GBM Backend Libraries:	No libraries available.

NVIDIA Drivers:
	Active version: 
	Available:
		- 555.58.02 (with kernel module)
NVIDIA Kernel Modules Available:
	* 555.58.02 - 6.1.109-macaroni
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Kernel Modules Active:
	* 555.58.02 - 6.1.109-macaroni
	* 535.86.05 - 6.6.18-macaroni
	* 555.58.02 - 6.6.50-macaroni
	* 550.54.14 - 6.7.9-zen1-macaroni
NVIDIA Open Kernel Modules Available:
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Open Kernel Modules Active:
	* 535.86.05 - 6.6.28-macaroni
```

Now you can setup again the NVIDIA driver:

```bash
$> gpu-configurator nvidia configure 555.58.02 
Setting version 555.58.02...
Version 555.58.02 configured.
```

NOTE: By default, with a new setup of the NVIDIA driver we leave GBM Backend libraries
      disabled because we have see that could be a problem with some cards.

So, in order to enable GBM Backend:

```bash
$> gpu-configurator nvidia gbmlib --enable-driver
Operation done.
```

So, the final setup will be again:
```bash
# gpu-configurator show
Copyright (c) 2024 - Macaroni OS - gpu-configurator - 0.2.8
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
		* nvidia_icd.json
		* radeon_icd.x86_64.json
		* broadcom_icd.x86_64.json
		* intel_icd.x86_64.json
	- /etc/vulkan/icd.d
		* nvidia_icd.json

GBM Backend Librarires:
	- nvidia-drm_gbm.so
	- nvidia_gbm.so

NVIDIA Drivers:
	Active version: 555.58.02
	Available:
		- 555.58.02 (with kernel module)
NVIDIA Kernel Modules Available:
	* 555.58.02 - 6.1.109-macaroni
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Kernel Modules Active:
	* 555.58.02 - 6.1.109-macaroni
	* 555.58.02 - 6.6.50-macaroni
	* 550.54.14 - 6.7.9-zen1-macaroni
NVIDIA Open Kernel Modules Available:
	* 555.58.02 - 6.6.50-macaroni
NVIDIA Open Kernel Modules Active:
	* 535.86.05 - 6.6.28-macaroni
```

The same steps could be used to migrate to a different NVIDIA driver version.

It's important remember that after the NVIDIA settings change and/or kernel driver
changes you need to update the ld.so.cache:

```bash
$> macaronictl env-update
```

and rebuild initrd:

```bash
$> macaronictl kernel gi --set-links --grub --purge --all
```

Your system is ready for the reboot.

## Phoenix 24.08 major updates

In additional to the points described before, in evidence we have:

* Ego 2.8.8_pre20240817

* Metatools 1.3.8_pre20240807

* Apache 2.4.62

* OpenSSH 9.8_p1

* Python 3.9.20

* Nodejs 20.16.0

* Go 1.22.5

* Rust 1.80.0

* PHP 8.2.22

* Grafana 11.1.3

* Minio Object 2024.08.03.04.33.23 (new package)

* Virtualbox 7.0.20.163906

* XWayland 23.2.7

* Blender 4.2.0

* Incus 6.3

* Libreoffice 7.6.7.2

* ZFS 2.2.5

* Google Chrome 127.0.6533.99

* Vivaldi 6.8.3381.53

* Brave 1.68.137

See the complete changelog of [Phoenix 24.08 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.08-phoenix).

After the release 24.08 we have catched an issue in the Firefox 129.0 release that will be fixed very soon in the release 24.08.01
that break using of DRM Video (Netflix, etc.). Using Google Chrome or Firefox-bin package the issue is not present.

## Security CVE fixed in evidence:

CVE-2024-2961: glibc: the iconv() function overflow

CVE-2024-4577: PHP 8.1.28 and 8.2.19

CVE-2024-5585: PHP 8.1.28 and 8.2.19

CVE-2024-5458: PHP 8.1.28 and 8.2.19

CVE-2024-6387: openssh: allows for remote unauthenticated code execution, potentially providing attackers root privileges on affected systems.

CVE-2024-6409: openssh: signal handler race condition.

CVE-2024-40725: apache: source code disclosure with handlers configured via AddType


## Phoenix 24.08 NVIDIA Driver availables

The list of the supported NVIDIA drivers:

* 535.183.01

* 550.107.02

* 555.42.02

* 560.35.03


# Terragon 24.08 is out!

In evidence:

* Apache Server 2.4.62

* Nodejs 22.5.1

* Go 1.22.5

* Grafana 11.1.3

* Rust 1.80.0

See the complete changelog of [Terragon 24.08 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.08-terragon).

# Eagle 24.08 and 24.09 are out!

In evidence:

* Python 3.9.20

* Nginx 1.26.2

* Ego 2.8.8_pre20240817

* Metatools 1.3.8_pre20240807

* Nodejs 20.17.0

* PHP 8.2.23

* Grafana 11.2.0

* Prometheus 2.54.1

See the complete changelog of [Eagle 24.09 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v24.09-eagle).


# We are waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).


# What next?

Well, a lot of tasks are now pending but we want to share some hot points:

1. Release Phoenix 24.08.01 with Firefox bugfix, Virtualbox 7.1 and other

2. Complete the setup of stage3 tarballs and to have a webpage where download the last version.

3. In few months release the refactor of `anise-build` in order to start the ARM binary repositories.

4. Continue organize things in order to automatize other tasks of the MARK area.

5. Review CLANG/LLVM ebuilds

6. Migration Macaroni Terragon to GCC 12.3.0 and `mark-testing` branch.

And between the rest working with Pipewire and Wayland integration for the end of year release.

# Thanks

Many thanks to all Developers and Contributors that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
