---
author: "Daniele Rondina"
date: 2023-03-20
linktitle: Phoenix 23.03.01 is out!
menu:
  main:
title: Macaroni OS Phoenix 23.03.01 is out!
tags:
  - macaroni
  - release
  - phoenix
weight: 5
---


While we have worked on preparing the new ISOs for the release
23.03 we have figured out that was better to bump a new release
with the changes of the Calamares plugin to migrate our ISOs
to kernel 6.1.
In particular, the ISOs for Desktops have now the kernel 6.1.18
with built-in integration with new Realtek wifi cards. Unluckily
not yet the cards 8852b e 8852be that will be available on branch
6.2. We will try to support it on kernel 6.1 with an external
driver in the next release.

The Server ISOs maintain the kernel 5.10 LTS.

This is the reason for this delay and this micro-release.

We share in addition, that testing the Firefox release 1.109.0.1
that is been released on release 23.01 has figured out that
there are some issues with NVIDIA cards. The Firefox windows
were stalled often and only disabling hardware acceleration
fixed this issue. So, please, if users have some similar
experience with release 111 open an issue.

# The new Download page

We are very happy to share finally the new Download page where
retrieve the new ISOs is now available.
Inside the Download page we have tried to use a labels view that
we hope will help users to choose the right ISOs for their
requirements. Any feedback about this will help, thanks.

# macaronictl gets again power!

After receive tons of requests about integrate a `switch` command
to upgrade the kernel release, we are happy to share that the
time is arrived...

The `macaronictl` release `0.8.0` contains these new commands and improvements:

## macaronictl kernel switch
```shell
#> macaronictl k switch macaroni@6.1
Found kernel candidate kernel-6.1/macaroni-full-6.1.12...
Modules extra to install:
- kernel-6.1/lkrg-0.9.6
```

In summary this command search for all extra kernel modules
installed in the system and it tries to install the selected
kernel with all extra modules installed.

## macaronictl kernel modules

When the local repositories are synced this command permits
to retrieve all extra kernel modules availables in all kernel
branches:

```shell
 $ macaronictl kernel modules
|                PACKAGE                 | PACKAGE VERSION | KERNEL BRANCH | KERNEL VERSION |   REPOSITORY    |
|----------------------------------------|-----------------|---------------|----------------|-----------------|
| kernel-5.10/lkrg                       | 0.9.6+1         |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/nvidia-kernel-modules      | 525.85.05+3     |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/rtw89                      | 0.20220824+15   |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/virtualbox-guest-additions | 7.0.6.155176+3  |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/virtualbox-modules         | 7.0.6.155176+2  |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/zfs-kmod                   | 2.1.9+2         |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.15/nvidia-kernel-modules      | 525.85.05+2     |          5.15 | 5.15.102       | macaroni-funtoo |
| kernel-5.15/rtw89                      | 0.20220824+11   |          5.15 | 5.15.102       | macaroni-funtoo |
| kernel-5.15/virtualbox-modules         | 7.0.6.155176+2  |          5.15 | 5.15.102       | macaroni-funtoo |
| kernel-5.4/nvidia-kernel-modules       | 525.85.05+2     |           5.4 | 5.4.236        | macaroni-funtoo |
| kernel-5.4/rtw89                       | 0.20220824+11   |           5.4 | 5.4.236        | macaroni-funtoo |
| kernel-5.4/virtualbox-modules          | 7.0.6.155176+2  |           5.4 | 5.4.236        | macaroni-funtoo |
| kernel-5.4/zfs-kmod                    | 2.1.9+2         |           5.4 | 5.4.236        | macaroni-funtoo |
| kernel-6.1/lkrg                        | 0.9.6+2         |           6.1 | 6.1.18         | macaroni-funtoo |
| kernel-6.1/nvidia-kernel-modules       | 525.85.05+2     |           6.1 | 6.1.18         | macaroni-funtoo |
| kernel-6.1/virtualbox-guest-additions  | 7.0.6.155176+2  |           6.1 | 6.1.18         | macaroni-funtoo |
| kernel-6.1/virtualbox-modules          | 7.0.6.155176+2  |           6.1 | 6.1.18         | macaroni-funtoo |
| kernel-6.1/zfs-kmod                    | 2.1.9+2         |           6.1 | 6.1.18         | macaroni-funtoo |

```

or for a specific kernel branch:

```shell
 $ macaronictl kernel modules -b 5.10
|                PACKAGE                 | PACKAGE VERSION | KERNEL BRANCH | KERNEL VERSION |   REPOSITORY    |
|----------------------------------------|-----------------|---------------|----------------|-----------------|
| kernel-5.10/lkrg                       | 0.9.6+1         |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/nvidia-kernel-modules      | 525.85.05+3     |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/rtw89                      | 0.20220824+15   |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/virtualbox-guest-additions | 7.0.6.155176+3  |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/virtualbox-modules         | 7.0.6.155176+2  |          5.10 | 5.10.174       | macaroni-funtoo |
| kernel-5.10/zfs-kmod                   | 2.1.9+2         |          5.10 | 5.10.174       | macaroni-funtoo |
```

## macaronictl kernel available

Running this command with root privileged now permits us to see the installed kernel in bold.


# Whip power!

With little steps, we improve our knife swiss that is used to post-install
hooks and for validation.
In this release, we have added new important hooks to the whip catalog:

1. `linking.check`: This hook permit to validation of existing installation
   and search for libraries or binary with a broken link. So, if you find some
   issue with running this in a clean installation, please, open an issue.

   For example, on Eagle release I found this issue that permits to be fixed
   very fast until the fix will be available on the repository:
   ```shell
   $> whip h linking.check
   Checking directory /usr/lib64...
   Checking directory /usr/lib...
   Checking directory /usr/bin...
   /usr/bin/rsync
   Checking directory /bin...
   Checking directory /usr/sbin...
   Checking directory /usr/libexec...
   [linking.check] Completed correctly.
   ```

   The `rsync` binary seems broken:

   ```shell
   $> ldd /usr/bin/rsync
        linux-vdso.so.1 (0x00007ffcb294f000)
        libacl.so.1 => /lib64/libacl.so.1 (0x00007f9571d29000)
        libpopt.so.0 => not found
        libcrypto.so.1.1 => /usr/lib64/libcrypto.so.1.1 (0x00007f9571a00000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f9571846000)
        libz.so.1 => /lib64/libz.so.1 (0x00007f9571d0f000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f9571d0a000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f9571ce9000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f9571dd6000)
   ```

   and then it's very easy find the missing RDEPEND that must be fixed in the
   Macaroni repository:

   ```shell
   $> luet q belongs libpopt.so.0
   dev-libs/popt-1.16
   ```

   In this case the library `popt` is missing on runtime_deps and you need
   to install it directly:

   ```shell
   $> luet i dev-libs/popt 
   🚀 Luet 0.35.1-geaaru-g2d63605bff9ddee0171f4769c4e956317b910b56 2023-03-17 03:07:06 UTC - go1.20.2
   🏠 Repository:              geaaru-repo-index Revision:   5 - 2023-03-18 10:12:28 +0000 UTC
   🏠 Repository:       macaroni-commons-testing Revision: 137 - 2023-03-19 11:49:39 +0000 UTC
   🏠 Repository:    macaroni-funtoo-systemd-dev Revision: 451 - 2023-02-13 09:25:49 +0000 UTC
   🏠 Repository:              mottainai-testing Revision:  80 - 2023-03-17 21:34:59 +0000 UTC
   🧠 Solving install tree...
   🍦 [  1 of   1] [N] dev-libs/popt::macaroni-funtoo-systemd-dev                    - 1.16
   💂 Checking for file conflicts...
   ✔️  No conflicts found (executed in 285 µs).
   Do you want to continue with this operation? [y/N]: y
   🚚 Downloading 1 packages...
   📦 [  1 of   1] dev-libs/popt::macaroni-funtoo-systemd-dev                        - 1.16            # downloaded ✔ 
   🧠 Sorting 1 packages operations...
   🍻 Executing 1 packages operations...
   🍰 [  1 of   1] dev-libs/popt::macaroni-funtoo-systemd-dev                        - 1.16            # installed ✔ 
   ```

   And then no more issues available:

   ```shell
   $> whip h linking.check
   Checking directory /usr/lib64...
   Checking directory /usr/lib...
   Checking directory /usr/bin...
   Checking directory /bin...
   Checking directory /usr/sbin...
   Checking directory /usr/libexec...
   [linking.check] Completed correctly.
   ```

2. `postgresql.postgres_setup`: this hook permit to setup Postgres SQL setup
   with the SLOT selected. It's available on `lxd-compose-galaxy` a project
   that set up a standalone Postgresql server based on configuration variables
   that will be described very soon on the LXD Compose website.

The [whip-catalog](https://github.com/macaroni-os/whip-catalog) is a YAML files catalog
with bash/sh commands. If you find something missing or you have some idea about new hooks,
please open a PR.

# What next?

Well, few is changed after the release `23.03` so, the open points are
the same but we will push forward with a major priority the documentation.
I hope that we will cover a good documentation part for the next release.
Stay tuned!

# We waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).

