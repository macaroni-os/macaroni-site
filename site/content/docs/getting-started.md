---
title: "Getting Started"
type: docs
---

# Getting Started

## Prerequisites

`Macaroni OS Linux` only supports AMD64 at the moment.

## Get Macaroni OS

To begin playing with `Macaroni` you have a few options but before we get into the different possibilities,
Here is some information about the available releases.


| Release   |  Description  |
| --- | --- |
| Macaroni Funtoo | The core release based on OpenRC/SysVinit Funtoo system. |
| Macaroni Funtoo Systemd | A Funtoo SystemD release.  The idea is to use it only for Server target and as experimental base rootfs where we will develop an alternative tool that will replace SystemD probably written in Golang but that will be compatible with part of SystemD files. |

Respect the Gentoo/Funtoo world, Macaroni tries to reduce the complexity of the others PMS and
it doesn't manage the SLOTs or better the SLOT is added as postfix of the category.
For example the package `sys-devel/gcc:9.2.0` is mapped as `sys-devel-9.2.0/gcc`.

#### Using docker container

```shell
$> docker run --rm -ti macaronios/funtoo-minimal
4e02286e61d3 / # luet repo update
⠈ Downloaded repository.yaml of 0.00 MB ( 0.00 MiB/s )
Downloaded tree.tar.gz of 0.00 MB ( 0.00 MiB/s )
Downloaded repository.meta.yaml.tar.gz of 0.00 MB ( 0.00 MiB/s )
🏠  Repository geaaru-repo-index revision: 1 - 2021-12-12 20:42:48 +0000 UTC
ℹ️  Repository: geaaru-repo-index Priority: 1 Type: http Revision: 1
Downloaded repository.yaml of 0.00 MB ( 0.00 MiB/s )
Downloaded tree.tar.zst of 0.00 MB ( 0.00 MiB/s )
Downloaded repository.meta.yaml.tar.zst of 5.57 MB ( 2.48 MiB/s )
🏠  Repository macaroni-commons revision: 23 - 2022-01-11 16:08:20 +0000 UTC
ℹ️  Repository: macaroni-commons Priority: 2 Type: http Revision: 23
Downloaded repository.yaml of 0.00 MB ( 0.00 MiB/s )
Downloaded tree.tar.zst of 0.53 MB ( 0.44 MiB/s )
Downloaded repository.meta.yaml.tar.zst of 6.04 MB ( 6.78 MiB/s )
🏠  Repository macaroni-funtoo revision: 77 - 2022-01-16 08:09:51 +0000 UTC
ℹ️  Repository: macaroni-funtoo Priority: 2 Type: http Revision: 77
Downloaded repository.yaml of 0.00 MB ( 0.00 MiB/s )
Downloaded tree.tar.zst of 0.00 MB ( 0.01 MiB/s )
Downloaded repository.meta.yaml.tar.zst of 0.27 MB ( 0.67 MiB/s )
🏠  Repository mottainai-stable revision: 1 - 2022-01-14 15:54:04 +0000 UTC
ℹ️  Repository: mottainai-stable Priority: 1 Type: http Revision: 1

4e02286e61d3 / # luet search pci
sys-apps/pciutils-3.6.2+3
x11-libs/libpciaccess-0.16+3

4e02286e61d3 / # luet i sys-apps/pciutils
...
4e02286e61d3 / # luet cleanup
Cleaned:  5 packages.

```

#### Using an LXD container

The Funtoo & Macaroni teams supply their LXD images over a Simplestreams Server.
To configure the LXD `remote` just run this command:

```shell
$> lxc remote add macaroni https://images.macaroni.funtoo.org/lxd-images --protocol simplestreams --public
```

and then check the available images:

```shell
$> lxc image list macaroni:
```

#### Download the Macaroni ISO

Macaroni OS ISOs can be downloaded from [Funtoo CDN](https://cdn.macaroni.funtoo.org/mottainai/macaroni-iso/).

All of the ISOs use [Calamares](https://calamares.io/docs/users-guide/) as Installer.

The password of the `macaroni` user is `macaroni`.

### Knows Issues

The current status of the Macaroni OS is related to its PMS that is under heavy development
and it doesn't yet support the requirements needed for a Desktop environment 
very well and is unstable.

The main issue is that the current upgrade process executes an uninstall of all packages
to upgrade before beginning the installation of the new packages and without checking 
if there are changes. This may sometimes generate issues with X.

So, for the moment, we suggest that you upgrade a Desktop environment from
terminal (just switch with CTRL+ALT+F1).

If used in a Container environment instead, that could be a valid and stable
solution. In a container, the upgrade process is less important because, usually,
the container is dropped and recreated from a new image. In this condition you
could create a very optimized container thanks to the `subsets` feature available
in the fork release of luet.

Macaroni doesn't use the Funtoo ebuild in the installation phase, this means that
the post-install scripts must be managed from the `luet` finalizer. In particular,
the [whip](https://github.com/geaaru/whip) tool has been created to help in this job,
and the [whip-catalog](https://github.com/geaaru/whip-catalog/) to store all the hooks to call.
For any Desktop environment, the post-install hooks could
be configured to run correctly in all packages.

The `whip` tool can be run and the catalog can be displayed with this command:

```shell
$> whip list --table
+-----------+---------------------+-----------------------------------------------------------------------+
|   FILE    |        NAME         |                              DESCRIPTION                              |
+-----------+---------------------+-----------------------------------------------------------------------+
| gtk       | mime_update_db      | Update mime cache.                                                    |
| gtk       | gtk_update_icons    | Update Gnome icons cache.                                             |
| gtk       | glib_update_schemas | Update Glib Schemas.                                                  |
| texlive   | texlive_postinst    | Setup texlive files.                                                  |
|           |                     |                                                                       |
| texlive   | texlive_rebuild_fmt | Rebuild TeX formats.                                                  |
|           |                     |                                                                       |
| dbus      | dbus_gen_machineid  | Setup /etc/machine-id.                                                |
| eudev     | eudev_setup         | Validate Eudev setup.                                                 |
|           |                     |                                                                       |
| fonts     | create_scale        | Create fonts.scale file, used by the old server-side fonts subsystem. |
| fonts     | create_fonts_dir    | Create fonts.dir file, used by the old server-side fonts subsystem.   |
|           |                     |                                                                       |
| fonts     | setup_all_fonts     | Setup fonts.                                                          |
|           |                     |                                                                       |
| openrc    | openrc_setup        | Setup core OpenRC services.                                           |
|           |                     |                                                                       |
| perl      | postinst            | Setup perl binaries links.                                            |
|           |                     |                                                                       |
| polkit    | polkit_setup        | Setup env for polkitd.                                                |
|           |                     |                                                                       |
| eclass_db | db_cleanup          | Clean libdb* links and includes.                                      |
|           |                     |                                                                       |
| eclass_db | db_fix_so           | Fix links of /usr/include/db.h and .so                                |
|           |                     |                                                                       |
| elogind   | elogind_setup       | Check elogind setup.                                                  |
|           |                     |                                                                       |
| gdb       | setup               | Setup gdm files.                                                      |
+-----------+---------------------+-----------------------------------------------------------------------+
```

A hook is callable with the `hook` subcommand:

```shell
$> whip hook gtk.gtk_update_icons gtk.glib_update_schemas
```


### Upgrade

Just:

```shell
$> luet repo update
$> luet upgrade
```

`luet` follow the same Funtoo/Gentoo idea about the configuration files, in particolar,
if the file to install is related to a proctect directory and the file is already present
then `luet` creates the file `_cfg0001_<file>` that could be merged with the classic
`etc-update` or other similar software.

### Search Packages

The current search engine uses regex to find the *category*/*name* string.
The subcommand is callable with `search` or `s`.

```shell
$> luet search lxd-compose
app-emulation/lxd-compose-0.16.3
```

or as a table:

```shell
$> luet s lxd-compose --table
+---------------------------+---------+------------------+---------+
| PACKAGE                   | VERSION | REPOSITORY       | LICENSE |
+---------------------------+---------+------------------+---------+
| app-emulation/lxd-compose | 0.16.3  | mottainai-stable | GPL-3.0 |
+---------------------------+---------+------------------+---------+
```

or as a JSON with metadata:

```shell
$> luet s lxd-compose -o json | jq
{
  "packages": [
    {
      "License": "GPL-3.0",
      "category": "app-emulation",
      "files": [
        "usr/bin/lxd-compose"
      ],
      "hidden": false,
      "name": "lxd-compose",
      "repository": "mottainai-stable",
      "target": "",
      "version": "0.16.3"
    }
  ]
}

```

or search between installed packages:

```shell
$> luet s lxd --installed
```

### Install a package

The subcommand is callable with `install` or `i`.

```shell
$> luet i app-emulation/lxd-compose
```

### Uninstall a package

The subcommand is callable with `uninstall` or `rm`.

```shell
$> luet rm app-emulation/lxd-compose
```

### Show files of a package

```shell
$> luet q files app-emulation/lxd-compose
usr/bin/lxd-compose
```

or as JSON array:

```shell
$> luet q files app-emulation/lxd-compose -o json
["usr/bin/lxd-compose"]
```

or as YAML:

```shell
$> luet q files app-emulation/lxd-compose -o yaml
- usr/bin/lxd-compose

```
