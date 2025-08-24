---
title: "Differences between MARK and Sambuca"
type: docs
---

# Main differences between MARK and Sambuca

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

This will not be a real difference when the issue [#27](https://github.com/macaroni-os/mark-issues/issues/27)
will be completed but at the moment, MARK uses the `user.eclass` available in
the tree to dynamically create new users/groups.
We don't follow the Gentoo behaviour with `acct-*` packages.


## 2. USE flags not aligned to MARK Profiles

In order to have binary packages to support different DEs and different
features is needed mix different profiles, mix-in and USEs.
To reach this target means that a lot of USE flags must be enabled
but without trying to inject unnecessary dependencies when possible.
So, for this reason, the control of the use flags selected for every
package is done by the `anise-portage-converter` tool on build phase,
that permits to override existing dependencies and/or elaborate
dependencies based on the use flags defined in the `anise-portage-converter`
specs. This permits great control of the compilation process but
unfortunately, doesn't permit it to maintain compatibility with the MARK
profiles that are used to configure the use flags based on the needs
of the users and their choice. This means that installing Macaroni's
packages and just using `emerge` could be not managed with a simple
configuration of the MARK profiles and instead it's highly probable
that just trying to emerge the *world* will ask for changes of the
use flags used instead by Sambuca stack.


If the users prefer to use more the binary stack and keep MARK to apply
particular patch, recompile specific packages with additional
CFLAGS, LDFLAGS, etc. it's needed force definition of USE under
`/etc/portage/package.use/`. This behaviour override the normal MARK
logic but could be later customized by the users. To help users in this
join it's available the tool `pkgs-checker` that permits to generate
the file with all USE of the installed packages. So, a possible workflow
could be, install all binary packages needed and later executed these
commands:

```bash
$> # Install pkgs-checker if not available
$> anise i -y pkgs-checker # or `emerge pkgs-checker`
$> mkdir -p /etc/portage/package.use
$> pkgs-checker portage gen-pkgs-uses --filter-opts \
    /usr/share/pkgs-checker/gen-uses-filter.yaml  > /etc/portage/package.use/99-pkgs-checker.use
```

Normally, this operation could be executed after every *anise*
upgrade or a new packages installed. The `pkgs-checker` reads the
directory `/var/db/pkg` and retrieve all used USE flags and write them
to the stdout.

## 3. Split packages

In order to support multiple use cases but with fewer dependencies
injected we have some packages that have been split without having a 1:1 map
with an ebuild. For example, the *pinentry* package installs additional binary
when `gtk`/`gnome` use flag is enabled with the `pinetry-gnome` binary or with
the `qt` use flag the `pinentry-qt`, etc.
Thanks to our build process it's very easy to assign the specific file to
a specific package, but this package will be without portage metadata and
instead, the use flags of the main *pinentry* package will be minimal.

Probably, in the near future we will split also the MARK packages in order
to avoid these differences and keep more aligned the Sambuca stack to MARK.

## 4. Packages from scratch


Sambuca stack doesn't depend strictly from MARK. `anise-build` can be used
to compiles packages from scratch (this is what we will do with MFS). For
this packages the users can retrieve installed files only with *anise* and
not from Portage tools.
This is a good example that Sambuca could be also a gate between different
worlds.

## 5. Portage metadata optional

The installation of the Portage metadata and the include files are optional,
they are installed only when the *subsets* `devel` and `portage` are enabled.
This permits users without the need to compile software to reduce space used
in their filesystem. Normally, the ISOs with *Mark* suffix are configured
with both subsets.

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
image where Python is not something needed, for example considering CD/CI
tasks, Macaroni implements the `macaronictl etc-update` that supplies 
an `etc-update` compliant command and as a replacer. It has a few differences 
that are more related to the interactive shell but for the rest, it's
pretty similar.

> **_NOTE:_** To use `macaronictl etc-update` is needed `sys-apps/diffutils`.


The same concept is applicable to the `macaronictl env-update` command that
reimplements a Portage-compliant logic. The behavior is configurable, instead
of updating every time the system and the (t)csh environment files, for these
two the configuration is enabled respectively with the options `--systemd` and `--csh`.

We suggest to use `macaronictl etc-update` and `macaronictl env-update`
instead of using the Portage tools.

## 7. Post-install/Post-remove commands

In the Funtoo/Gentoo world where every package is compiled the ebuild file
contains the instructions about how to compile the package supply yet the
steps for the post-installation and post-remove. Macaroni divides completely
the build process from the runtime/install phase and as described in the
previous chapters the Portage metadata could not be present, like the kits.
In Macaroni, the post-install and post-remove operations are managed by the
`finalizer` that could be added in the `anise` specs over the YAML file
`finalize.yaml` of the package. Due to the complexity of this phase, and
because sometimes could be helpful to re-run the post-install steps we have
created the tool **whip** that collects the instructions about what runs as
a specific hook. The hook is a scripted list of commands to run that will
be used also in the `pkg_postinstall` and `pkg_postrm` phases of the ebuild
in order to align the behaviour between MARK and Sambuca and to have a way
to easily force rerun of the postinstall scripts.

## 8. Anise solver logic

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
The *provides* was also present in the past in Portage as PROVIDES but later removed.

Third, the default behavior of the solver in the upgrading process is to select only
packages with a greater version for speedup reasons. The downgrade is possible on
adding `--deep` flag on `upgrade` command.
