---
title: "Funtoo zone"
type: docs
---

# Main differences between Funtoo and Macaroni OS

## 1. Static UID/GID

The system UID (user ID) and GID (group ID) of the major services are statically
allocated and managed through the `entities` tool and his catalog. This helps
to have an more linear installation between systems and help on share network
filesystem like NFS.

It possible to see the list of the available uid/gid with the following
command:

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

The `entities` tool is a replacer of the classic `adduser`, `gpasswd`, etc.

## 2. Use flags not aligned to Funtoo Profiles

Macaroni OS is a binaries-based distribution that wants to try to supply
multiple DE. To reach this target means that a lot of user flags must be
enabled but without trying to inject unnecessary dependencies when possible.
So, for this reason, the control of the use flags selected for every package
is done by the `anise-portage-converter` tool that permits to override
existing dependencies and/or elaborate dependencies based on the use flags
defined in the `anise-portage-converter` specs. This permits a major control
of the compilation process but unlucky, doesn't permit it to maintain
compatibility with the Funtoo profiles that are used to configure the use
flags based on the needs of the users and their choice. This means that
installing Macaroni's packages and just using `emerge` could be not managed
with a simple configuration of the Funtoo profiles and instead it's highly
probable that just trying to emerge the `@world` will ask for changes of the
use flags used instead by Macaroni.

## 3. Split packages

So, in order to support multiple use cases but will fewer dependencies
injected we have some packages that are been split without having a map 1:1
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

The official `images.linuxcontainers.org` contains the Funtoo LXD images so we could
launch the container with this command:

```
$> lxc launch -p default images:funtoo/1.4 test

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
$> lxc launch -p default images:funtoo/next test

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
