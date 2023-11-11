---
author: "Daniele Rondina"
date: 2023-11-11
linktitle: Phoenix 23.11 is out!
title: New Phoenix 23.11 based on Funtoo Next!
menu:
  main:
tags:
  - macaroni
  - release
  - phoenix
weight: 5
---

**We are happy to announce that after three intense months we have finally
 completed the migration of Macaroni Phoenix to a Funtoo Next based system.**

This is a really good milestone for us because after two years we have been
a big step ahead, before becoming an independent project, entering in the
Docker Sponsored program, and now with the first big release upgrade.
The world is buggy so we are sure that something will be also present in
this first big step but we hope the community and the users will be happy
about how things grow. We have a lot of things to do, so stay tuned!

At the moment, the Funtoo Community officially doesn't support the upgrade
of a Funtoo 1.4 filesystem to Funtoo Next and we are happy to have a way that
permits, eventually with a more tested tuning and with feedback from users, to help
Funtoo users in this. We think that is important to create synergy between
the community groups because only together we can grow fast and strong.
This is the reason we have worked a lot to have a first version of the
`anise-portage-converter` tool that could be easily used to work with
`anise` (the new name of the `luet` tool) and `emerge`.

So, to help Funtoo users to identify the differences between Funtoo and Macaroni
we have added a new [Funtoo Zone](https://www.macaronios.org/docs/funtoo/) area
in the documentation page that wants to help to see how the two worlds can work
together.

So, trying to organize the tons of pieces of information we have to share we
divide these by argument hereinafter.

# Phoenix 23.11, the reborn!

The Phoenix release is been our first release of Macaroni OS and only later with
the Terragon and Eagle release we have found a better way to organize the build
process to reduce the build time.

So, for this release, a lot is been done under the hood to reorganize the build
pipeline to help integrate new software in the next releases. Just you can
consider that the `seed/funtoo-base` of the 1.4-prime release was based on
stage3-gnome with a lot of profiles enabled. This was expensive as time, it took
about 16 hours to build that seed every time. Now we start from a Funtoo stage3
base that takes about 4 hours the build and all other packages are divided into
different "races". We tried to divide the races to divide the groups of packages
and frameworks to build, for example, the Gtk stuff, qt stuff, xorg stuff, etc.
This will permit to user to experiment on integrating new versions in a clearer way.

In this rework, we have rebuilt all packages and others will arrive in the next
releases. At the moment, the new release contains about 2800 packages but we
have decided to follow the kits paradigm for the games. We building the new
`macaroni-games` repository that will supply the Games and the emulators instead
of having them in the main repository.

Unluckily, when this big job started the GCC 12 was not available yet in Funtoo
tree, for this reason, we have decided to stay with GCC 11 for now and because
we have introduced a lot of experiments and patches that were too expensive to
over buffer our time with a GCC upgrade in the middle. In particular, for what
is possible we want to start a path where Macaroni OS is not only a user of
Funtoo but it's also a contributor.

To follow this idea, we are organizing these tasks:

1. We have created a new repository `labs` where begin to introduce new packages
  and new autogen that will be added in the Funtoo tree after a first validation.
  In particular, working with autogen Budgie Desktop packages we have found that
  these packages require Gnome 40 at least and we want, really, to try to help the
  Funtoo Community on move ahead with these kinds of stuff that are very very complex
  and we think that to have a parallel tree where working and break everything could
  be good before begin trying to open single PR with a big impact and not easy to test.

2. In this release, we have patched the *vala.eclass* to have all packages using
   Vala 0.54.1 and avoid to have multiple releases. This had a lot of impacts in
   the Gnome stuff and a lot of patches are been created. These types of changes
   are not so easy to send to the Funtoo Community without validating what happens
   in a big park of packages. For this reason, Shotwell and a few other Gnome
   packages aren't yet been ported but will work on these soon.

3. We starting to integrate Wayland to Xorg to be available to Funtoo users
   we hope soon.

Part of all patches are available and/or will be organized to be easily integrated
with Funtoo when ready. The list is available [here](https://github.com/macaroni-os/macaroni-funtoo/blob/phoenix/packages/seeds/funtoo-kits/patches4funtoo.sh).

Unluckily, we do have not sufficient space and budget to maintain a temporary
`macaroni-phoenix-legacy` repository based on Funtoo 1.4 to help users in the
migration. So, with this release, the old desktop release will no longer be
supported but we describe the upgrade process clearly for the migration.

Thanks to the job done by the Funtoo Community and our work, between the the big
changes of this new release we have:

    * GCC 11.3.0

    * Python 3.9

    * Ruby 3.1.4

    * Golang 1.21.3

    * PHP 8.2

    * LXD 5.18

    * Docker 24.0.6 (thanks to @siris to autogen this package)!

    * Docker Compose 2.21.0

    * Firefox 118.0.2: we have finally the compiled version with our branding

    * Google Chrome 118.0.5993.70

    * Brave 1.59.117

    * Vivaldi 6.2.3105.58

    * Thunderbird 115.3.2

    * MongoDB Compass 1.40.3

    * Libreoffice 7.6.2.1

    * Inkscape 1.3

See the complete changelog of [Phoenix 23.11 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v23.11-phoenix).


## Know issues

These the know issues after the upgrades that will be fixed in the next releases:

1. the new Inkscape release v1.3 has an annoying warning about using the `sans-serif`
   that seems related to the upstream issue [#4651](https://gitlab.com/inkscape/inkscape/-/issues/4651).

2. the games will be available only in the next weeks after that the first stable
   release of the `macaroni-games` repository will be available. So, the installed
   games (Wesnoth, Warhammer, etc.) could be broken after the upgrade.

3. The package ArangoDB needs maintenance as been reported in the Funtoo
   issue [#FL-11506](https://bugs.funtoo.org/browse/FL-11506) and will be not available
   after the upgrade. We will take care of this soon.

# New versions of the Package Manager

In order to rename the our Package Manager `luet` in `anise` the new releases is installed
with the link `/usr/bin/anise` to begin migration all tasks and pipeline with the new name.

In particular, are been released two versions:

* [v0.40-0-geaaru](https://github.com/geaaru/luet/releases/tag/v0.40.0-geaaru):

        - the render engine using Helm framework is been totally rewritten and will be used
          soon to complete the refactor of the solver for the build phase of the `luet-build`
          tool

        - a new command `luet-build tree render` is been added in order to have a preview of
          the `build.yaml` file rendered.

        - a new environment variable `ANISE_SUBSETS` is automatically injected in the
          finalizer in order to customize commands based on the subsets enabled.

* [v0.40-1-geaaru](https://github.com/geaaru/luet/releases/tag/v0.40.0-geaaru):

        - contains a review of the Solver to support better the provides and the conflicts.

# macaronictl get power!

**After upgrading to Phoenix 23.11 we found an unexpected surprise: with the upgrade of the
Chromium engine from version 116 to version 117 the browsers Google Chrome and Brave try
to use by default the 3D acceleration and this breaks the startup in the installation with
poor cards**. I personally had a bad experience in my ASUS Trasform T300 with a poor Intel GPU
 after the upgrade and we want to avoid sharing this experience with other users.

For this reason, we have added a new customization that permits control of the startup
flags of the browsers and by default, we disable 3D acceleration that seems the default
behavior of the previous releases.

This is done by replacing the links under `/usr/bin/` with a bash script that could be
controlled by the `macaronictl browser configure` command.

We have planned to improve these command to have more control but for this tool permits
to configure only Google Chrome (Stable, Unstable, Beta) and Brave.
In particular, the *finalizer* of this package creates automatically the right setup that
could be controller by the *root* users or specifically but every user

```bash
$> macaronictl browser available
|              PACKAGE              | PACKAGE VERSION  | SYSTEM OPTIONS | USER OPTIONS |  ENGINE  |            BINARIES             |
|-----------------------------------|------------------|----------------|--------------|----------|---------------------------------|
| www-client/brave-bin              | v1.59.117+2      | true           | false        | chromium | /usr/bin/brave-bin              |
| www-client/firefox                | v118.0.2         | false          | false        | N/A      | N/A                             |
| www-client/firefox-beta-bin       | v119.0           | false          | false        | N/A      | N/A                             |
| www-client/firefox-bin            | v118.0.2         | false          | false        | N/A      | N/A                             |
| www-client/google-chrome          | v118.0.5993.70+2 | false          | false        | chromium | /usr/bin/google-chrome-stable   |
| www-client/google-chrome-beta     | v119.0.6045.21+2 | false          | false        | chromium | /usr/bin/google-chrome-beta     |
| www-client/google-chrome-unstable | v120.0.6062.2+2  | false          | false        | chromium | /usr/bin/google-chrome-unstable |
| www-client/opera                  | v99.0.4788.9+1   | false          | false        | N/A      | N/A                             |
| www-client/vivaldi                | v6.2.3105.58     | false          | false        | N/A      | N/A                             |
| www-client/vivaldi-snapshot       | v6.4.3152.3      | false          | false        | N/A      | N/A                             |

```

and customized with this command:

```bash
$ macaronictl browser configure --help
Shows browsers available in configured repositories.

# Generate the system yaml file with the default options from catalog.
$> macaronictl browser conf www-client/brave-bin --system --defaults

# Generate the user yaml file with the default options from catalog.
$> macaronictl browser conf www-client/brave-bin --user --defaults

# Generate the user yaml file without options for the selected package.
$> macaronictl browser conf www-client/brave-bin --user --without-opts

# Generate the user yaml file awithout options and the user include file
# for the selected package.
$> macaronictl browser conf www-client/brave-bin --user --without-opts --exec

# Generate the binary script of the package and the system includes scripts.
# Normally, this command is executed on package finalizer.
$> macaronictl browser conf www-client/brave-bin --exec --system  --defaults

# Generate the user include and YAML files with the default options
$> macaronictl browser conf www-client/brave-bin --exec --user  --defaults

# Remove the user include file.
$> macaronictl browser conf www-client/brave-bin --purge --user

# Remove the sytem include file and the binary of the package
$> macaronictl browser conf www-client/brave-bin --purge --system

# Update the user include file. Normally, used when the user YAML file
# is been modified manually.
$> macaronictl browser conf www-client/brave-bin --user --only-update-includes

# Update the system include file. Normally, used when the user YAML file
# is been modified manually.
$> macaronictl browser conf www-client/brave-bin --system --only-update-includes

NOTE: It works only if the repositories are synced.

Usage:
   browser configure [pkg] [flags]

Aliases:
  configure, conf, c

Flags:
      --catalog-file string    Specify the directory of the catalog file of all engines options. (default "/usr/share/macaroni/browsers/catalog")
      --defaults               Set catalog defaults options to specified package.
      --exec                   Update script of the binary. Need root permissions.
  -h, --help                   help for configure
      --home-dir string        Override the directory of the user with engines options. (default "/home/geaaru/.local/share/macaroni/browsers")
      --only-update-includes   Update script includes file.
      --purge                  Remove system option from system. Need root permissions.
      --system                 Set bootstrap option on system. Need root permissions.
      --system-dir string      Override the directory of the system configuration with engines options. (default "/etc/macaroni/browsers")
      --user                   Set bootstrap option for user.
      --without-opts           Disable all options to specified package.

Global Flags:
  -c, --config string   Macaronictl configuration file
  -d, --debug           Enable debug output.


```

In particular, it's possible to restore the default behaviour without customization
from the user with this command:

```
$ macaronictl browser configure   www-client/brave-bin --user --without-opts
Configuring browser start flags:
Package:         www-client/brave-bin
User options:

Generated engine file:	/home/geaaru/.local/share/macaroni/browsers/chromium.yml
Generated include file:	/home/geaaru/.local/share/macaroni/browsers/chromium.brave-bin.inc
All done.
```

The file *chromium.brave-bin.inc* is included by the script under `/usr/bin` for the specified browser selected.

**NOTE: To use the new command is needed add the `desktop` subset in order to
  install the browser catalog on upgrading `macaronictl` package.**

# Openshot is now integrated with Blender!


Thanks to the upgrade of Python to version 3.9 is now possible to use the integration of the
Openshot QT Video editor with Blender for animations!

In particular, the migration to Funtoo Next required the upgrade of his packages with the
last release that will be added to Funtoo soon.

Considering that Macaroni OS uses the `blender-bin` package the users need some tricks to
use the integration with Blender, these the steps that we report hereinafter:

```
$> mkdir $HOME/bin

$> echo "
export PATH=$PATH:$HOME/bin
" >> $HOME/.bashrc

$> cd $HOME/bin
$> ln -s /opt/bin/blender-bin blender
```

It's possible that in the near future, we will move to the `blender` compiled release
and these steps will no longer be needed.


# Security updates

The list of the major security fix:

* CVE-2023-39232 - Go 1.21.3

* CVE-2023-38545 - Curl

* CVE-2023-4911 - Looney tunables - Local Privilege Escalation in glibc

* CVE-2023-4863 - libwebp

* CVE-2022-36019 - Docker

* CVE-2022-39253 - Docker

* CVE-2023-5217 - libvpx

* CVE-2023-25809 - runc

* CVE-2023-27561 - runc

# Upgrade existing Macaroni OS filesytem to Phoenix 23.11

Before beginning the upgrade you need to be sure to have a backup of your data
and sufficient space in the filesystem to download all packages installed because
will be replaced and installed.

This upgrade is a `dist-upgrade` and it needs additional support.

Obviously, it's also possible to just reinstall a fresh installation from
the new ISO 23.11.

The *whip* hook will remove the packages:

1. `sys-firmware/ed2k-ovmf`: we will move to `sys-firmware/ed2k-ovmf-bin` package

2. `net-misc/openntpd`: No more available in our repository and with this conflict:

    ```
    Error file conflict between 'net-misc/openntpd-6.2+2' and 'net-misc/ntp-4.2.8' ( file: etc/conf.d/ntpd )
    ```

3. `sys-firmware/seabios`: we will move to `sys-firmware/seabios-bin` package

**ATTENTION: In order to avoid errors on upgrade if the system to upgrade contains browsers
             you need to add the `desktop` subset before start the upgrade.

```
$> luet subsets enable desktop
```

So, these the steps to follow on upgrade your Macaroni system based on Funtoo 1.4:

#### 1. Get last release of `anise` (luet) Package Manager

To do this you need disable all repositories exclude `geaaru-repo-index` and `mottainai-stable`:

```
$> luet repo disable macaroni-commons macaroni-phoenix macaroni-security
```

Upgrade the repositories:

```
$> luet repo update
```

Upgrade luet to last release:

```
$> luet upgrade -y
```

#### 2. Enable repositories

You can enable the previous disabled repositories (you can maintain disabled the repository
`macaroni-security` because it doesn't contain new packages for now):

```
$> anise repo enable macaroni-commons macaroni-phoenix
```

and then update the local metadata:

```
$> anise repo update
```

#### 3. Get the last version of the `whip-catalog`

In order to start the upgrade process you need to have the last version of the
`macaroni/whip-catalog` package:

```
$> anise rm macaroni/whip-catalog --nodeps

$> anise i macaroni/whip-catalog
```

#### 4. Start the upgrade

You can start the upgrade and to use the environment variable `SKIP_REINDEX=1`
if the `luet` version is greather then v0.39.0 else it's better to run this
without the variable.

```
$> SKIP_REINDEX=1 whip h macaroni.upgrade2funtoo-next
```

#### 5. Run `macaronictl etc-update`

Due to big upgrades done will be a lot of files to check and merge eventually.
This phase requires attention.

```
$> macaronictl etc-update
```

#### 6. Run `macaronictl env-update`

This command updates the */etc/profile.env* and regenerates the file ld.so.cache
like the Funtoo `env-update` command:

```
$> macaronictl env-update
>>> Generating /etc/profile.env...
>>> Generating /etc/ld.so.conf...
>>> Regenerating /etc/ld.so.cache...
```

#### 7. Verify the linking of the installed files

It's available a **whip** hook that permits to verify if there are libraries or
binaries with links to no more available libraries.

It's a good idea to run this command on every upgrade:

```
$> whip h linking.check
Checking directory /usr/lib64...
Checking directory /usr/lib...
Checking directory /usr/bin...
Checking directory /bin...
Checking directory /usr/sbin...
Checking directory /usr/libexec...
[linking.check] Completed correctly.

```

The directories checked by default are these:

* /usr/lib64
* /usr/lib
* /usr/bin
* /bin
* /usr/sbin
* /usr/libexec

But could be changed overriding the environment variable `DIRS`:

```
$> DIRS="/usr/lib64" whip h linking.check
```

#### 12. Remove orphans packages (optional)

When the upgrade is ended, it's possible check what packages installed
are no more available in the Macaroni repositories that could be removed
through the `anise query orphans` command:

```
$> anise q orphans
```

Between the orphans list will be present the old GCC 9.2.0 that could be
removed:

```
$> anise rm sys-devel-9.2.0/gcc
```

#### 13. Regenerate the kernel initrd image

It's important to run this command to build an initrd image updated
and aligned to the merge configurations with `macaronictl etc-update`.

```
macaronictl kernel geninitrd --all --set-links --purge --grub
```

#### 14. Reboot and starting to play with the new Macaroni Phoenix release

The job is done!

```
$> reboot
```

If you have the subsets `devel` and `portage` enable and you want to setup
the new GCC it's better to run:

```
$> gcc-config 1
```

#### 15. Optional steps

If you have Virtualbox installed could be a good idea to execute this command:

```
$> whip h vbox.vbox_setup
```

not yet present in the finalize.

# A new Partner join the project

We are happy to share that the TOP-IX consortium donated a VM to the Macaroni
OS Project and this is great news because will help on work parallel to compile
the new packages from the different releases.

Really thanks for your support TOP-IX!

# What next?

Hereinafter, out hot points in our backlog:

1. After the rewrite of the render engine of the `anise-build` (luet-build)
   tool we want to continue the refactoring of the Macaroni build tool.

2. Complete the migration of the Macaroni Eagle release to Funtoo Next

3. Bump the first release of the `macaroni-games` repository

4. Starting setup of `labs` repository

5. Continue the improvement of our documentation

# We waiting for you

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG).

# Thanks

Many thanks to all Funtoo devs that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru).
