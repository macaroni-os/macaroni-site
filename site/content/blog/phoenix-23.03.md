---
author: "Daniele Rondina"
date: 2023-03-11
linktitle: Phoenix 23.03 is out!
title: Macaroni OS Phoenix 23.03 is out!
tags:
  - macaroni
  - release
  - phoenix
weight: 5
---

Finally, after two months of hard work, the release **Phoenix 23.03** is out and is the first Desktop release under the new `macaronios.org` domain.

In these two months, we had to follow infrastructure issues (broken hard disks) and create the new Macaroni network. This is one of the reasons we have skipped the release of February.

We want to thank again the GARR consortium that is now our primary mirror under our CDN and this will permit in the next weeks to expose again the ISOs download page and our LXD images.

This release doesn't expose extraordinary packages or upgrades but is a big
milestone for us because a lot of our work is under the hood and will be
better understood by the users in the next months when another big target
will be reached: the creation of the Macaroni documentation.

# A big milestone

The first major target reached is the first big rewrite of the Macaroni PMS
tool `luet` that now:

1. has a new solver completely rewritten that now respects repositories
   priorities, it's 100x fast and consumes few memory. The only limit at
   the moment is that until the `luet-build` binary will be rewritten the
   repository metadata will be yet with a big YAML file that must be exploded
   at least one time when is called the `luet repo update` command but this
   will be fixed in the near future. This is been an important result to
   begin ARM integration

2. the integration of the new solver has permitted the creation of the `mask`
   packages feature. It works in a similar way to Funtoo portage and will
   be described in detail in the Macaroni documentation in the near future.
   This is an important result because will permit to supply multiple versions
   of the same package and using the mask feature to hide a specific version
   to a target rootfs. You can think of a package like NVIDIA drivers where
   legacy cards need to have a specific version, or again if a user wants
   to create their packages and hide the Macaroni version, etc.

3. the `provides` support is been reviewed to permit a good means to
   manage correctly packages that are replaced. The correct way to use
   provide is to define a specific version in the provides and not a selector.
   For example:

   ```yaml
   provides:
    - category: cat
      name: foo
      version: 0.1.0
   ```

4. the `install` command now doesn't try to upgrade automatically the system;
   it just tries to resolve the dependencies and the packages selected and
   install them. This will permit to install of specific packages also when
   there are upgrades available.

5. the `luet` now permits to select of packages only by name. I really
   love this feature, because permits the reduction of the text written
   and speeds up the installation and research.
   For example:

   ```
   $> luet i app-emulation/lxd-compose
   ```

   becomes:

   ```
   $> luet i lxd-compose
   ```

6. `luet repo list` command has now a new look and option:

   ```shell

   $> luet repo list --urls
   geaaru-repo-index
     Geaaru Repository index
     Revision     4 - 2023-02-25 10:32:39 +0000 UTC
     Priority     1 - Type http
     Urls:
      * https://raw.githubusercontent.com/geaaru/repo-index/gh-pages
   macaroni-commons-dev
     Macaroni OS Commons Development Repository
     Revision   131 - 2023-03-08 22:17:57 +0000 UTC
     Priority    10 - Type http
     Urls:
      * https://dev.macaronios.org/macaroni-commons-dev/
   macaroni-commons-testing
     Macaroni OS Commons Testing Repository
     Priority    20 - Type http
     Urls:
      * https://dl.macaronios.org/repos/macaroni-commons-testing/
      * https://cdn2.macaronios.org/repos/macaroni-commons-testing/
      * https://macaronios.mirror.garr.it/repos/macaroni-commons-testing/

   ```

7. the original solvers are no more available and will be dropped
   from the code when also the `luet-build` binary will be rewritten.

8. The upgrades/installs output is now more clear with the cons that
   for now the download process is not parallel. This fixes the progress
   bar issues. We are working on following an output similar to portage that
   will be available in the next release `0.35.0`.

9. We have begun to work on commands that permit configuring `subsets`
   but they are to be complete.

10. it's now available a new command `luet query orphans` that permits
    retrieving all packages no more available in the enabled repository.

In general, now you can control with `luet` every action and package
of your system. If there are issues in the new solver you aren't blocked,
you can manually fix issues with hidden (and for expert users) commands
`luet miner` that will be described in the documentation.

This is what is been said from an user on testing the new `luet` binary:

>    *Feels like you took a Ford Fiesta and turned it into a Ferrari*

Really, thanks for this comment that will get me more power to go ahead.

A lot of new improvements and features are in our backlog.

An important thing that is not yet available is the possibility to downgrade
the packages if I user wants to convert a rootfs updated with a *testing*
repository to a *stable* repository. But is in our plan to add this feature soon.

**ATTENTION**: Due to all these changes, my suggestion is to upgrade this time the
luet binary manually with a download from the site and the follow
what is been described in the new FAQ section of the website.
```shell
$> sudo wget -O /usr/bin/luet https://github.com/geaaru/luet/releases/download/v0.34.2-geaaru/luet-v0.34.2-geaaru-Linux-x86_64
$> sudo chmod a+x /usr/bin/luet
```
We will improve this operation in the near future.

# macaronictl gets power!

The `luet` rewritten is not the only new improvement, the management CLI
of Macaroni OS, [macaronictl](https://github.com/macaroni-os/macaronictl)
gets more power:

1. `macaronictl env-update` is been completely written in Golang
   following the same Funtoo/Gentoo logic. This permits to have Macaroni
   OS systems to the need to install the `sys-apps/portage` package.
   This migration is not yet completely completed but will be so in the
   next release.

2. `macaronictl` tool has a new `etc-update` command written in Golang
   that uses the same `/etc/etc-update.conf` config and it implements
   a similar logic to the Portage `etc-update` command.

3. `macaronictl` tool has a new `kernel availables` command that
   permit to retrieve all kernel available from the enabled repositories
   and supply some metadata:

   ```shell
   $> macaronictl kernel availables --lts
   |  KERNEL  | KERNEL VERSION | PACKAGE VERSION |    EOL    | LTS  |  RELEASED  |  TYPE   |
   |----------|----------------|-----------------|-----------|------|------------|---------|
   | macaroni | 4.14.305       | 4.14.305        | Jan, 2024 | true | 2017-11-12 | vanilla |
   | macaroni | 5.10.168       | 5.10.168        | Dec, 2026 | true | 2020-12-13 | vanilla |
   | macaroni | 5.15.94        | 5.15.94         | Oct, 2026 | true | 2021-10-31 | vanilla |
   | macaroni | 5.4.231        | 5.4.231         | Dec, 2025 | true | 2019-11-24 | vanilla |
   | macaroni | 6.1.12         | 6.1.12          | Dec, 2026 | true | 2022-12-11 | vanilla |
   ```

   This will help with the feature that will be available in the
   next future to switch between kernels.

# Funtoo integration (experimental)

In the middle of all the new implementations we have released a new release of the
`luet-portage-converter` tool that is used normally to generate automatically updates
from our luet specs.

I hope that this will be a lovely experience for the Funtoo users.

I will leave users with a bit of suspense until I will write the documentation in
the next weeks but the new `luet-portage-converter sync` command will permits:

1. convert a Funtoo system to a Macaroni OS and get updates from Macaroni or
   restore the broken system.

2. sync with the Macaroni PMS the packages installed with `emerge` to the `luet`
   database and/or sync packages previously installed with `luet` and then upgraded
   with `emerge`.

Obviously, to use these features is needed a Macaroni OS with subsets `portage` and `devel` enabled.

**ATTENTION**: This new command is pretty experimental and must be used carefour.

# Domain migration again

I'm sorry but after the integration of the Consortium GARR I reviewed the stable
domains with a CDN chain.
I added in the FAQ section of the website some tips about easily upgrading the repositories.
I hope that things will be more stable now but using free services has some cons.

# What's new

This new release has some interesting updates:

- LXD 5.11 and LXC 5.0.2

- Libreoffice 7.5.0.3

- Firefox 1.109.0.1

- Brave 1.48.158

- Grafana 9.3.6 and Prometheus 2.42.0

- Blender 3.4.1

- ZFS 2.1.9

- KDE Framework 5.85.5 and KDE Plasma 5.22.5

- Openshot video editing tool updated to release 2.6.1

- Cinelerra is been dropped. The website has tons of forks without a tag and
  it seems hard to maintain.

- Grub 2.04 with patch related to the use of new e2fsprogs v.1.47.0. See [debian issue](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1031325).

- Open VMtools 12.1.5

- All kernels modules are been renamed following the naming convention: `kernel-<kernel-branch>` as
  category. This will help searching and `macaronictl` integration.
  Always related to the kernel, the string `LTS` is been removed from kernel
  packages. The LTS information is now available over the package annotations.

- See the [release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.03-phoenix) page for the detail of all updates.

# What next?

Hereinafter, our hot points for the next releases:

1. Drop support to Python 2.7 from Phoenix and leave Python 3.7 only.
   We will upgrade to Python 3.9 later.

2. Continue to work begun on writing documentation and FAQ for users.

3. Begin the rewrite of `luet-build` binary and improve look&feel
   of the `luet` output.

4. Add the new ISOs webpage and prepare the release of the ISO 23.03.
   We need to wait for the sync of the GARR mirror and the propagation.

5. Add new features to `luet-portage-converter` to manage multiple versions
   of the same package.

6. Add new features to `macaronictl` tool

7. Add Macaroni OS LXD images to `images.linuxcontainers.org`.

# We waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
