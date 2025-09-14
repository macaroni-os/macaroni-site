---
title: "From Phoenix to MARK"
type: docs
---

# From Phoenix to MARK and return

The first thing to check before working with MARK from a Phoenix or Terragon rootfs
is the *subsets* configured on `anise`:

```shell
$> anise subsets list
🍨 Subsets enabled:
 * portage
   Portage metadata and files.

 * devel
   Includes and devel files. Needed for compilation.

 * desktop
```

Excluding the *desktop* subset that is present only on Phoenix release,
the mandatory subsets are *portage* and *devel*. If this subsets are not
present, then it's needed reinstall all packages after enable the missed
(there is a whip command that helps on this) or reinstall Macaroni OS from
zero.

The second thing is to install all packages used in MARK:

```shell
$> anise i elt-patches patch autoconf-archive gcc-config \
  diffutils binutils binutils-libs which make portage m4 \
  sandbox ego automake sys-devel-latest/autoconf \
  anise-portage-converter wget pkgs-checker entities \
  sys-apps/whip-catalog whip virtual/base git \
  ca-certificates linux-headers unzip pkgconf \
  virtual/pkgconfig

```

Ensure that the `/etc/ego.conf` file contains the mark branch
correct:

```
$> cat /etc/ego.conf
[global]
release = mark-iii
sync_base_url = https://github.com/macaroni-os/{repo}
python_kit_profile = mark
```

At this point there are two different way to setup MARK tree:

a) using the `meta-repo` package from Phoenix that download the mark
   tree used on build Phoenix packages to a specific pinned hashes. In this
   case, if it's used later the `ego sync` command it's better clean
   the kits directory before run the *sync*:

```shell
$> anise i meta-repo
$> rm -rf /var/git/meta-repo/kits/
# Avoid this command if you want to use the tree used in Phoenix
$> ego sync
```

b) setup a fresh meta-repo installation without using Phoenix package:

```shell
$> mkdir -p /var/git
$> cd /var/git
$> git clone https://github.com/macaroni-os/meta-repo -b mark-iii
$> chown portage:portage -R .
$> ego sync
```

Now you can check with ego if all is ok:

```shell

# ego profile list

=== arch: ===

    (x86-64bit*), x86-64bit-papa

=== build: ===

    current, (mark*), musl, next

=== subarch: ===

    amd64-bulldozer, amd64-excavator, amd64-jaguar, amd64-k10
    amd64-k8, amd64-k8+sse3, amd64-piledriver, amd64-pumaplus
    amd64-steamroller, amd64-zen, amd64-zen2, amd64-zen3, atom_64
    btver1_64, core-avx-i, core2_64, corei7, generic_64*, generic_64-v2
    generic_64-v3, generic_64-v4, intel64-alderlake, intel64-broadwell
    intel64-haswell, intel64-ivybridge, intel64-nehalem, intel64-rocketlake
    intel64-sandybridge, intel64-silvermont, intel64-skylake, intel64-skylake-avx512
    intel64-tremont, intel64-westmere, native_64, nocona, opteron_64
    xen-pentium4+sse3_64

=== flavor: ===

    core*, desktop, hardened, minimal, server, workstation

=== mix-ins: ===

    X, amazon-ec2, audio, btrfs, console-extras, dvd, encrypted-root
    gfxcard-amdgpu, gfxcard-ancient-ati, gfxcard-intel, gfxcard-intel-classic
    gfxcard-intel-iris, gfxcard-kvm, gfxcard-nouveau, gfxcard-nvidia
    gfxcard-nvidia-legacy, gfxcard-older-ati, gfxcard-panfrost
    gfxcard-radeon, gfxcard-raspi4, gfxcard-vmware, gnome, hardened
    ime-backend-anthy, ime-backend-bamboo, ime-backend-chewing
    ime-backend-hangul, ime-backend-libpinyin, ime-backend-m17n
    ime-backend-mozc, ime-backend-rime, ime-backend-skk, ime-backend-unikey
    ime-backends-chinese, ime-backends-japanese, ime-backends-korean
    ime-backends-table, ime-backends-vietnamese, kde-plasma-5
    kerberos, kernel-bookworm, kernel-forky, kernel-funtoo, kernel-sid
    kernel-trixie, lvm-root, lxqt, mdadm-root, media, media-pro
    mediadevice-audio-consumer, mediadevice-audio-pro, mediadevice-base
    mediadevice-video-consumer, mediadevice-video-pro, mediaformat-audio-common
    mediaformat-audio-extra, mediaformat-gfx-common, mediaformat-gfx-extra
    mediaformat-video-common, mediaformat-video-extra, no-emul-linux-x86
    no-systemd, openvz-host, print, pulseaudio, python3-only, selinux
    stage1, vmware-guest, wayland, xfce

```

and it's important that this profile will be always present:

```
$> cat /etc/portage/make.profile/parent | grep python-kit
core-kit:funtoo/kits/python-kit/mark
```

If it isn't present check that on `/etc/ego.conf` is present the row about *python_kit_profile*.

> To speedup the *emerge* solver remember to execute:
> ```
> for i in $(ls -1 /var/git/meta-repo/kits/) ; do egencache --update --repo=$i ; done
> ```


### Your MARK tree is now ready!!!

Now you can mix `anise` and `emerge` as you prefer. Here, a little example:

```shell
$> emerge vim -pv

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild  N     ] app-eselect/eselect-vi-1.1.9-r1::portage-kit  7 KiB
[ebuild  N     ] dev-libs/libltdl-2.4.6::core-kit  USE="-static-libs" 951 KiB
[ebuild  N     ] app-editors/vim-core-9.1.1420::editors-kit  USE="acl nls -minimal" 18,412 KiB
[ebuild  N     ] sys-devel/libtool-2.4.6-r5:2::core-kit  USE="-vanilla" 0 KiB
[ebuild  N     ] dev-libs/libsodium-1.0.18:0/23::dev-kit  USE="asm urandom -minimal -static-libs" CPU_FLAGS_X86="-aes -sse4_1" 1,875 KiB
[ebuild  N     ] app-editors/vim-9.1.1420::editors-kit  USE="acl crypt nls python -X -cscope -debug -gpm -lua -minimal -perl -racket -ruby (-selinux) -sound -tcl -terminal -vim-pager" LUA_SINGLE_TARGET="lua5-3 -lua5-1 -lua5-2 -lua5-4 -luajit" PYTHON_SINGLE_TARGET="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 0 KiB
[ebuild  N     ] app-vim/gentoo-syntax-20190609::portage-kit  USE="-ignore-glep31" 18 KiB

Total: 7 packages (7 new), Size of downloads: 21,262 KiB
```

If you want just *emerge* vim and not the dependencies, *anise* will helps you:

```shell
$> anise i eselect-vi libltdl vim-core libtool libsodium gentoo-syntax
🚀 Luet 0.41.1-geaaru-gc4815024d03bc88794c76a165ba4018ae07296a3 2025-01-23 01:05:15 UTC - go1.23.1
🏠 Repository:              geaaru-repo-index Revision:   15 - 2025-01-04 18:10:44 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision:  280 - 2025-09-08 23:25:57 +0000 UTC
🏠 Repository:       macaroni-phoenix-testing Revision: 1738 - 2025-09-13 16:48:10 +0000 UTC
🏠 Repository:                           mark Revision:   66 - 2025-09-06 08:54:42 +0000 UTC
🧠 Solving install tree...
🍦 [  1 of  10] [N] app-editors/vim::macaroni-phoenix-testing                     - 9.1.1420
🍦 [  2 of  10] [N] app-editors/vim-core::macaroni-phoenix-testing                - 9.1.1420
🍦 [  3 of  10] [N] app-eselect/eselect-vi::macaroni-phoenix-testing              - 1.1.9
🍦 [  4 of  10] [N] app-vim/gentoo-syntax::macaroni-phoenix-testing               - 20190609+1
🍦 [  5 of  10] [N] dev-libs/libltdl::macaroni-phoenix-testing                    - 2.4.6+2
🍦 [  6 of  10] [N] dev-libs/libsodium::macaroni-phoenix-testing                  - 1.0.18+1
🍦 [  7 of  10] [N] dev-util/cscope::macaroni-phoenix-testing                     - 15.9+1
🍦 [  8 of  10] [N] sys-devel-2.69/autoconf::macaroni-phoenix-testing             - 2.69+3
🍦 [  9 of  10] [N] sys-devel-2/libtool::macaroni-phoenix-testing                 - 2.4.6+2
🍦 [ 10 of  10] [N] sys-libs/gpm::macaroni-phoenix-testing                        - 1.20.7+1
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 10249 µs).
Do you want to continue with this operation? [y/N]: y
🚚 Downloading 10 packages...
📦 [  1 of  10] app-eselect/eselect-vi::macaroni-phoenix-testing                  - 1.1.9           # downloaded ✔ 
📦 [  2 of  10] dev-util/cscope::macaroni-phoenix-testing                         - 15.9+1          # downloaded ✔ 
📦 [  3 of  10] app-editors/vim::macaroni-phoenix-testing                         - 9.1.1420        # downloaded ✔ 
📦 [  4 of  10] app-editors/vim-core::macaroni-phoenix-testing                    - 9.1.1420        # downloaded ✔ 
📦 [  5 of  10] dev-libs/libsodium::macaroni-phoenix-testing                      - 1.0.18+1        # downloaded ✔ 
📦 [  6 of  10] sys-libs/gpm::macaroni-phoenix-testing                            - 1.20.7+1        # downloaded ✔ 
📦 [  7 of  10] app-vim/gentoo-syntax::macaroni-phoenix-testing                   - 20190609+1      # downloaded ✔ 
📦 [  8 of  10] dev-libs/libltdl::macaroni-phoenix-testing                        - 2.4.6+2         # downloaded ✔ 
📦 [  9 of  10] sys-devel-2.69/autoconf::macaroni-phoenix-testing                 - 2.69+3          # downloaded ✔ 
📦 [ 10 of  10] sys-devel-2/libtool::macaroni-phoenix-testing                     - 2.4.6+2         # downloaded ✔ 
🧠 Sorting 10 packages operations...
🍻 Executing 10 packages operations...
🍰 [  1 of  10] app-editors/vim-core::macaroni-phoenix-testing                    - 9.1.1420        # installed ✔ 
🍰 [  2 of  10] app-eselect/eselect-vi::macaroni-phoenix-testing                  - 1.1.9           # installed ✔ 
🍰 [  3 of  10] dev-libs/libltdl::macaroni-phoenix-testing                        - 2.4.6+2         # installed ✔ 
🍰 [  4 of  10] dev-libs/libsodium::macaroni-phoenix-testing                      - 1.0.18+1        # installed ✔ 
🍰 [  5 of  10] dev-util/cscope::macaroni-phoenix-testing                         - 15.9+1          # installed ✔ 
🍰 [  6 of  10] sys-devel-2.69/autoconf::macaroni-phoenix-testing                 - 2.69+3          # installed ✔ 
🍰 [  7 of  10] sys-libs/gpm::macaroni-phoenix-testing                            - 1.20.7+1        # installed ✔ 
🍰 [  8 of  10] sys-devel-2/libtool::macaroni-phoenix-testing                     - 2.4.6+2         # installed ✔ 
🍰 [  9 of  10] app-editors/vim::macaroni-phoenix-testing                         - 9.1.1420        # installed ✔ 
🍰 [ 10 of  10] app-vim/gentoo-syntax::macaroni-phoenix-testing                   - 20190609+1      # installed ✔ 
🎊 All done.

```

in the previous command *vim-core* inject *vim* too, and so running again the *emerge* command will be see from
Portage like a rebuild where user can choice specific CPU flags and/or other:

```shell
$> emerge vim -pv

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild   R    ] app-editors/vim-9.1.1420::editors-kit  USE="acl crypt nls python -X* -cscope* -debug -gpm* -lua -minimal -perl -racket -ruby (-selinux) -sound -tcl -terminal -vim-pager" LUA_SINGLE_TARGET="lua5-3* -lua5-1 -lua5-2 -lua5-4 -luajit" PYTHON_SINGLE_TARGET="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 18,412 KiB

Total: 1 package (1 reinstall), Size of downloads: 18,412 KiB
```

> NOTE: after that you have installed a package with *emerge* in order to have a better synchronization
>       with *anise* you need to run this command:

```shell
$> anise-portage-converter sync
```

or just to see what packages will be added:

```shell
$> anise-portage-converter sync --dry-run

```

any new package (and not re-emerged) will be added in the anise database with the special *scm* repository.

About working with anise and emerge together read also this [chapter]({{< relref "/docs/mark/sambuca-diff#2-use-flags-not-aligned-to-mark-profiles" >}}).

## Add an anise package to Portage world file

At the moment, the installation of a package with *anise` doesn't update Portage world file.

So, if you want to keep these things aligned you can run this command:

```
$> anise-portage-converter portage add-world  --help
Add one or more packages to Portage world file.

Add a package with category and name:
$> anise-portage-converter portage add-world cat/foo

Add a package with slot (when != 0):
$> anise-portage-converter portage aw cat/foo:2

Add a package with repository:
$> anise-portage-converter portage aw cat/foo::core-kit

Add a package with slot and repository:
$> anise-portage-converter portage aw cat/foo:2::core-kit

NOTE: The command automatically avoid to add duplicate.

Usage:
  anise-portage-converter portage add-world [package1] ... [packageN] [flags]
```

This step is not mandatory but update files used by Portage to identify
packages no more needed after a particular upgrade.


## Upgrade a MARK synced system with `anise`

As described in the previous chapter running *anise-portage-converter* add the emerged
packages in the anise database with *scm* as repository.

If you want using `anise upgrade` to update your system remember that the Macaroni
binary packages didn't follow a specific profile and USE flags could be different from
your setup.

We suggest to run always `anise-portage-converter sync` before running `anise upgrade`
as best practice.

So, if you have merged for example *htop* and other dependencies, running *anise upgrade*
will show something like this:

```shell
$> anise upgrade
🚀 Luet 0.41.1-geaaru-gc4815024d03bc88794c76a165ba4018ae07296a3 2025-01-23 01:05:15 UTC - go1.23.1
🏠 Repository:              geaaru-repo-index Revision:   15 - 2025-01-04 18:10:44 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision:  280 - 2025-09-08 23:25:57 +0000 UTC
🏠 Repository:       macaroni-phoenix-testing Revision: 1738 - 2025-09-13 16:48:10 +0000 UTC
🏠 Repository:                           mark Revision:   66 - 2025-09-06 08:54:42 +0000 UTC
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍬 [  1 of   5] [U] dev-util/meson::macaroni-phoenix-testing                      - 1.7.0+1 [1.7.0::scm]
🍬 [  2 of   5] [U] dev-util/re2c::macaroni-phoenix-testing                       - 1.1.1+2 [1.1.1::scm]
🍬 [  3 of   5] [U] sys-devel-2.69/autoconf::macaroni-phoenix-testing             - 2.69+3 [2.69::scm]
🍬 [  4 of   5] [U] sys-libs/ncurses::macaroni-phoenix-testing                    - 6.5+2 [6.5::scm]
🍬 [  5 of   5] [U] sys-process/htop::macaroni-phoenix-testing                    - *3.4.1 [3.4.1::scm]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 217813 µs).
Do you want to continue with this operation? [y/N]: 
```

Where the *scm* package will be normally replaced by anise because the hash of the metadata
will be different from the metadata added with *anise-portage-converter*.

In order to avoid the upgrade of *htop* package you need to mask the package with these commands:

```
$> mkdir -p /etc/luet/mask.d
$> echo "
enabled: true
rules:
- sys-process/htop::macaroni-phoenix-testing # or just sys-process/htop
" > /etc/luet/mask.d/00-my.yml
```

The result will be:

```shell
$> anise upgrade
🚀 Luet 0.41.1-geaaru-gc4815024d03bc88794c76a165ba4018ae07296a3 2025-01-23 01:05:15 UTC - go1.23.1
🏠 Repository:              geaaru-repo-index Revision:   15 - 2025-01-04 18:10:44 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision:  280 - 2025-09-08 23:25:57 +0000 UTC
🏠 Repository:       macaroni-phoenix-testing Revision: 1738 - 2025-09-13 16:48:10 +0000 UTC
🏠 Repository:                           mark Revision:   66 - 2025-09-06 08:54:42 +0000 UTC
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍬 [  1 of   4] [U] dev-util/meson::macaroni-phoenix-testing                      - 1.7.0+1 [1.7.0::scm]
🍬 [  2 of   4] [U] dev-util/re2c::macaroni-phoenix-testing                       - 1.1.1+2 [1.1.1::scm]
🍬 [  3 of   4] [U] sys-devel-2.69/autoconf::macaroni-phoenix-testing             - 2.69+3 [2.69::scm]
🍬 [  4 of   4] [U] sys-libs/ncurses::macaroni-phoenix-testing                    - 6.5+2 [6.5::scm]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 26751 µs).
Do you want to continue with this operation? [y/N]:
```

As visible the htop will be not replaced by the binary version available on *macaroni-phoenix-testing*
repository.

In addition, if an emerged version of the package will have a version major of the
version available on Phoenix repository *anise* will keep the *scm* version if it's not
used `--deep` option.

> **NOTE:** If you prefer use more *anise* keep attention of packages splitted in anise.


## Using `anise` to restore system

*Have you ever tried to restore a Portage broken system? Yes, you can!*

Obviously, if the system is broken and you can't enter on it *anise* doesn't magic.
But if the system became broken while your upgrade process for bug or anything or you
have used a live ISO to enter in the broken chroot you can use *anise* to restore it.

In order to explain the behaviour we tried to use a container and break the system.

#### Scenario 1: Portage is dead!

```shell
$> # Considering that we can't just remove portage
$> emerge --unmerge portage 
 * This action can remove important packages! In order to be safer, use
 * `emerge -pv --depclean <atom>` to check for reverse dependencies before
 * removing packages.
 * Not unmerging package sys-apps/portage-3.0.14-r13 since there is no valid
 * reason for Portage to unmerge itself.

>>> No packages selected for removal by unmerge
$> # The fun begin....
$> rm -rf /usr/lib/portage/*
```

and now :boom::

```shell
$> emerge portage -pv

These are the packages that would be merged, in order:

Calculating dependencies \/bin/bash: line 1: /usr/lib/portage/python3.9/ebuild.sh: No such file or directory
... done!

!!! All ebuilds that could satisfy "portage" have been masked.
!!! One of the following masked packages is required to complete your request:
- sys-apps/portage-3.0.14-r13::portage-kit (masked by: corruption)

For more information, see the MASKED PACKAGES section in the emerge
man page or refer to the Gentoo Handbook.
```

This scenario is pretty easy to recover:

```shell
$> anise miner ri sys-apps/portage
📦 [  1 of   1] sys-apps/portage::macaroni-phoenix-testing                        - 3.0.14+6        # downloaded ✔ 
🍰 [  1 of   1] sys-apps/portage::macaroni-phoenix-testing                        - 3.0.14+6        # installed ✔ 
Executing finalizer for sys-apps/portage-3.0.14+6
🐚  Executing finalizer on  / /bin/bash [-c eval 'mkdir -p /var/tmp/portage || true' && entities merge --specs-dir /usr/share/macaroni/entities/ -e portage && eval 'chown portage:portage /var/tmp/portage -R || true']
Merged users portage.
Merged group portage.
Merged shadow portage.
Merged gshadow portage.
All done.

```

and now Portage is back:

```shell
$> emerge portage -pv

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild  N     ] sys-libs/libxcrypt-2.4::security-kit  354 KiB
[ebuild  N     ] sys-apps/install-xattr-0.7::portage-kit  16 KiB
[ebuild  N     ] dev-util/gperf-3.1::dev-kit  1,188 KiB
[ebuild  N     ] dev-libs/popt-1.16-r2::dev-kit  USE="nls -static-libs" 687 KiB
[ebuild  N     ] dev-python/installer-0.5.1-r1::python-modules-kit  USE="-test" PYTHON_TARGETS="python3_9 -pypy3 -python3_10 -python3_7 -python3_8" 900 KiB
[ebuild  N     ] dev-python/commonmark-0.9.1::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 94 KiB
[ebuild  N     ] dev-python/tomli-2.0.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 15 KiB
[ebuild  N     ] net-misc/rsync-3.4.1::net-kit  USE="acl iconv ipv6 ssl xattr zstd -examples -libressl -lz4 -stunnel -system-zlib -xxhash" CPU_FLAGS_X86="sse2" 865 KiB
[ebuild  N     ] dev-python/gpep517-16::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 19 KiB
[ebuild  NS    ] app-text/docbook-xml-dtd-4.5-r1:4.5::text-kit [4.2-r2:4.2::core-kit] 97 KiB
[ebuild  N     ] dev-python/flit_core-3.11.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 51 KiB
[ebuild  N     ] dev-python/wheel-0.45.1::python-modules-kit  PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 106 KiB
[ebuild  N     ] dev-python/markupsafe-3.0.2::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 21 KiB
[ebuild  N     ] dev-python/jinja-3.1.6::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 240 KiB
[ebuild  N     ] sys-apps/systemd-tmpfiles-256::core-server-kit  USE="(-selinux)" 15,277 KiB
[ebuild   R    ] sys-apps/portage-3.0.14-r13::portage-kit [3.0.14-r13::core-kit] USE="(ipc) native-extensions xattr -apidoc -build -doc -gentoo-dev -rsync-verify (-selinux) -test" PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 1,413 KiB

Total: 16 packages (14 new, 1 in new slot, 1 reinstall), Size of downloads: 21,333 KiB
```


If you have additional scenarios that could help users feel free to create a PR
for this page!

#### Scenario 2: Break glibc!

To simulate a glibc library broken we remove *glibc*:

```shell
$> emerge --unmerge glibc -pv
 * This action can remove important packages! In order to be safer, use
 * `emerge -pv --depclean <atom>` to check for reverse dependencies before
 * removing packages.

>>> These are the packages that would be unmerged:


!!! 'sys-libs/glibc' (virtual/libc) is part of your system profile.
!!! Unmerging it may be damaging to your system.


 sys-libs/glibc
    selected: 2.33-r4 
   protected: none 
     omitted: none 

All selected packages: =sys-libs/glibc-2.33-r4

>>> 'Selected' packages are slated for removal.
>>> 'Protected' and 'omitted' packages will not be removed.

test-phoenix ~ #  emerge --unmerge glibc 
 * This action can remove important packages! In order to be safer, use
 * `emerge -pv --depclean <atom>` to check for reverse dependencies before
 * removing packages.


!!! 'sys-libs/glibc' (virtual/libc) is part of your system profile.
!!! Unmerging it may be damaging to your system.


 sys-libs/glibc
    selected: 2.33-r4 
   protected: none 
     omitted: none 

All selected packages: =sys-libs/glibc-2.33-r4

>>> 'Selected' packages are slated for removal.
>>> 'Protected' and 'omitted' packages will not be removed.

>>> Waiting 5 seconds before starting...
>>> (Control-C to abort)...
>>> Unmerging in: 5 4 3 2 1
>>> Unmerging (1 of 1) sys-libs/glibc-2.33-r4...
>>> needed   obj /lib64/ld-2.33.so
>>> needed   sym /lib64/ld-linux-x86-64.so.2
>>> needed   obj /lib64/libc-2.33.so
>>> needed   sym /lib64/libc.so.6
>>> needed   obj /lib64/libcrypt-2.33.so
>>> needed   sym /lib64/libcrypt.so.1
>>> needed   obj /lib64/libdl-2.33.so
>>> needed   sym /lib64/libdl.so.2
>>> needed   obj /lib64/libpthread-2.33.so
>>> needed   sym /lib64/libpthread.so.0
>>> needed   obj /lib64/libresolv-2.33.so
>>> needed   sym /lib64/libresolv.so.2
>>> needed   obj /lib64/librt-2.33.so
>>> needed   sym /lib64/librt.so.1
>>> needed   obj /lib64/libutil-2.33.so
>>> needed   sym /lib64/libutil.so.1
<<< !needed  obj /lib64/libresolv-2.33.so
<<< !needed  sym /lib64/libresolv.so.2
/usr/bin/python3.9: error while loading shared libraries: libm.so.6: cannot open shared object file: No such file or directory
 * ERROR: sys-libs/glibc-2.33-r4::core-kit failed (postrm phase):
 *   filter-bash-environment.py failed
...
$> # Force remove of the libc library
$> rm /lib64/libc.so.6
$> ls
ls: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory
$> bash
bash: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory
```

*anise* is built statically, this permit to execute the command and install packages
also when the rootfs became unusable:

```shell
$> anise miner ri glibc
📦 [  1 of   1] sys-libs-2.2/glibc::macaroni-phoenix-testing                      - 2.33+5          # downloaded ✔ 
🍰 [  1 of   1] sys-libs-2.2/glibc::macaroni-phoenix-testing                      - 2.33+5          # installed ✔ 
$> ls -l
total 0
```
