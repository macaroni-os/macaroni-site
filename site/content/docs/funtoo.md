---
title: "Funtoo zone"
type: docs
---

# Main differences between Funtoo and Macaroni OS

## 1. Static UID/GID

The system UID (user ID) and GID (group ID) of the major services are statically
allocated and managed through the `entities` tool and his catalog. This helps
to have a more linear installation between systems and help on share network
filesystems like NFS.

It is possible to see the list of the available uid/gid with the following
commands:

```bash
$> # Show list of all groups availables in our catalog
$> entities list groups --specs-dir /usr/share/macaroni/entities/

$> # Show list of all users available in our catalog
$> entities list users --specs-dir /usr/share/macaroni/entities/

$> # Show list of all shadow available in our catalog
$> entities list shadow --specs-dir /usr/share/macaroni/entities/

$> # Show list of all gshadow available in our catalog
$> entities list gshadow --specs-dir /usr/share/macaroni/entities/

$> # Show list of all groups configured in the current rootfs
$>  entities list groups

$> # Show list of all users configured in the current rootfs
$>  entities list users
```

The `entities` tool is a replacement of the classic `adduser`, `gpasswd`, etc.

## 2. Use flags not aligned to Funtoo Profiles

Macaroni OS is a binaries-based distribution that wants to try to supply
multiple DEs. To reach this target means that a lot of user flags must be
enabled but without trying to inject unnecessary dependencies when possible.
So, for this reason, the control of the use flags selected for every package
is done by the `anise-portage-converter` tool that permits to override
existing dependencies and/or elaborate dependencies based on the use flags
defined in the `anise-portage-converter` specs. This permits great control
of the compilation process but unfortunately, doesn't permit it to maintain
compatibility with the Funtoo profiles that are used to configure the use
flags based on the needs of the users and their choice. This means that
installing Macaroni's packages and just using `emerge` could be not managed
with a simple configuration of the Funtoo profiles and instead it's highly
probable that just trying to emerge the `@world` will ask for changes of the
use flags used instead by Macaroni.

## 3. Split packages

So, in order to support multiple use cases but with fewer dependencies
injected we have some packages that have been split without having a 1:1 map
with an ebuild. For example, the *pinentry* package installs additional binary
when `gtk`/`gnome` use flag is enabled with the `pinetry-gnome` binary or with
the `qt` use flag the `pinentry-qt`, etc.
Thanks to our build process it's very easy to assign the specific file to
a specific package, but this package will be without portage metadata and
instead, the use flags of the main *pinentry* package will be minimal.


## 4. Packages from scratch

In addition, there are packages that are not related to a specific ebuild
because the Macaroni build process permits building packages from scratch
or through different Docker images as a base. These will be available in
your system but not visible through the emerge tool, for example, the
`anise` binary is compiled directly with Go without an ebuild.

## 5. Portage metadata optional

The installation of the Portage metadata and the include files are optional,
they are installed only when the *subsets* `devel` and `portage` are enabled.
This permits users without the need to compile software to reduce space used
in their filesystem.

The Portage package database under the directory `/var/db/pkg` is then used by
the `anise-portage-converter` tool to compare packages updates with emerge that
will be added in the Macaroni database with the `scm` repository and will be
part of the Macaroni upgrades if the installed version will be elder or will be
the same version available in Macaroni repository. In particular, in order to
automatically install missing runtime dependencies the `anise` tool creates a
hash will the *requires* of the analyzed package and if this hash is different
from the hash of the installed package will be queued for the upgrade with the
asterisk in the version (for example, \*1.1.1). It's possible that the injected
package added from `anise-portage-converter` will have different *requires* of
the Macaroni original specs; this is the reason because will be replaced.
This could be avoided by masking the package.


## 6. etc-update and env-update implementation

The Funtoo/Gentoo `etc-update` and `env-update` scripts are supplied by the
`sys-apps/portage` package that requires Python to be installed with a lot
of dependencies.

In order to reduce the installation of the packages for a Macaroni's  minimal
image where Python is not something needed, for example considering CD/CI tasks,
Macaroni implements the `macaronictl etc-update` that supplies an `etc-update`
compliant command and as a replacer. It has a few differences that are more
related to the interactive shell but for the rest, it's pretty similar.

The same concept is applicable to the `macaronictl env-update` command that
reimplements a Portage-compliant logic. The behavior is configurable, instead
of updating every time the system and the (t)csh environment files, for these
two the configuration is enabled respectively with the options `--systemd` and `--csh`.

## 7. Post-install/Post-remove commands

In the Funtoo/Gentoo world where every package is compiled the ebuild file contains
the instructions about how to compile the package supply yet the steps for the
post-installation and post-remove. Macaroni divides completely the build process
from the runtime/install phase and as described in the previous chapters the Portage
metadata could not be present, like the kits. In Macaroni, the post-install and
post-remove operations are managed by the `finalizer` that could be added in the
`anise` specs over the YAML file `finalize.yaml` of the package. Due to the complexity
of this phase, and because sometimes could be helpful to re-run the post-install
steps we have created the tool **whip** that collects the instructions about what runs
as a specific hook. The hook is a scripted list of commands to run.

The same hooks are used as post-install/pre-install steps or just like ready-to-use
commands for particular example described in the next chapters about upgrading
Funtoo 1.4 to Funtoo Next/Macaroni.

At the moment, it's possible that some hooks could be missing and please, you open a
PR or an issue if you find something.

## 8. Macaroni solver logic

The Funtoo/Gentoo's Portage solver always considers RDEPEND (runtime dependencies) as
mandatory dependencies for the compilation of a package. We understand this choice,
for example, this is needed for *virtual* package, the consequence is the ebuilds have
some dependencies added as RDEPEND when could be more correct to have them as DEPEND
for Macaroni. So, for these use cases, we override the dependencies through the
`anise-portage-converter` specs.

Another big difference is that at the moment the `anise` solver doesn't support the
OR condition needed to supply alternative packages supply the same feature.
This is been a design choice to try to maintain things more simple for the solver,
a similar functionality could be handled by the *provides* and the mask feature.
But it's something that could be grown based on the use cases we need to support.

Third, the default behavior of the solver in the upgrading process is to select only
packages with a greater version for speedup reasons. The downgrade is possible on
adding `--deep` flag on `upgrade` command.

## 9. Kernel, initrd and extra modules

At the moment we writing this documentation the kernels available to the Macaroni OS
are based on vanilla, compiled over the Macaroni Terragon Release system but without
generating Portage metadata. In order to handle automatically the upgrade of the branch
release selected we don't follow the Funtoo way where the slot of the kernel is based
on the full version of the kernel. We understand the choice of Funtoo where the user
has sufficient skill to manage the compilation of the kernel and a more precise tune,
but it's a bit more complex for a binary distribution to manage the automatic upgrade.
So, all kernels and modules use as a package category with the name `kernel-<branch-version>`
and the new versions of the category will replace the previous. So, the package
*kernel-5.10/macaroni-full-5.10.198* will be upgraded by the package
*kernel-5.10/macaroni-full-5.10.199*, etc.

In a similar way, the extra kernel modules will be managed with the same logic the category
but with the version of the module used, for example, for ZFS, the package will be
*kernel-5.10/zfs-kmod-2.2.0* and for new kernel release we will bump a new build version of
the same package, for example, *kernel-5.10/zfs-kmod-2.2.0+1*.

About *initrd*, at the moment we use a custom initrd based of Golang `u-root` for the
Macaroni ISO, and instead it's used Dracut for the generation of the initrd images in the
installed rootfs (Desktop and Server).





# Upgrade Funtoo 1.4 to Funtoo Next with Macaroni

Before beginning to describe how to upgrade a Funtoo 1.4 rootfs to a Funtoo Next rootfs
I want to share that at the moment the Funtoo Community doesn't support officially
the upgrade of a Funtoo 1.4 environment to a Funtoo Next environment.

This means that this guide is **not officially supported by Funtoo Community** but it's
an experimental behavior about how `Macaroni OS` could be used to help `Funtoo`
users in some particular operations.

**Macaroni's team does not suggest using this experimental process without specific
tests and with a backup to recover the state of the previous system before the upgrade.**

The second point to share before going ahead is that there are a few differences between
Funtoo and Macaroni that will be available after this upgrade based on what is been
described in the previous chapters. Any user who wants to add some more details about
restoring a Funtoo complete state after this operation could add more information here
by sending a PR.

Due the complexity of this workflow we have prepared a *whip* [hook](https://github.com/macaroni-os/whip-catalog/blob/master/catalog/commons/macaroni.yaml#L96)
that could be used to speedup some upgrade process.

It's also available in an [asciinema](https://asciinema.org/a/619230) stream that shows
the steps to upgrade an LXD container with Funtoo 1.4 to a Macaroni Funtoo Next rootfs
that we share hereinafter, too.

For this presentation we use an LXD container but the steps for a Desktop environment
are pretty equal.

#### 1. Create the LXD Funtoo 1.4 Container

The official `images.linuxcontainers.org` contains the Funtoo LXD images so we can
launch the container with this command:

```
$> lxc launch -p default images:funtoo/1.4 test

```

NOTE: Funtoo 1.4 is no longer available on Incus Simplestreams Server.
      You can consider `images:funtoo/1.4` an alias that describe the image
      with Funtoo 1.4.

We consider that the `default` profiles is configured correctly with a valid
storage pool and a network interface where is enabled DHCP.

#### 2. Install Macaroni PMS binary

At the moment, the Macaroni PMS repository is [luet](https://github.com/geaaru/luet/)
but the installer creates already the symbolic link with the new name `anise`. The repository
will be soon migrated with the new name.

```
$> curl https://raw.githubusercontent.com/geaaru/luet/geaaru/contrib/config/get_luet_root.sh | sh
```

#### 3. Install Macaroni repositories

In order to start the upgrade we need to install the Macaroni repositories. In this
example, we use the Phoenix release but could be used the Terragon release too.

```
$> anise i -y  repository/macaroni-commons-testing repository/macaroni-phoenix-testing
```

#### 4. Download the repositories metadata

Before to download the repositories data, we want to share how it's possible to mask
a package available from different packages and to configure the solver to get only
the package the user wants. For example, the package `jq` is available inside the
`mottainai-stable` repository without Portage metadata, but it's also available as
package `app-admin/jq` with the Portage metadata and based on Funtoo ebuild.
In this case, to force the second it's possible mask the other in this way:

```
$> mkdir /etc/luet/mask.d
$> echo "
enabled: true
rules:
  - utils/jq::mottainai-stable
" > /etc/luet/mask.d/00-mask.yml
```

Another important thing to do before execute the upgrade is to enable the *subsets*
`devel` and `portage` that are by default disabled.

```
$> anise subsets enable devel portage
```

and finally to start the `repo update`:

```
$> anise repo update
```

#### 5. Install `anise-portage-converter` tool

In order to upgrade the system we need to install the `anise-portage-converter` tool
that will sync the list of the installed packages in the system of the Portage inside
the `anise` database.

```
$> anise install -y anise-portage-converter app-misc/jq
```

#### 6. Sync Portage to Anise database

```
$> anise-portage-converter sync
```

eventually it's possible to run the command with `--dry-run` to test the execution
without update the `anise` database.

#### 7. Install Macaroni tools

We need to install the **whip** tool and the other stuff used in the Macaroni finalizer.

```
$> anise i -y whip whip-catalog entities whip-profiles/macaroni macaronictl-thin entities macaroni/entities-catalog
```

These packages could be removed at the end of the upgrade if you will use the rootfs
only as Funtoo rootfs.

#### 8. Start the upgrade

Finally, we can start the upgrade and use the environment variable `SKIP_GRUB=1` to skip
the generation of the macaroni initrd and/or Grub setup.

It's also available the variable `SKIP_CLEANUP` to avoid the clean of the anise cache with all
downloaded packages. If for example, you want to run the same workflow in another node and copy
the packages manually.

```
$> SKIP_GRUB=1 whip h macaroni.upgrade2funtoo-next

```

or for Desktop/Server filesystem:

```
$> whip h macaroni.upgrade2funtoo-next
```

#### 9. Run `macaronictl etc-update`

In the same way, you run `etc-update` in Funtoo you can run `macaronictl etc-update` and check
what files merge and/or drop. But it's also true that if you have installed the *sys-apps/portage*
package you can use also the `etc-update` from Portage. The both can work together.

At the moment, there are known issues in `anise` that could generate extra diff: `anise` doesn't
support a CONFIG_PROTECT_MASK similar option. So, if it's been configured the directory */etc* as
a protected directory, every file will be protected also on removing a package. But what has not
been managed automatically from `anise` could be overridden with `macaronictl etc-update` with the
option `-m|--mask-path` that permits to define of one or more additional mask paths.


```bash
$> macaronictl etc-update --help
handle configuration file updates and automatically
merge the CONFIG_PROTECT_MASK files.

$> macaronictl etc-update

Usage:
   etc-update [flags]

Aliases:
  etc-update, etc

Flags:
  -h, --help                    help for etc-update
  -m, --mask-path stringArray   Define one or more additional mask paths (CONFIG_PROTECT_MASK).
  -p, --path stringArray        Scan one or more specific paths (CONFIG_PROTECT).
      --rootfs string           Override the default path where run etc-update. (experimental) (default "/")

Global Flags:
  -c, --config string   Macaronictl configuration file
  -d, --debug           Enable debug output.
```

So, running the command will be show an interactive shell to understand what
files merge or drop:

```
$> macaronictl etc-update
Scanning Configuration files... 
File ._cfg0001_sshd_config is an orphan. Removing it directly...
File ._cfg0002_sshd_config is an orphan. Removing it directly...
Automerging file /etc/ca-certificates.conf config protect masked.
Automerging file /etc/os-release config protect masked.
The following is the list of files which need updating, each
configuration file is followed by a list of possible replacement files.

[  1] /etc/env.d/50baselayout
[  2] /etc/init.d/devfs
[  3] /etc/init.d/dhcpcd
[  4] /etc/init.d/s6-svscan
[  5] /etc/netif.d/dhclient
[  6] /etc/ego.conf
[  7] /etc/init.d/numlock
[  8] /etc/terminfo/s/screen
[  9] /etc/rc.conf
[ 10] /etc/init.d/agetty
[ 11] /etc/ssh/moduli
[ 12] /etc/terminfo/s/screen-256color
[ 13] /etc/dhcpcd.conf
[ 14] /etc/init.d/cgroups
[ 15] /etc/init.d/hwclock
[ 16] /etc/init.d/localmount
[ 17] /etc/init.d/modules
[ 18] /etc/init.d/osclock
[ 19] /etc/portage/savedconfig/sys-apps/busybox-1.36.0
[ 20] /etc/python-exec/python-exec.conf
[ 21] /etc/init.d/bootmisc
[ 22] /etc/terminfo/x/xterm-color
[ 23] /etc/terminfo/s/screen.xterm-256color
[ 24] /etc/issue
[ 25] /etc/terminfo/x/xterm
[ 26] /etc/terminfo/x/xterm-256color

[ -1] to exit
[ -3] to auto merge all files
[ -7] to discard all updates


Please select a file to edit by entering the corresponding number.
	(don't use -3 or -7 if you're ensure what to do):
```

One of the differences between `macaronictl etc-update` and `etc-update` is that the
 file number is reset when a specific file is been managed, this permits to use of
the number 1 always until the files are been all processed.

For example, the files under `/etc/terminfo/` normally must be merged and
will be soon managed as CONFIG_PROTECT_MASK when the feature will present
in the `anise` software.

#### 10. Run `macaronictl env-update`

This command updates the */etc/profile.env* and regenerates the file ld.so.cache
like the Funtoo `env-update` command:

```
$> macaronictl env-update
>>> Generating /etc/profile.env...
>>> Generating /etc/ld.so.conf...
>>> Regenerating /etc/ld.so.cache...
```

#### 11. Verify the linking of the installed files

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

#### 12. Remove orphans packages

When the upgrade is ended, it's possible check what packages installed
are no more available in the Macaroni repositories that could be removed
through the `anise query orphans` command:

```
# anise q orphans
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🧠 Searching for orphans packages...
dev-python/chardet-compat-4.0.0
dev-python/enum34-1.1.10
dev-python/setuptools_scm-compat-5.0.2
dev-python/cryptography-compat-3.3.2
dev-python/mwparserfromhell-compat-0.5.4
dev-python/setuptools-compat-44.1.1
dev-lang-2.7/python-2.7.18
sys-apps/opentmpfiles-0.3.1
sys-devel/binutils-config-5.4
dev-python/pyopenssl-compat-21.0.0
dev-python/zipp-compat-1.2.0
dev-python/requests-compat-2.27.1
dev-python/importlib_metadata-compat-2.1.1
dev-python/packaging-compat-20.9
sys-kernel-debian-sources-6.3.7_p1/debian-sources-6.3.7
dev-python/configparser-4.0.2
dev-python/pygments-compat-2.5.2
dev-python/wheel-compat-0.37.1
dev-lang-3.7/python-3.7.17
sys-devel-9.2.0/gcc-9.2.0
dev-python/idna-compat-2.9
```

The *debian-sources* package will be always see as orphans for the reasons
described before. Any user could choice what packages remove or leave.

For the example we want to leave only packages available in Macaroni to the steps
will be:

```
$> # Removing all python 2.7 packages...
$> anise rm -y $(anise s compat --installed)
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🔪 [  1 of  13] [D] dev-python/chardet-compat::scm                                - 4.0.0
🔪 [  2 of  13] [D] dev-python/cryptography-compat::scm                           - 3.3.2
🔪 [  3 of  13] [D] dev-python/idna-compat::scm                                   - 2.9
🔪 [  4 of  13] [D] dev-python/importlib_metadata-compat::scm                     - 2.1.1
🔪 [  5 of  13] [D] dev-python/mwparserfromhell-compat::scm                       - 0.5.4
🔪 [  6 of  13] [D] dev-python/packaging-compat::scm                              - 20.9
🔪 [  7 of  13] [D] dev-python/pygments-compat::scm                               - 2.5.2
🔪 [  8 of  13] [D] dev-python/pyopenssl-compat::scm                              - 21.0.0
🔪 [  9 of  13] [D] dev-python/requests-compat::scm                               - 2.27.1
🔪 [ 10 of  13] [D] dev-python/setuptools-compat::scm                             - 44.1.1
🔪 [ 11 of  13] [D] dev-python/setuptools_scm-compat::scm                         - 5.0.2
🔪 [ 12 of  13] [D] dev-python/wheel-compat::scm                                  - 0.37.1
🔪 [ 13 of  13] [D] dev-python/zipp-compat::scm                                   - 1.2.0
♻️ [  1 of  13] dev-python/chardet-compat::scm                                    - 4.0.0           # uninstalled ✔ 
♻️ [  2 of  13] dev-python/cryptography-compat::scm                               - 3.3.2           # uninstalled ✔ 
♻️ [  3 of  13] dev-python/idna-compat::scm                                       - 2.9             # uninstalled ✔ 
♻️ [  4 of  13] dev-python/importlib_metadata-compat::scm                         - 2.1.1           # uninstalled ✔ 
♻️ [  5 of  13] dev-python/mwparserfromhell-compat::scm                           - 0.5.4           # uninstalled ✔ 
♻️ [  6 of  13] dev-python/packaging-compat::scm                                  - 20.9            # uninstalled ✔ 
♻️ [  7 of  13] dev-python/pygments-compat::scm                                   - 2.5.2           # uninstalled ✔ 
♻️ [  8 of  13] dev-python/pyopenssl-compat::scm                                  - 21.0.0          # uninstalled ✔ 
♻️ [  9 of  13] dev-python/requests-compat::scm                                   - 2.27.1          # uninstalled ✔ 
♻️ [ 10 of  13] dev-python/setuptools-compat::scm                                 - 44.1.1          # uninstalled ✔ 
♻️ [ 11 of  13] dev-python/setuptools_scm-compat::scm                             - 5.0.2           # uninstalled ✔ 
♻️ [ 12 of  13] dev-python/wheel-compat::scm                                      - 0.37.1          # uninstalled ✔ 
♻️ [ 13 of  13] dev-python/zipp-compat::scm                                       - 1.2.0           # uninstalled ✔ 
```

and later removing the old GCC and Python versions, etc.:

```
$> anise rm -y dev-python/configparser dev-python/enum34 \
   sys-kernel-debian-sources-6.3.7_p1/debian-sources dev-lang-3.7/python \
   sys-devel-9.2.0/gcc dev-lang-2.7/python sys-devel/binutils-config
```

#### 13. Reboot and starting to play with Funtoo 🎊

The job is done! The container is been upgraded.

```
$> reboot
```

and later begin with the Funtoo fun:

```
$> ego sync
```


# Integrate Funtoo Next rootfs with Macaroni

Hereinafter will be shared the steps needed to integrate Macaroni into an existing
Funtoo Next filesystem and get the power from both worlds.

**The Funtoo Community doesn't support officially issues from filesystems that don't
follow the [Wolf Pack Philosophy](https://www.funtoo.org/Wolf_Pack_Philosophy), so before opening issues about errors on emerging
packages from Funtoo Kits you need to be sure that the issue is easily reproducible
from the Funtoo Developers Team**. Unlucky, due to the different processes of the
Macaroni build tools and the dynamic build process managed by the `anise-portage-converter`
tool isn't so easy to follow a logic based on Funtoo profiles as described in
the previous chapters.

Like described for the Funtoo 1.4 upgrade we use an LXD container to describe the
steps to integrate Macaroni OS to a Funtoo Next filesytem.

#### 1. Create the LXD Funtoo Next Container

The official `images.linuxcontainers.org` contains the Funtoo LXD images so we could
launch the container with this command:

```
$> lxc launch -p default macaroni:funtoo/next-stage3 test
$> # or using Incus
$> incus launch -p default macaroni:funtoo/next-stage3 test

```
We consider that the `default` profiles is configured correctly with a valid
storage pool and a network interface where is enabled DHCP.


#### 2. Install Macaroni PMS binary

At the moment, the Macaroni PMS repository is [luet](https://github.com/geaaru/luet/)
but the installer creates already the symbolic link with the new name `anise`. The repository
will be soon migrated with the new name.

```
$> curl https://raw.githubusercontent.com/geaaru/luet/geaaru/contrib/config/get_luet_root.sh | sh
```

#### 3. Install Macaroni repositories

In order to start the upgrade we need to install the Macaroni repositories. In this
example, we use the Phoenix release but could be used the Terragon release too.

```
$> anise i -y  repository/macaroni-commons-testing repository/macaroni-phoenix-testing
```

#### 4. Download the repositories metadata

Before to download the repositories data, we want to share how it's possible to mask
a package available from different packages and to configure the solver to get only
the package the user wants. For example, the package `jq` is available inside the
`mottainai-stable` repository without Portage metadata, but it's also available as
package `app-admin/jq` with the Portage metadata and based on Funtoo ebuild.
In this case, to force the second it's possible mask the other in this way:

```
$> mkdir /etc/luet/mask.d
$> echo "
enabled: true
rules:
  - utils/jq::mottainai-stable
" > /etc/luet/mask.d/00-mask.yml
```

Another important thing to do before execute the upgrade is to enable the *subsets*
`devel` and `portage` that are by default disabled.

```
$> anise subsets enable devel portage
```

and finally to start the `repo update`:

```
$> anise repo update
```

#### 5. Install `anise-portage-converter` tool

In order to upgrade the system we need to install the `anise-portage-converter` tool
that will sync the list of the installed packages in the system of the Portage inside
the `anise` database.

```
$> anise install -y anise-portage-converter app-misc/jq
```

#### 6. Sync Portage to Anise database

```
$> anise-portage-converter sync
```

eventually it's possible to run the command with `--dry-run` to test the execution
without update the `anise` database.

#### 7. Install Macaroni tools

We need to install the **whip** tool and the other stuff used in the Macaroni finalizer.

```
$> anise i -y whip whip-catalog entities whip-profiles/macaroni macaronictl-thin entities macaroni/entities-catalog
```

These packages could be removed at the end of the upgrade if you will use the rootfs
only as Funtoo rootfs.

#### 8. Start the upgrade

Finally, we can start the upgrade and use the environment variable `SKIP_GRUB=1` to skip
the generation of the macaroni initrd and/or Grub setup.

It's also available the variable `SKIP_CLEANUP` to avoid the clean of the anise cache with all
downloaded packages. If for example, you want to run the same workflow in another node and copy
the packages manually.

```
$> SKIP_GRUB=1 whip h macaroni.funtoo2macaroni

```

or for Desktop/Server filesystem:

```
$> whip h macaroni.funtoo2macaroni
```

#### 9. Run `macaronictl etc-update`

In the same way, you run `etc-update` in Funtoo you can run `macaronictl etc-update` and check
what files merge and/or drop. But it's also true that if you have installed the *sys-apps/portage*
package you can use also the `etc-update` from Portage. The both can work together.

At the moment, there are known issues in `anise` that could generate extra diff: `anise` doesn't
support a CONFIG_PROTECT_MASK similar option. So, if it's been configured the directory */etc* as
a protected directory, every file will be protected also on removing a package. But what has not
been managed automatically from `anise` could be overridden with `macaronictl etc-update` with the
option `-m|--mask-path` that permits to define of one or more additional mask paths.


```bash
$> macaronictl etc-update --help
handle configuration file updates and automatically
merge the CONFIG_PROTECT_MASK files.

$> macaronictl etc-update

Usage:
   etc-update [flags]

Aliases:
  etc-update, etc

Flags:
  -h, --help                    help for etc-update
  -m, --mask-path stringArray   Define one or more additional mask paths (CONFIG_PROTECT_MASK).
  -p, --path stringArray        Scan one or more specific paths (CONFIG_PROTECT).
      --rootfs string           Override the default path where run etc-update. (experimental) (default "/")

Global Flags:
  -c, --config string   Macaronictl configuration file
  -d, --debug           Enable debug output.
```

So, running the command will be show an interactive shell to understand what
files merge or drop:

```
$> macaronictl etc-update
Scanning Configuration files...
Automerging file /etc/os-release config protect masked.
Automerging file /etc/ca-certificates.conf config protect masked.
The following is the list of files which need updating, each
configuration file is followed by a list of possible replacement files.

[  1] /etc/env.d/50baselayout
[  2] /etc/netif.d/dhclient
[  3] /etc/portage/savedconfig/sys-apps/busybox-1.36.0
[  4] /etc/issue

[ -1] to exit
[ -3] to auto merge all files
[ -7] to discard all updates


Please select a file to edit by entering the corresponding number.
	(don't use -3 or -7 if you're ensure what to do): -3
File /etc/env.d/50baselayout replaced by new file.
File /etc/env.d/50baselayout replaced by new file.
File /etc/netif.d/dhclient replaced by new file.
File /etc/netif.d/dhclient replaced by new file.
File /etc/portage/savedconfig/sys-apps/busybox-1.36.0 replaced by new file.
File /etc/portage/savedconfig/sys-apps/busybox-1.36.0 replaced by new file.
File /etc/issue replaced by new file.
File /etc/issue replaced by new file.
Nothing left to do; exiting. :)

```

One of the differences between `macaronictl etc-update` and `etc-update` is that the
 file number is reset when a specific file is been managed, this permits to use of
the number 1 always until the files are been all processed.

For example, the files under `/etc/terminfo/` normally must be merged and
will be soon managed as CONFIG_PROTECT_MASK when the feature will present
in the `anise` software.

#### 10. Run `macaronictl env-update`

This command updates the */etc/profile.env* and regenerates the file ld.so.cache
like the Funtoo `env-update` command:

```
$> macaronictl env-update
>>> Generating /etc/profile.env...
>>> Generating /etc/ld.so.conf...
>>> Regenerating /etc/ld.so.cache...
```

#### 11. Verify the linking of the installed files

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

#### 12. Remove orphans packages

When the upgrade is ended, it's possible check what packages installed
are no more available in the Macaroni repositories that could be removed
through the `anise query orphans` command:

```
$> anise q orphans
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:31:44 UTC - go1.20.3
🧠 Searching for orphans packages...
sys-devel-12.3.0/gcc-12.3.0
sys-kernel-debian-sources-6.4.13_p1-r1/debian-sources-6.4.13
dev-util/b2-4.10.1
```

In this moment, Macaroni OS uses GCC 11 but we will add GCC 12 on Terragon release in
the near future.

The *debian-sources* package will be always see as orphans for the reasons
described before. Any user could choice what packages remove or leave.

```
$> anise rm -y sys-devel-12.3.0/gcc sys-kernel-debian-sources-6.4.13_p1-r1/debian-sources
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:31:44 UTC - go1.20.3
🔪 [  1 of   2] [D] sys-devel-12.3.0/gcc::scm                                     - 12.3.0
🔪 [  2 of   2] [D] sys-kernel-debian-sources-6.4.13_p1-r1/debian-sources::scm    - 6.4.13
♻️ [  1 of   2] sys-devel-12.3.0/gcc::scm                                         - 12.3.0          # uninstalled ✔ 
♻️ [  2 of   2] sys-kernel-debian-sources-6.4.13_p1-r1/debian-sources::scm        - 6.4.13          # uninstalled ✔
```

#### 13. Reboot and starting to play with Funtoo 🎊

The job is done! The container is been integrated with Macaroni PMS.

```
$> reboot

```

You can install the Macaroni OS metadata with the specific version with:

```
$> anise i -y meta-repo 
```

or to use Funtoo way:

```
$> ego sync
```

Note: after upgrade the system it's better setup GCC with:

```
$> gcc-config 1
* Switching native-compiler to x86_64-pc-linux-gnu-11.3.0 ...           [ ok ]
```

# Using Funtoo Kits in Macaroni

We want describe how it's possible to use the Funtoo Portage and `emerge`
in Macaroni and merge packages to `anise` database.

Inside the Macaroni repository we supply a freezed tree of all Funtoo kits
that is been used to build the packages availables. If you want just add
packages that at the moment aren't present in the Macaroni tree could be
a good idea using the same tree else you can follow the Funtoo pattern and
to run `ego sync`.

#### 1. Verify `anise` subsets configuration

Before starting on this it's mandatory that your system is been installed
with the `devel` and `portage` subsets.

This the command that permits to verify this condition:

```
$> anise subsets list
🍨 Subsets enabled:
 * portage
   Portage metadata and files.

 * devel
   Includes and devel files. Needed for compilation.

 * desktop

```

If these subsets aren't present means that you choice to install the
release not *devel*. But this is not an issue you can change the subsets
on the road and we have prepared a **whip** hook that helps on this.

So, to enable these subsets you need to execute this command:

```
$> ansie subsets enable devel portage
Subsets devel portage enabled ✔ .
```

So, ONLY if the subsets wasn't enabled you need to execute this command:

```
$> whip h macaroni.apply-subsets
```

#### 2. Install the packages needed to use Portage and Funtoo stuff

It's possible that some packages defined in this list will be already
present if you have installed the *devel* ISOs but eventually, you will
see the *warning* message that the package is already installed.

```bash
$> anise install elt-patches patch autoconf-archive gcc-config diffutils binutils \
    binutils-libs which make portage metatools ego
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🚧  warning sys-apps/diffutils already installed.
🚧  warning sys-devel-2.40/binutils already installed.
🚧  warning sys-libs/binutils-libs already installed.
🚧  warning sys-apps/which already installed.
🚧  warning sys-apps/portage already installed.
🧠 Solving install tree...
🍦 [  1 of  42] [N] app-admin/ego::macaroni-phoenix-testing                       - 2.8.7+1
🍦 [  2 of  42] [N] app-arch/unzip::macaroni-phoenix-testing                      - 6.0+1
🍦 [  3 of  42] [N] app-portage/elt-patches::macaroni-phoenix-testing             - 20170826.1+1
🍦 [  4 of  42] [N] dev-libs/libyaml::macaroni-phoenix-testing                    - 0.2.5
🍦 [  5 of  42] [N] dev-python/aiofiles::macaroni-phoenix-testing                 - 23.2.1
🍦 [  6 of  42] [N] dev-python/anyio::macaroni-phoenix-testing                    - 4.0.0
🍦 [  7 of  42] [N] dev-python/async-generator::macaroni-phoenix-testing          - 1.10
🍦 [  8 of  42] [N] dev-python/beautifulsoup::macaroni-phoenix-testing            - 4.12.2
🍦 [  9 of  42] [N] dev-python/certifi::macaroni-phoenix-testing                  - 10001
🍦 [ 10 of  42] [N] dev-python/colorama::macaroni-phoenix-testing                 - 0.4.6
🍦 [ 11 of  42] [N] dev-python/curio::macaroni-phoenix-testing                    - 1.6
🍦 [ 12 of  42] [N] dev-python/cython::macaroni-phoenix-testing                   - 0.29.36
🍦 [ 13 of  42] [N] dev-python/dict-toolbox::macaroni-phoenix-testing             - 5.0.0
🍦 [ 14 of  42] [N] dev-python/exceptiongroup::macaroni-phoenix-testing           - 1.1.2
🍦 [ 15 of  42] [N] dev-python/h11::macaroni-phoenix-testing                      - 0.14.0
🍦 [ 16 of  42] [N] dev-python/h2::macaroni-phoenix-testing                       - 4.1.0
🍦 [ 17 of  42] [N] dev-python/hpack::macaroni-phoenix-testing                    - 4.0.0
🍦 [ 18 of  42] [N] dev-python/httpcore::macaroni-phoenix-testing                 - 1.0.0
🍦 [ 19 of  42] [N] dev-python/httpx::macaroni-phoenix-testing                    - 0.25.0
🍦 [ 20 of  42] [N] dev-python/hyperframe::macaroni-phoenix-testing               - 6.0.1
🍦 [ 21 of  42] [N] dev-python/idna::macaroni-phoenix-testing                     - 3.4
🍦 [ 22 of  42] [N] dev-python/msgpack::macaroni-phoenix-testing                  - 1.0.7+1
🍦 [ 23 of  42] [N] dev-python/outcome::macaroni-phoenix-testing                  - 1.2.0
🍦 [ 24 of  42] [N] dev-python/psutil::macaroni-phoenix-testing                   - 5.9.6
🍦 [ 25 of  42] [N] dev-python/py::macaroni-phoenix-testing                       - 1.11.0
🍦 [ 26 of  42] [N] dev-python/pykerberos::macaroni-phoenix-testing               - 1.2.1
🍦 [ 27 of  42] [N] dev-python/pymongo::macaroni-phoenix-testing                  - 4.5.0
🍦 [ 28 of  42] [N] dev-python/pyyaml::macaroni-phoenix-testing                   - 6.0.1
🍦 [ 29 of  42] [N] dev-python/pyzmq::macaroni-phoenix-testing                    - 25.1.1
🍦 [ 30 of  42] [N] dev-python/rich::macaroni-phoenix-testing                     - 13.6.0
🍦 [ 31 of  42] [N] dev-python/sniffio::macaroni-phoenix-testing                  - 1.3.0
🍦 [ 32 of  42] [N] dev-python/sortedcontainers::macaroni-phoenix-testing         - 2.4.0
🍦 [ 33 of  42] [N] dev-python/soupsieve::macaroni-phoenix-testing                - 2.3.1
🍦 [ 34 of  42] [N] dev-python/trio::macaroni-phoenix-testing                     - 0.22.2
🍦 [ 35 of  42] [N] dev-python/xmltodict::macaroni-phoenix-testing                - 0.13.0
🍦 [ 36 of  42] [N] dev-util/meson::macaroni-phoenix-testing                      - 1.2.2
🍦 [ 37 of  42] [N] net-libs/zeromq::macaroni-phoenix-testing                     - 4.3.5
🍦 [ 38 of  42] [N] sys-apps/metatools::macaroni-phoenix-testing                  - 1.3.4
🍦 [ 39 of  42] [N] sys-devel/autoconf-archive::macaroni-phoenix-testing          - 2021.02.19
🍦 [ 40 of  42] [N] sys-devel/gcc-config::macaroni-phoenix-testing                - 2.4+1
🍦 [ 41 of  42] [N] sys-devel/make::macaroni-phoenix-testing                      - 4.2.1+1
🍦 [ 42 of  42] [N] sys-devel/patch::macaroni-phoenix-testing                     - 2.7.6+1
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 455608 µs).
Do you want to continue with this operation? [y/N]:
# anise install elt-patches patch autoconf-archive gcc-config diffutils binutils \
    binutils-libs which make portage metatools ego
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🚧  warning sys-apps/diffutils already installed.
🚧  warning sys-devel-2.40/binutils already installed.
🚧  warning sys-libs/binutils-libs already installed.
🚧  warning sys-apps/which already installed.
🚧  warning sys-apps/portage already installed.
🧠 Solving install tree...
🍦 [  1 of  42] [N] app-admin/ego::macaroni-phoenix-testing                       - 2.8.7+1
🍦 [  2 of  42] [N] app-arch/unzip::macaroni-phoenix-testing                      - 6.0+1
🍦 [  3 of  42] [N] app-portage/elt-patches::macaroni-phoenix-testing             - 20170826.1+1
🍦 [  4 of  42] [N] dev-libs/libyaml::macaroni-phoenix-testing                    - 0.2.5
🍦 [  5 of  42] [N] dev-python/aiofiles::macaroni-phoenix-testing                 - 23.2.1
🍦 [  6 of  42] [N] dev-python/anyio::macaroni-phoenix-testing                    - 4.0.0
🍦 [  7 of  42] [N] dev-python/async-generator::macaroni-phoenix-testing          - 1.10
🍦 [  8 of  42] [N] dev-python/beautifulsoup::macaroni-phoenix-testing            - 4.12.2
🍦 [  9 of  42] [N] dev-python/certifi::macaroni-phoenix-testing                  - 10001
🍦 [ 10 of  42] [N] dev-python/colorama::macaroni-phoenix-testing                 - 0.4.6
🍦 [ 11 of  42] [N] dev-python/curio::macaroni-phoenix-testing                    - 1.6
🍦 [ 12 of  42] [N] dev-python/cython::macaroni-phoenix-testing                   - 0.29.36
🍦 [ 13 of  42] [N] dev-python/dict-toolbox::macaroni-phoenix-testing             - 5.0.0
🍦 [ 14 of  42] [N] dev-python/exceptiongroup::macaroni-phoenix-testing           - 1.1.2
🍦 [ 15 of  42] [N] dev-python/h11::macaroni-phoenix-testing                      - 0.14.0
🍦 [ 16 of  42] [N] dev-python/h2::macaroni-phoenix-testing                       - 4.1.0
🍦 [ 17 of  42] [N] dev-python/hpack::macaroni-phoenix-testing                    - 4.0.0
🍦 [ 18 of  42] [N] dev-python/httpcore::macaroni-phoenix-testing                 - 1.0.0
🍦 [ 19 of  42] [N] dev-python/httpx::macaroni-phoenix-testing                    - 0.25.0
🍦 [ 20 of  42] [N] dev-python/hyperframe::macaroni-phoenix-testing               - 6.0.1
🍦 [ 21 of  42] [N] dev-python/idna::macaroni-phoenix-testing                     - 3.4
🍦 [ 22 of  42] [N] dev-python/msgpack::macaroni-phoenix-testing                  - 1.0.7+1
🍦 [ 23 of  42] [N] dev-python/outcome::macaroni-phoenix-testing                  - 1.2.0
🍦 [ 24 of  42] [N] dev-python/psutil::macaroni-phoenix-testing                   - 5.9.6
🍦 [ 25 of  42] [N] dev-python/py::macaroni-phoenix-testing                       - 1.11.0
🍦 [ 26 of  42] [N] dev-python/pykerberos::macaroni-phoenix-testing               - 1.2.1
🍦 [ 27 of  42] [N] dev-python/pymongo::macaroni-phoenix-testing                  - 4.5.0
🍦 [ 28 of  42] [N] dev-python/pyyaml::macaroni-phoenix-testing                   - 6.0.1
🍦 [ 29 of  42] [N] dev-python/pyzmq::macaroni-phoenix-testing                    - 25.1.1
🍦 [ 30 of  42] [N] dev-python/rich::macaroni-phoenix-testing                     - 13.6.0
🍦 [ 31 of  42] [N] dev-python/sniffio::macaroni-phoenix-testing                  - 1.3.0
🍦 [ 32 of  42] [N] dev-python/sortedcontainers::macaroni-phoenix-testing         - 2.4.0
🍦 [ 33 of  42] [N] dev-python/soupsieve::macaroni-phoenix-testing                - 2.3.1
🍦 [ 34 of  42] [N] dev-python/trio::macaroni-phoenix-testing                     - 0.22.2
🍦 [ 35 of  42] [N] dev-python/xmltodict::macaroni-phoenix-testing                - 0.13.0
🍦 [ 36 of  42] [N] dev-util/meson::macaroni-phoenix-testing                      - 1.2.2
🍦 [ 37 of  42] [N] net-libs/zeromq::macaroni-phoenix-testing                     - 4.3.5
🍦 [ 38 of  42] [N] sys-apps/metatools::macaroni-phoenix-testing                  - 1.3.4
🍦 [ 39 of  42] [N] sys-devel/autoconf-archive::macaroni-phoenix-testing          - 2021.02.19
🍦 [ 40 of  42] [N] sys-devel/gcc-config::macaroni-phoenix-testing                - 2.4+1
🍦 [ 41 of  42] [N] sys-devel/make::macaroni-phoenix-testing                      - 4.2.1+1
🍦 [ 42 of  42] [N] sys-devel/patch::macaroni-phoenix-testing                     - 2.7.6+1
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 455608 µs).
Do you want to continue with this operation? [y/N]: y
🚚 Downloading 42 packages...
📦 [  1 of  42] dev-python/httpcore::macaroni-phoenix-testing                     - 1.0.0           # downloaded ✔ 
📦 [  2 of  42] dev-python/pykerberos::macaroni-phoenix-testing                   - 1.2.1           # downloaded ✔ 
📦 [  3 of  42] dev-python/rich::macaroni-phoenix-testing                         - 13.6.0          # downloaded ✔ 
📦 [  4 of  42] dev-python/xmltodict::macaroni-phoenix-testing                    - 0.13.0          # downloaded ✔ 
📦 [  5 of  42] dev-python/aiofiles::macaroni-phoenix-testing                     - 23.2.1          # downloaded ✔ 
📦 [  6 of  42] dev-python/cython::macaroni-phoenix-testing                       - 0.29.36         # downloaded ✔
📦 [  7 of  42] dev-python/pyyaml::macaroni-phoenix-testing                       - 6.0.1           # downloaded ✔ 
📦 [  8 of  42] dev-python/outcome::macaroni-phoenix-testing                      - 1.2.0           # downloaded ✔ 
📦 [  9 of  42] net-libs/zeromq::macaroni-phoenix-testing                         - 4.3.5           # downloaded ✔ 
📦 [ 10 of  42] dev-python/pyzmq::macaroni-phoenix-testing                        - 25.1.1          # downloaded ✔ 
📦 [ 11 of  42] sys-devel/make::macaroni-phoenix-testing                          - 4.2.1+1         # downloaded ✔ 
📦 [ 12 of  42] dev-python/soupsieve::macaroni-phoenix-testing                    - 2.3.1           # downloaded ✔ 
📦 [ 13 of  42] dev-python/colorama::macaroni-phoenix-testing                     - 0.4.6           # downloaded ✔ 
📦 [ 14 of  42] dev-python/trio::macaroni-phoenix-testing                         - 0.22.2          # downloaded ✔ 
📦 [ 15 of  42] dev-python/certifi::macaroni-phoenix-testing                      - 10001           # downloaded ✔ 
📦 [ 16 of  42] app-admin/ego::macaroni-phoenix-testing                           - 2.8.7+1         # downloaded ✔ 
📦 [ 17 of  42] dev-python/dict-toolbox::macaroni-phoenix-testing                 - 5.0.0           # downloaded ✔ 
📦 [ 18 of  42] dev-python/hyperframe::macaroni-phoenix-testing                   - 6.0.1           # downloaded ✔ 
📦 [ 19 of  42] sys-apps/metatools::macaroni-phoenix-testing                      - 1.3.4           # downloaded ✔ 
📦 [ 20 of  42] dev-python/h11::macaroni-phoenix-testing                          - 0.14.0          # downloaded ✔ 
📦 [ 21 of  42] dev-python/psutil::macaroni-phoenix-testing                       - 5.9.6           # downloaded ✔ 
📦 [ 22 of  42] dev-python/pymongo::macaroni-phoenix-testing                      - 4.5.0           # downloaded ✔ 
📦 [ 23 of  42] dev-util/meson::macaroni-phoenix-testing                          - 1.2.2           # downloaded ✔ 
📦 [ 24 of  42] app-portage/elt-patches::macaroni-phoenix-testing                 - 20170826.1+1    # downloaded ✔ 
📦 [ 25 of  42] app-arch/unzip::macaroni-phoenix-testing                          - 6.0+1           # downloaded ✔ 
📦 [ 26 of  42] dev-python/idna::macaroni-phoenix-testing                         - 3.4             # downloaded ✔ 
📦 [ 27 of  42] dev-python/sortedcontainers::macaroni-phoenix-testing             - 2.4.0           # downloaded ✔ 
📦 [ 28 of  42] dev-libs/libyaml::macaroni-phoenix-testing                        - 0.2.5           # downloaded ✔ 
📦 [ 29 of  42] dev-python/msgpack::macaroni-phoenix-testing                      - 1.0.7+1         # downloaded ✔ 
📦 [ 30 of  42] dev-python/h2::macaroni-phoenix-testing                           - 4.1.0           # downloaded ✔ 
📦 [ 31 of  42] dev-python/py::macaroni-phoenix-testing                           - 1.11.0          # downloaded ✔ 
📦 [ 32 of  42] sys-devel/patch::macaroni-phoenix-testing                         - 2.7.6+1         # downloaded ✔ 
📦 [ 33 of  42] dev-python/curio::macaroni-phoenix-testing                        - 1.6             # downloaded ✔ 
📦 [ 34 of  42] dev-python/async-generator::macaroni-phoenix-testing              - 1.10            # downloaded ✔ 
📦 [ 35 of  42] dev-python/anyio::macaroni-phoenix-testing                        - 4.0.0           # downloaded ✔ 
📦 [ 36 of  42] dev-python/httpx::macaroni-phoenix-testing                        - 0.25.0          # downloaded ✔ 
📦 [ 37 of  42] sys-devel/autoconf-archive::macaroni-phoenix-testing              - 2021.02.19      # downloaded ✔ 
📦 [ 38 of  42] sys-devel/gcc-config::macaroni-phoenix-testing                    - 2.4+1           # downloaded ✔ 
📦 [ 39 of  42] dev-python/beautifulsoup::macaroni-phoenix-testing                - 4.12.2          # downloaded ✔ 
📦 [ 40 of  42] dev-python/exceptiongroup::macaroni-phoenix-testing               - 1.1.2           # downloaded ✔ 
📦 [ 41 of  42] dev-python/sniffio::macaroni-phoenix-testing                      - 1.3.0           # downloaded ✔ 
📦 [ 42 of  42] dev-python/hpack::macaroni-phoenix-testing                        - 4.0.0           # downloaded ✔ 
🧠 Sorting 42 packages operations...
🍻 Executing 42 packages operations...
🍰 [  1 of  42] app-admin/ego::macaroni-phoenix-testing                           - 2.8.7+1         # installed ✔ 
🍰 [  2 of  42] app-arch/unzip::macaroni-phoenix-testing                          - 6.0+1           # installed ✔ 
🍰 [  3 of  42] app-portage/elt-patches::macaroni-phoenix-testing                 - 20170826.1+1    # installed ✔ 
🍰 [  4 of  42] dev-libs/libyaml::macaroni-phoenix-testing                        - 0.2.5           # installed ✔ 
🍰 [  5 of  42] dev-python/aiofiles::macaroni-phoenix-testing                     - 23.2.1          # installed ✔ 
🍰 [  6 of  42] dev-python/async-generator::macaroni-phoenix-testing              - 1.10            # installed ✔ 
🍰 [  7 of  42] dev-python/certifi::macaroni-phoenix-testing                      - 10001           # installed ✔ 
🍰 [  8 of  42] dev-python/colorama::macaroni-phoenix-testing                     - 0.4.6           # installed ✔ 
🍰 [  9 of  42] dev-python/curio::macaroni-phoenix-testing                        - 1.6             # installed ✔ 
🍰 [ 10 of  42] dev-python/cython::macaroni-phoenix-testing                       - 0.29.36         # installed ✔ 
🍰 [ 11 of  42] dev-python/exceptiongroup::macaroni-phoenix-testing               - 1.1.2           # installed ✔ 
🍰 [ 12 of  42] dev-python/h11::macaroni-phoenix-testing                          - 0.14.0          # installed ✔ 
🍰 [ 13 of  42] dev-python/hpack::macaroni-phoenix-testing                        - 4.0.0           # installed ✔ 
🍰 [ 14 of  42] dev-python/hyperframe::macaroni-phoenix-testing                   - 6.0.1           # installed ✔ 
🍰 [ 15 of  42] dev-python/idna::macaroni-phoenix-testing                         - 3.4             # installed ✔ 
🍰 [ 16 of  42] dev-python/msgpack::macaroni-phoenix-testing                      - 1.0.7+1         # installed ✔ 
🍰 [ 17 of  42] dev-python/outcome::macaroni-phoenix-testing                      - 1.2.0           # installed ✔ 
🍰 [ 18 of  42] dev-python/psutil::macaroni-phoenix-testing                       - 5.9.6           # installed ✔ 
🍰 [ 19 of  42] dev-python/py::macaroni-phoenix-testing                           - 1.11.0          # installed ✔ 
🍰 [ 20 of  42] dev-python/pykerberos::macaroni-phoenix-testing                   - 1.2.1           # installed ✔ 
🍰 [ 21 of  42] dev-python/rich::macaroni-phoenix-testing                         - 13.6.0          # installed ✔ 
🍰 [ 22 of  42] dev-python/sniffio::macaroni-phoenix-testing                      - 1.3.0           # installed ✔ 
🍰 [ 23 of  42] dev-python/sortedcontainers::macaroni-phoenix-testing             - 2.4.0           # installed ✔ 
🍰 [ 24 of  42] dev-python/soupsieve::macaroni-phoenix-testing                    - 2.3.1           # installed ✔ 
🍰 [ 25 of  42] dev-python/xmltodict::macaroni-phoenix-testing                    - 0.13.0          # installed ✔ 
🍰 [ 26 of  42] dev-util/meson::macaroni-phoenix-testing                          - 1.2.2           # installed ✔ 
🍰 [ 27 of  42] net-libs/zeromq::macaroni-phoenix-testing                         - 4.3.5           # installed ✔ 
🍰 [ 28 of  42] sys-devel/autoconf-archive::macaroni-phoenix-testing              - 2021.02.19      # installed ✔ 
🍰 [ 29 of  42] sys-devel/gcc-config::macaroni-phoenix-testing                    - 2.4+1           # installed ✔ 
🍰 [ 30 of  42] sys-devel/make::macaroni-phoenix-testing                          - 4.2.1+1         # installed ✔ 
🍰 [ 31 of  42] sys-devel/patch::macaroni-phoenix-testing                         - 2.7.6+1         # installed ✔ 
🍰 [ 32 of  42] dev-python/beautifulsoup::macaroni-phoenix-testing                - 4.12.2          # installed ✔ 
🍰 [ 33 of  42] dev-python/pymongo::macaroni-phoenix-testing                      - 4.5.0           # installed ✔ 
🍰 [ 34 of  42] dev-python/h2::macaroni-phoenix-testing                           - 4.1.0           # installed ✔ 
🍰 [ 35 of  42] dev-python/pyyaml::macaroni-phoenix-testing                       - 6.0.1           # installed ✔ 
🍰 [ 36 of  42] dev-python/pyzmq::macaroni-phoenix-testing                        - 25.1.1          # installed ✔ 
🍰 [ 37 of  42] dev-python/dict-toolbox::macaroni-phoenix-testing                 - 5.0.0           # installed ✔ 
🍰 [ 38 of  42] dev-python/trio::macaroni-phoenix-testing                         - 0.22.2          # installed ✔ 
🍰 [ 39 of  42] dev-python/anyio::macaroni-phoenix-testing                        - 4.0.0           # installed ✔ 
🍰 [ 40 of  42] dev-python/httpcore::macaroni-phoenix-testing                     - 1.0.0           # installed ✔ 
🍰 [ 41 of  42] dev-python/httpx::macaroni-phoenix-testing                        - 0.25.0          # installed ✔ 
🍰 [ 42 of  42] sys-apps/metatools::macaroni-phoenix-testing                      - 1.3.4           # installed ✔ 
Executing finalizer for app-admin/ego-2.8.7+1
🐚  Executing finalizer on  / /bin/bash [-c entities merge --specs-dir /usr/share/macaroni/entities/ -e sync]
Merged users sync.
Merged shadow sync.
All done.

🎊 All done.

```

The package to install with the Funtoo kits used in the buiding process is this, and eventually
you can install it inside the previous command:

```bash
$> anise i meta-repo meta-geaaru-kit
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🧠 Solving install tree...
🍦 [  1 of   2] [N] toolchain/meta-geaaru-kit::macaroni-phoenix-testing           - 0.20231025
🍦 [  2 of   2] [N] toolchain/meta-repo::macaroni-phoenix-testing                 - 0.20231017
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 282713 µs).
Do you want to continue with this operation? [y/N]: y
🚚 Downloading 2 packages...
📦 [  1 of   2] toolchain/meta-geaaru-kit::macaroni-phoenix-testing               - 0.20231025      # downloaded ✔
📦 [  2 of   2] toolchain/meta-repo::macaroni-phoenix-testing                     - 0.20231017      # downloaded ✔
🧠 Sorting 2 packages operations...
🍻 Executing 2 packages operations...
🍰 [  1 of   2] toolchain/meta-geaaru-kit::macaroni-phoenix-testing               - 0.20231025      # installed ✔ 
🍰 [  2 of   2] toolchain/meta-repo::macaroni-phoenix-testing                     - 0.20231017      # installed ✔ 
🎊 All done.

```

We suggest installing the extra kit *geaaru-kit* because the same ebuilds with patches are released
there before opening a PR to the Funtoo community or there are packages that follow a different
release pipeline like LXD.

**NOTE: The `virtual/base` package (already available) installs in the finalize the file `/etc/portage/make.conf`
        with the only variable `CHOST` because without it and without the setup of the profiles the emerge
        doesn't work correctly.**

```
$> cat /etc/portage/make.conf
CHOST="x86_64-pc-linux-gnu"
```

You are free to modify it if you need.


#### 3. Configure GCC

```
$> gcc-config 1
 * Switching native-compiler to x86_64-pc-linux-gnu-11.3.0 ...
>>> Regenerating /etc/ld.so.cache...                                 [ ok ]

 * If you intend to use the gcc from the new profile in an already
 * running shell, please remember to do:

 *   . /etc/profile


$> source /etc/profile
```

#### 4. Play with `emerge`

You can now play with `emerge` as you do in Funtoo.

Playing with `emerge` you could be in the case where the installation
of a package require a lot of dependencies that are missing.
In this case, you can just check with `--pretend` option what packages are candidates
for installation and use `anise` to install them and just leave the package
you need for the compilation, or just compile everything.

This a little tip to use emerge to get the list of the dependencies to install and
through `pkgs-checker` and `jq` convert the gentoo package string and retrieve the
package name. It's just an example, we will have a finer integration with
`anise-portage-converter` soon.

So, for example if we want to `emerge` the *app-admin/cloud-init* package and
the `--pretend` output is this:


```
$> emerge cloud-init -pv --onlydeps 

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild  N     ] net-analyzer/macchanger-1.7.0-r1::net-kit  388 KiB
[ebuild  N     ] dev-python/jsonpointer-2.4::python-modules-kit  PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 10 KiB
[ebuild  N     ] dev-python/chardet-5.2.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 2,022 KiB
[ebuild  N     ] dev-python/urllib3-1.26.15-r2::python-modules-kit  PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 295 KiB
[ebuild  N     ] dev-python/charset_normalizer-3.3.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 102 KiB
[ebuild  N     ] dev-python/pyopenssl-23.2.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 181 KiB
[ebuild  N     ] dev-python/semantic_version-2.10.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 52 KiB
[ebuild  N     ] dev-python/installer-0.5.1-r1::python-modules-kit  USE="-test" PYTHON_TARGETS="python3_9 -pypy3 -python3_10 -python3_7 -python3_8" 900 KiB
[ebuild  N     ] dev-python/pyjwt-2.8.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 77 KiB
[ebuild  N     ] dev-python/blinker-1.6.3::python-modules-kit  USE="-doc -test" PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 28 KiB
[ebuild  N     ] virtual/python-enum34-2::python-modules-kit  PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 0 KiB
[ebuild  N     ] virtual/python-ipaddress-1.0-r1::python-modules-kit  PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 0 KiB
[ebuild  N     ] dev-python/pyserial-3.4::python-modules-kit  USE="-doc -examples" PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 149 KiB
[ebuild  N     ] dev-python/configobj-5.0.8::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 38 KiB
[ebuild  N     ] sys-fs/growpart-0.0.30::core-kit  8 KiB
[ebuild  N     ] dev-python/gpep517-15::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 20 KiB
[ebuild  N     ] app-admin/metalog-20200113::core-kit  USE="unicode" 40 KiB
[ebuild  N     ] dev-python/jsonpatch-1.23::python-modules-kit  USE="-test" PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 18 KiB
[ebuild  N     ] dev-python/flit_core-3.9.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 41 KiB
[ebuild  N     ] virtual/logger-0-r1::core-kit  0 KiB
[ebuild  N     ] dev-python/wheel-0.41.2::python-modules-kit  PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 96 KiB
[ebuild  N     ] dev-python/setuptools-rust-1.7.0::python-modules-kit  PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 297 KiB
[ebuild  N     ] dev-python/cryptography-41.0.4::python-modules-kit  USE="-debug -idna -libressl" CPU_FLAGS_X86="sse2" PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 10,196 KiB
[ebuild  N     ] dev-python/oauthlib-3.0.1::python-modules-kit  USE="-test" PYTHON_TARGETS="python3_9 -python2_7 -python3_10 -python3_7 -python3_8" 146 KiB
[ebuild  N     ] dev-python/requests-2.31.0::python-modules-kit  USE="ssl -socks5" PYTHON_TARGETS="python3_9 -pypy3 -python2_7 -python3_10 -python3_7 -python3_8" 109 KiB

Total: 25 packages (25 new), Size of downloads: 15,200 KiB

!!! The following installed packages are masked:
- media-libs/fdk-aac-2.0.2::media-kit (masked by: FraunhoferFDK license(s))
A copy of the 'FraunhoferFDK' license is located at '/var/git/meta-repo/kits/media-kit/licenses/FraunhoferFDK'.

For more information, see the MASKED PACKAGES section in the emerge
man page or refer to the Gentoo Handbook.

```

And we can install dependencies from Macaroni repositories with this bashing:

```bash
$> anise i pkgs-checker-minimal
...
```

```bash
$> anise i $(for i in $(emerge cloud-init -p --quiet --color n --onlydeps 2>/dev/null | grep "ebuild" | awk '{ print $4 }'); do pkgs-checker pkg info $i -j | jq '.name' -r   ; done )
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🧠 Solving install tree...
🍦 [  1 of  25] [N] app-admin/metalog::macaroni-phoenix-testing                   - 20200113
🍦 [  2 of  25] [N] dev-python/blinker::macaroni-phoenix-testing                  - 1.6.3
🍦 [  3 of  25] [N] dev-python/chardet::macaroni-phoenix-testing                  - 5.2.0
🍦 [  4 of  25] [N] dev-python/charset_normalizer::macaroni-phoenix-testing       - 3.3.0
🍦 [  5 of  25] [N] dev-python/configobj::macaroni-phoenix-testing                - 5.0.8
🍦 [  6 of  25] [N] dev-python/cryptography::macaroni-phoenix-testing             - 41.0.4
🍦 [  7 of  25] [N] dev-python/flit_core::macaroni-phoenix-testing                - 3.9.0
🍦 [  8 of  25] [N] dev-python/gpep517::macaroni-phoenix-testing                  - 15
🍦 [  9 of  25] [N] dev-python/installer::macaroni-phoenix-testing                - 0.5.1+1
🍦 [ 10 of  25] [N] dev-python/jsonpatch::macaroni-phoenix-testing                - 1.23
🍦 [ 11 of  25] [N] dev-python/jsonpointer::macaroni-phoenix-testing              - 2.4
🍦 [ 12 of  25] [N] dev-python/oauthlib::macaroni-phoenix-testing                 - 3.0.1
🍦 [ 13 of  25] [N] dev-python/pyjwt::macaroni-phoenix-testing                    - 2.8.0
🍦 [ 14 of  25] [N] dev-python/pyopenssl::macaroni-phoenix-testing                - 23.2.0
🍦 [ 15 of  25] [N] dev-python/pyserial::macaroni-phoenix-testing                 - 3.4
🍦 [ 16 of  25] [N] dev-python/requests::macaroni-phoenix-testing                 - 2.31.0
🍦 [ 17 of  25] [N] dev-python/semantic_version::macaroni-phoenix-testing         - 2.10.0
🍦 [ 18 of  25] [N] dev-python/setuptools-rust::macaroni-phoenix-testing          - 1.7.0+1
🍦 [ 19 of  25] [N] dev-python/urllib3::macaroni-phoenix-testing                  - 1.26.15
🍦 [ 20 of  25] [N] dev-python/wheel::macaroni-phoenix-testing                    - 0.41.2
🍦 [ 21 of  25] [N] net-analyzer/macchanger::macaroni-phoenix-testing             - 1.7.0
🍦 [ 22 of  25] [N] sys-fs/growpart::macaroni-phoenix-testing                     - 0.0.30
🍦 [ 23 of  25] [N] virtual/logger::macaroni-phoenix-testing                      - 0
🍦 [ 24 of  25] [N] virtual/python-enum34::macaroni-phoenix-testing               - 2
🍦 [ 25 of  25] [N] virtual/python-ipaddress::macaroni-phoenix-testing            - 1.0
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 69337 µs).
Do you want to continue with this operation? [y/N]: y
...
...
```

And later:

```
$> emerge cloud-init -t

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild  N     ] app-admin/cloud-init-23.3.2::core-server-kit  USE="-systemd -test" PYTHON_TARGETS="python3_9 -python3_10 -python3_7 -python3_8" 5,605 KiB

...


>>> Installing (1 of 1) app-admin/cloud-init-23.3.2::core-server-kit
 * cloud-init-local needs to be run in the boot runlevel because it
 * modifies services in the default runlevel.  When a runlevel is started
 * it is cached, so modifications that happen to the current runlevel
 * while you are in it are not acted upon.

>>> Recording app-admin/cloud-init in "world" favorites file...

 * Messages for package app-admin/cloud-init-23.3.2:

 * cloud-init-local needs to be run in the boot runlevel because it
 * modifies services in the default runlevel.  When a runlevel is started
 * it is cached, so modifications that happen to the current runlevel
 * while you are in it are not acted upon.
>>> Auto-cleaning packages...

>>> No outdated packages were found on your system.

```

*NOTE: On using *emerge* it's possible that you will catch some warning about the COUNTER
available in the packages installed by `anise`, but this happens because the value
is related to the build process and not to the installed order. Probably, in the near
future could be a good idea to set the COUNTER to zero for all Macaroni packages.*

#### 5. Sync the packages installed with `emerge` to Macaroni database

To sync the package installed with emerge to `anise` database you need
to have installed the `anise-portage-converter` package.

So, if it isn't present just run this command:

```bash
$> anise i anise-portage-converter
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🧠 Solving install tree...
🍦 [  1 of   1] [N] macaroni/anise-portage-converter::macaroni-commons-testing    - 0.14.3
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 3034 µs).
Do you want to continue with this operation? [y/N]: y
🚚 Downloading 1 packages...
📦 [  1 of   1] macaroni/anise-portage-converter::macaroni-commons-testing        - 0.14.3          # downloaded ✔
🧠 Sorting 1 packages operations...
🍻 Executing 1 packages operations...
🍰 [  1 of   1] macaroni/anise-portage-converter::macaroni-commons-testing        - 0.14.3          # installed ✔
🎊 All done.

```

And later sync the package to the database, eventually running the same command with
`--dry-run` to verify the behavior before propagate the change:

```bash
$> anise-portage-converter sync --dry-run
[   5/ 833] [app-admin/cloud-init] Package with version 23.3.2 not found on anise database.
[   5/ 833] [app-admin/cloud-init] 23.3.2 candidated for sync ✔️
```

In the output the number 5 means that the package is the fifth analyzed among a total
of 883 packages present in the `/var/db/pkg` directory.

To complete the sync to the `anise` database:

```bash
$> anise-portage-converter sync
[   5/ 833] [app-admin/cloud-init] Package with version 23.3.2 not found on anise database.
[   5/ 833] [app-admin/cloud-init] 23.3.2 added ✔️

$> anise s --installed cloud-init
app-admin/cloud-init-23.3.2
```

Normally, after that sync if the package is available with the same version the solver
tries to replace it with the Macaroni repository because the package *hash* doesn't match
with the value calculated from the metadata of the Macaroni repository:

```bash
$> luet upgrade
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍬 [  1 of   5] [U] app-admin/cloud-init::macaroni-phoenix-testing                - *23.3.2 [23.3.2::scm]
🧁 [  2 of   5] [U] macaroni/whip-catalog::macaroni-commons-testing               - 0.20231107 [0.20231104+1]
🧁 [  3 of   5] [U] sys-fs/fuse-exfat::macaroni-phoenix-testing                   - *1.3.0+1 [1.3.0+1]
🧁 [  4 of   5] [U] sys-process/htop::macaroni-phoenix-testing                    - *3.2.2 [3.2.2]
🧁 [  5 of   5] [U] system/luet-geaaru-testing::mottainai-testing                 - 0.40.1 [0.40.0]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 35608 µs).
Do you want to continue with this operation? [y/N]: N
```

If the package installed with emerge (identified by the `scm` repository) has a version greather than
the version available in the Macaroni repository the solver will skipp the replace if the `--deep`
option is not used.

Instead, if you want to avoid upgrade of the package `app-admin/cloud-init` and to maintain
the compiled version you can mask the package:

```
$> mkdir -p /etc/luet/mask.d || true
$> echo "
enabled: true
rules:
  - app-admin/cloud-init
" > /etc/luet/mask.d/00-mymask.yml
```

And later the package will not be candidates for the upgrade:

```bash
$> luet upgrade
🚀 Luet 0.40.0-geaaru-geaef4995d713afd2937c67f255dff229e555eba8 2023-11-03 10:10:38 UTC - go1.20.3
🏠 Repository:              geaaru-repo-index Revision:   11 - 2023-10-22 21:25:30 +0200 CEST
🏠 Repository:       macaroni-commons-testing Revision:  194 - 2023-11-07 23:12:45 +0100 CET
🏠 Repository:       macaroni-phoenix-testing Revision: 1043 - 2023-11-10 15:20:40 +0100 CET
🏠 Repository:              mottainai-testing Revision:  113 - 2023-11-06 19:36:11 +0100 CET
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🧁 [  1 of   4] [U] macaroni/whip-catalog::macaroni-commons-testing               - 0.20231107 [0.20231104+1]
🧁 [  2 of   4] [U] sys-fs/fuse-exfat::macaroni-phoenix-testing                   - *1.3.0+1 [1.3.0+1]
🧁 [  3 of   4] [U] sys-process/htop::macaroni-phoenix-testing                    - *3.2.2 [3.2.2]
🧁 [  4 of   4] [U] system/luet-geaaru-testing::mottainai-testing                 - 0.40.1 [0.40.0]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 779 µs).
Do you want to continue with this operation? [y/N]: 
```

The rules could be mapped to a specific repository too, for example,
*app-admin/cloud-init::macaroni-phoenix-testing*, or for a specific version,
for example *=app-admin/cloud-init-23.3.2*. With this last configuration could be good
to keep the version with the patch and installed with `emerge` until a new version will
be available from Macaroni.

Enjoy!
