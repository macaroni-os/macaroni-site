---
title: "Package Manager System"
type: docs
---

# Package Manager System

The Package Manager System of the Macaroni OS is
[luet](https://github.com/geaaru/luet/). It's written
in Golang and it has zero dependencies and permits to
prepare environments "from scratch".

It was initially based on branch 0.16 of the Mocaccino OS's
PMS but later is totally rewritten.

It's composed of two different binary: the `luet` binary is
the PMS client used by users to install packages and the
`luet-build` binary is used to build packages and bump a
new repository revision.

It will be rebranding soon in `anise`.

# Luet

### 1. Repositories or Wagons

In computer science in general, the term `repository` describes the place
where is available a list of packages.

I saw often in my life that mapping computer science's terms with real entities
helps users to create relationships in their minds.
So, playing with the term, a synonym of `repository` is also `coal/salt's mine
or gold mine`. Following this concept in `Luet` a repository is a `wagon` where
the stones are the packages that a user could require that are got from the gold mine.

The `wagon identity` is the card that describes the specific wagon: the name,
the revision id, the date when the wagon is been prepared, and the URLs are
the mine tracks used to get the stones. In addition, for every wagon identity
there are different `wagon document` that contains:

1. the metafile `repository.meta.yaml.tar[.gz|.zstd]`: this file is deprecated and will be
   removed soon. It contains metadata of all stones available in the wagon.
   Will be soon removed because having a big file with all metadata together
   consumes a lot of memory resources in the sync phase. It's better to have
   a tarball with multiple files with the right directories tree.

2. the tree tarball `tree.tar[.gz|.zstd]`: this file contains the packages
   specs (*definition.yaml*) of the packages present on the source repository
   when the repository is been bumped.

3. the compiler tree tarball `compilertree.tar[.gz|.zstd]`: this file contains
   the build specs (*build.yaml*) of the packages present of the source repository
   when the repository is been bumped.

The wagon documents are validated with a checksum through the first repository
file `repository.yaml` that is been created with a limited number of pieces of
information to speed up the checks of the updates.

Hereinafter, an example of the files downloaded in the repo sync phase:

```bash
$> luet repo update --debug mottainai-stable
DEBUG (root.go:#51:github.com/geaaru/luet/cmd.LoadConfig) Using config file: /etc/luet/luet.yaml
DEBUG (loader.go:#38:github.com/geaaru/luet/pkg/repository.LoadRepositories) Parsing Repository Directory /etc/luet/repos.conf.d ...
DEBUG (wagon.go:#155:github.com/geaaru/luet/pkg/v2/repository.(*WagonRepository).Sync) Sync of the repository mottainai-stable in progress...
DEBUG (http.go:#243:github.com/geaaru/luet/pkg/v2/repository/client.(*HttpClient).DownloadFile) Downloading https://dl.macaronios.org/repos/mottainai/repository.yaml
DEBUG (http.go:#255:github.com/geaaru/luet/pkg/v2/repository/client.(*HttpClient).DownloadFile) Downloaded repository.yaml of 0.00 MB ( 0.00 MiB/s )
DEBUG (http.go:#243:github.com/geaaru/luet/pkg/v2/repository/client.(*HttpClient).DownloadFile) Downloading https://dl.macaronios.org/repos/mottainai/tree.tar.zst
DEBUG (http.go:#255:github.com/geaaru/luet/pkg/v2/repository/client.(*HttpClient).DownloadFile) Downloaded tree.tar.zst of 0.00 MB ( 0.00 MiB/s )
DEBUG (wagon.go:#207:github.com/geaaru/luet/pkg/v2/repository.(*WagonRepository).Sync) Tree tarball for the repository mottainai-stable downloaded correctly.
DEBUG (http.go:#243:github.com/geaaru/luet/pkg/v2/repository/client.(*HttpClient).DownloadFile) Downloading https://dl.macaronios.org/repos/mottainai/repository.meta.yaml.tar.zst
DEBUG (http.go:#255:github.com/geaaru/luet/pkg/v2/repository/client.(*HttpClient).DownloadFile) Downloaded repository.meta.yaml.tar.zst of 0.30 MB ( 0.17 MiB/s )
DEBUG (wagon.go:#215:github.com/geaaru/luet/pkg/v2/repository.(*WagonRepository).Sync) Metadata tarball for the repository mottainai-stable downloaded correctly.
DEBUG (wagon.go:#228:github.com/geaaru/luet/pkg/v2/repository.(*WagonRepository).Sync) Decompress tree of the repository mottainai-stable...
🏠 Repository:               mottainai-stable Revision:  88 - 2023-04-21 16:15:48 +0000 UTC
DEBUG (wagon.go:#289:github.com/geaaru/luet/pkg/v2/repository.(*WagonRepository).ExplodeMetadata) 
🏠 Repository:               mottainai-stable unpacking metadata. 
DEBUG (wagon_stones.go:#1100:github.com/geaaru/luet/pkg/v2/repository.(*WagonStones).LoadCatalog) [mottainai-stable] Found metafile /var/cache/luet/repos/mottainai-stable/metafs/repository.meta.yaml
DEBUG (wagon_stones.go:#1122:github.com/geaaru/luet/pkg/v2/repository.(*WagonStones).LoadCatalog) [mottainai-stable] metadata loaded in 199480 µs.
```

In particolar, the sync process download first the `repository.yaml` file:

```bash
$> curl https://dl.macaronios.org/repos/mottainai/repository.yaml
name: mottainai-stable
description: MottainaiCI Official Repository
urls:
- http://localhost:8000
type: http
enable: true
revision: 88
last_update: "1682093748"
index: []
repo_files:
  compilertree:
    filename: compilertree.tar.gz
    compressiontype: gzip
    checksums:
      sha256: 3e9827097fd8e046c0d74f44c25e8c474204e3bda2a7ca91f20c81965c2001bb
  meta:
    filename: repository.meta.yaml.tar.zst
    compressiontype: zstd
    checksums:
      sha256: c0305b0e757827f8538da003cbe6cf03d88fd8636313739892a2dc26cfaa46e3
  tree:
    filename: tree.tar.zst
    compressiontype: zstd
    checksums:
      sha256: 1fe37e7bf858bd8dd3f9c3d1c968081218d6dee8a12c0e3c26cd2c9109159b8e
```

and compare the `revision` and `last_update` fields to understand
if it's needed go ahead with the download of the wagon document's files.

The `urls` attribute of the `repository.yaml` is not used at the moment and
it sets with value used locally. It possible that will be removed in the near future
or used in validation phase.

The stones could be uncompressed, so shared as simple tar files, or compressed
in different formats: gzip or zstd.

The wagons used are based on YAML files that are installed under the directory
`/etc/luet/repos.conf.d` by default. Additional directories where read the
repositories YAML files could be added through the `luet.yaml` configuration
file. In particular, the directories are defined through the attribute
`repos_confdir`:

```yaml
# Define the list of directories where luet
# try for files with .yml extension that define
# luet repositories.
repos_confdir:
- /etc/luet/repos.conf.d
- /my-repos/
```

The location where the repositories metadata are unpacked depends on the
configuration parameter `system.database_path` that has the default value
equal to */var/cache/luet*.

In particular, under the directory */var/cache/luet* is present the `luet.db` file
that contains the local BoltDB database where are registered the installed packages,
the files of the installed packages, and the `finalize` of the packages when present.

At the moment the only supported database is BoltDB, but will be added the support
of new databases soon.

Under the directory */var/cache/luet* there are two directories:

* `packages`: under this directory have stored the tarballs downloaded before
  executing the installation.

* `repos`: under this directory are created the directories for every repository
  synced locally.

So, for every repository under the local repository are unpacked the metadata
tarballs, in particular:

* `metafs`: under the directory *metafs* is present the file *repository.meta.yaml*
  that contains the metadata of all packages. This directory will be removed in
  the next release of luet.

* `repository.yaml`: the *repository.yaml* contains the local data with the
  wagon identity data.

* `treefs`: under the directory *treefs* is unpacked the tree of the repository
  with the following pattern: `<package-category>/<package-name>/<package-version>/`.
  Under the package directory are present:

   - `definition.yaml`: the file from the repository sources with the main
     package metadata

   - `metadata.yaml`: this file is generated from client-side when
     a repository is synced. Will be generated by `luet-build` soon or
     just replaced only by the *metadata.json* file.

   - `metadata.json`: this file is generated from the client-side when a
     repository is synced. Will be generated by `luet-build` soon.
     It's used the JSON file instead of YAML because to elaborate
     the JSON file is faster than YAML.

* `provides.yaml`: to speed up the solver logic under the directory `treefs` is
  generated the file *provides.yaml* the contains a map of the packages with
  *provides*. Will be generated by `luet-build` soon.

```bash
$> ls  /var/cache/luet/repos/macaroni-eagle/treefs/
app-accessibility-2  dev-db           dev-libs       media-libs      provides.yaml    sys-libs-4.8
app-admin            dev-db-10.5      dev-libs-1     media-libs-1.0  sci-libs         sys-power
app-arch             dev-db-11        dev-libs-2     media-libs-2    seed             sys-process
app-crypt            dev-db-13        dev-libs-3     net-analyzer    sys-apps         system
app-crypt-1          dev-db-3         dev-lisp       net-dialup      sys-auth         toolchain
app-doc              dev-db-8.0       dev-lisp-2     net-dns         sys-block        virtual
app-editors          dev-go           dev-perl       net-firewall    sys-cluster      virtual-1
app-emulation        dev-java-11      dev-php        net-ftp         sys-devel        virtual-11
app-eselect          dev-java-17      dev-python     net-libs        sys-devel-1.16   virtual-17
app-metrics          dev-java-18      dev-python-3   net-libs-1.1    sys-devel-11     virtual-18
app-misc             dev-java-2       dev-scheme-12  net-mail        sys-devel-2      virtual-entities
app-portage          dev-java-3.6     dev-tex        net-misc        sys-devel-2.36   www-apps
app-shells           dev-java-8       dev-texlive    net-nds         sys-devel-2.69   www-client
app-text             dev-lang         dev-util       net-p2p         sys-devel-9.2.0  www-servers
app-text-3.0         dev-lang-2       dev-util-3     net-print       sys-fs           www-servers-2
app-text-4.1.2       dev-lang-2.7     dev-vcs        net-proxy       sys-fs-3         x11-apps
app-text-4.2         dev-lang-3.7     gnome-extra    net-vpn         sys-kernel       x11-base
app-text-4.3         dev-lang-7.4     mail-mta       net-wireless    sys-libs         x11-libs
app-text-4.5         dev-lang-8.1     media-fonts    perl-core       sys-libs-18.1    x11-misc
dev-cpp              dev-lang-stable  media-gfx      pkglist         sys-libs-2.2     x11-proto
```

Hereinafter, an example of a package directory:
```
$> ls  /var/cache/luet/repos/macaroni-eagle/treefs/sys-devel-9.2.0/gcc/9.2.0+1/
definition.yaml  metadata.json  metadata.yaml
```


#### 1.1 Show repositories

This command permits to see all installed repositories. In particular,
the enabled repositories are colored on green and instead the
disabled repositories are in red.

```
$> luet repo list --help
List of the configured repositories.

Usage:
  luet repo list [OPTIONS] [flags]

Flags:
      --disabled      Show only disabled repositories.
      --enabled       Show only enabled repositories.
  -h, --help          help for list
  -q, --quiet         Show only name of the repositories.
  -t, --type string   Filter repositories of a specific type
  -u, --urls          Show URLs of the repository. (only in normal mode).
```

The availables options are:

* `--urls`: Show the repositories URLs

* `--enabled`: Show only the enabled repositories

* `--disabled`: Show only the disabled repositories

* `--type <type>`: Filter for repositories of type specified.
  The types are: 'http', 'docker', 'disk'.

* `--quiet`: Show only name of the repositories.

#### 1.2 Enable one or more repositories

This command permits to enable repositories.

```
$> luet repo enable --help
Enable one or more repositories.

Usage:
  luet repo enable <repo1> ... <repoN> [flags]

Flags:
  -h, --help   help for enable
```

#### 1.3 Disable one or more repositories

This command permits to disable repositories.

```
$> luet repo disable --help
Disable one or more repositories.

Usage:
  luet repo disable <repo1> ... <repoN> [flags]

Flags:
  -h, --help   help for disable
```

#### 1.4 Update / Sync one or more repositories

This command permits to sync repositories metadata locally. When the repository
is not defined it tries to sync all enabled repositories.

```
# luet repo update --help
Update a specific cached repository or all cached repositories.

Usage:
  luet repo update [repo1] [repo2] [OPTIONS] [flags]

Aliases:
  update, up

Examples:

# Update all cached repositories:
$> luet repo update

# Update only repo1 and repo2
$> luet repo update repo1 repo2


Flags:
  -f, --force           Force resync.
  -h, --help            help for update
  -i, --ignore-errors   Ignore errors on sync repositories.
```

* `--force|-f` option permits to force updates of the local trees also when
  the revision is the same. This is needed for example when a new luet release
  introduces new local logics.

* `--ignore-errors|-i` option permits to ignore errors on sync. In this
  case, luet exiting always with zero.

### 2. Subsets

The *subsets* is the feature available in `luet` that permits to filter the
file to install from a binary. This permits to choice a runtime what files
will be installed and what not.

The subsets's rules could be defined with multple strings regexes.

The definition of the *subsets* could be defined directly on the
package specs in the *definition.yaml* file or at runtime through
subsets definition files.

The packages generate from Funtoo are with two subsets rules directly
from the *definition.yaml*:

```yaml
annotations:
  subsets:
    rules:
      devel:
      - ^/usr/include/
      portage:
      - ^/var/db/pkg/
```

with the *subsets* `devel` and `portage`.

The default directory where to define subsets's definitions is
`/etc/luet/subsets.def.d` but could be modified by the
luet configuration option `subsets_defdir` in the `luet.yaml`
file:

```yaml
subsets_defdir:
- /etc/luet/subsets.def.d
```

The definition of subsets under the */etc/luet/subsets.def.d* doesn't
use the same format of the `annotations`. The key of the map describe
the name of the subset that is also defined in the `name` attribute.
The specified rules could be applied in this order:

1. rules defined inside the package definition

2. rules defined by a local definition for the category of the package.
   These rules can be used to override the package definition.

3. rules defined by a local definition for the package

NOTE: When is present a rule for the package the categories rules are
      ignored.

At the moment there isn't a wildcard key to use for every package, so
to define a specific rule for every package you need to define all the
possible categories.

The logic applied from `luet` with the subsets rules works in reverse,
when are defined the rules, these rules are configured, thanks to the
`tar-formers` library as ignore rules when the subset mapped to the rules
is not enabled.

To clarify the behavior I sharing an example. In Sabayon the `gcc`
package was split into the `sys-devel/base-gcc` package and `sys-deve/gcc`
to permit to have the core libraries linked to a lot of packages that
are compiled with the GCC package without the need to have the compiler too.

Thanks to the subsets, instead of split the package a way to reach
the same result is to define a subset definition like this:

```bash
$> echo "
subsets_def:
    gcc-devel:
      description: \"Split gcc compiler stuff\"
      name: \"gcc-devel\"
      rules:
      - ^/usr/x86_64-pc-linux-gnu/gcc-bin/9.2.0/
      - ^/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/plugin/include/
      - ^/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/include/
      - ^/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/finclude/omp*
      - ^/usr/share/gcc-data/x86_64-pc-linux-gnu/9.2.0/
      - ^/usr/libexec/gcc/x86_64-pc-linux-gnu/9.2.0
      - ^/usr/bin/
      packages:
      - sys-devel-9.2.0/gcc
" > /etc/luet/subsets.def.d/00-gcc.yaml
```

With this definition, `luet` will install all files that don't match
with the rules defined when the subsets `gcc-devel` is not enabled.
In the example, the definition is strictly mapped to the package
`sys-devel-9.2.0/gcc`.

Normally, the `gcc` package is installed by default because it's
a require of a lot of packages. This means that if the definition
is added later to be applied must reinstalled the package.

To do this job the better solution is to use the low-level command
`luet miner reinstall-package`:

```bash
$> luet miner ri sys-devel-9.2.0/gcc
```

The list of the subsets enabled could be configured in two ways.
On configuring the list of the subsets in the configuration file
`luet.yaml`:

```yaml
subsets:
  enabled:
    - portage
    - devel
subsets_confdir:
  - /etc/luet/subsets.conf.d

```

or through specific files under the directories defined in
the attribute `subsets_confdir`.

The files under the directory `/etc/luet/subsets.conf.d` are in
the format:

```yaml
enabled:
    - gcc-devel
```

At the moment, `luet` doesn't supply commands to iterate with
*subsets definition* but new commands are in our backlog.

#### 2.1. Subsets list

This command permits to show the list of subsets enabled.

```
$ luet subsets list --help
List of subsets enabled.

Usage:
  luet subsets list [OPTIONS] [flags]

Flags:
  -h, --help    help for list
  -q, --quiet   Show only name of the repositories.
```

In particular, the description of the subsets `devel` and `portage`
are visible by default also if the definition is not present.

```bash
$> luet subsets list
🍨 Subsets enabled:
 * portage
   Portage metadata and files.

 * devel
   Includes and devel files. Needed for compilation.
```

* `--quiet`: show only the name of the subset enabled.

#### 2.2. Enable one or more subsets

This command permits to enable one or more subsets.

```
$> luet subsets enable --help
Enable one or more subsets as subsets config file.

	$> luet subsets enable devel portage mysubset

	$> luet subsets enable -f my devel portage mysubset

The filename is used to write/update the file under the first
directory defined on subsets_confdir option (for example /etc/luet/subsets.conf.d/my.yml else main.yml is used).

Usage:
  luet subsets enable [OPTIONS] <subset1> ... <subsetN> [flags]

Flags:
  -f, --file string   Define the filename without extension where enable the subsets.
  -h, --help          help for enable

```

By default this command add the *subsets* to the *main.yml* or to
the file defined by the `-f` option:

```bash
$> luet subsets enable gcc-devel
Subsets gcc-devel enabled ✔ .
```

That generates this content:

```bash
$> cat /etc/luet/subsets.conf.d/main.yml 
enabled:
    - gcc-devel
```

Instead to enable the `gcc-devel` subset under the *gcc.yml* file:

```bash
$> luet subsets enable -f gcc gcc-devel
Subsets gcc-devel enabled ✔ .
```

With this output:

```bash
$> cat /etc/luet/subsets.conf.d/gcc.yml
enabled:
    - gcc-devel
```

#### 2.3. Disable one or more subsets

This command permits to disable one or more subsets.

```
$> luet subsets disable --help
Disable one or more subsets as subsets config file.

	$> luet subsets disable devel portage mysubset

	$> luet subsets disable -f my devel portage mysubset

The filename is used to write/update the file under the first
directory defined on subsets_confdir option (for example
/etc/luet/subsets.conf.d/my.yml else main.yml is used).

Usage:
  luet subsets disable [OPTIONS] <subset1> ... <subsetN> [flags]

Flags:
  -f, --file string   Define the filename without extension where enable the subsets.
  -h, --help          help for disable
```

### 3. Search packages

This command permits to search packages available in the configured
repositories or between installed packages.

```
$ luet s --help
Search for installed and available packages
		
	To search a package in the repositories:

		$ luet search <regex1> ... <regexN>

	To search a package and display results in a table (wide screens):

		$ luet search --table <regex>

	To look into the installed packages:

		$ luet search --installed <regex>

	Note: the regex argument is optional, if omitted implies "all"

	To search a package by label:

		$ luet search --label <label1>,<label2>...,<labelN>

	or by regex against the label:

		$ luet search --rlabel <regex-label1>,..,<regex-labelN>

	or by categories:

		$ luet search --category <cat1>,..,<catN>

	or by names:

		$ luet search --name|-n <name1>,..,<nameN>

	or by annotations:

		$ luet search --annotation <annotation1>,..,<annotationN>

	or by package (used only category and package name for name in the format cat/foo)

		$ luet search -p <cat/foo>,<cat/foo2>

	Search can also return results in the terminal in different ways: as terminal output, as json or as yaml.

		$ luet search -o json <regex> # JSON output
		$ luet search -o yaml <regex> # YAML output

Usage:
  luet search <term> [flags]

Aliases:
  search, s

Flags:
  -a, --annotation strings     Search packages through one or more annotations.
      --category strings       Search packages through one or more categories regex.
      --condition-or           The searching options are managed in OR between the searching types.
      --files                  Show package files on YAML/JSON output.
      --full                   Show full informations.
  -h, --help                   help for search
      --hidden                 Include hidden packages
      --ignore-masks           Ignore packages masked.
      --installed              Search between system packages
      --label strings          Search packages through one or more labels.
  -n, --name strings           Search packages matching the package name string.
  -o, --output string          Output format ( Defaults: terminal, available: json,yaml ) (default "terminal")
  -p, --package strings        Search packages matching the package string cat/name.
      --quiet                  show output as list without version
      --rlabel strings         Search packages through one or more labels regex.
      --system-dbpath string   System db path
      --system-engine string   System DB engine
      --system-target string   System rootpath
      --table                  show output in a table (wider screens)
      --with-rootfs-prefix     Add prefix of the configured rootfs path. (default true)

```

### 4. Install packages

This command permits to install packages from the configured repositories.

```
$  luet i --help
Installs one or more packages without asking questions:

	$ luet install -y utils/busybox utils/yq ...
	
To install only deps of a package:
	
	$ luet install --onlydeps utils/busybox ...
	
To not install deps of a package:
	
	$ luet install --nodeps utils/busybox ...

To force install a package:
	
	$ luet install --force utils/busybox ...

Usage:
  luet install <pkg1> <pkg2> ... [flags]

Aliases:
  install, i

Flags:
      --download-only                  Download only
      --finalizer-env stringArray      Set finalizer environment in the format key=value.
      --force                          Skip errors and keep going (potentially harmful)
  -h, --help                           help for install
      --ignore-conflicts               Don't consider package conflicts (harmful!)
      --ignore-masks                   Ignore packages masked.
      --nodeps                         Don't consider package dependencies (harmful!)
      --overwrite-existing-dir-perms   Overwrite exiting directories permissions.
      --preserve-system-essentials     Preserve system luet files (default true)
  -p, --pretend                        simply display what *would* have been installed if --pretend weren't used
      --show-install-order             In additional of the package to install, show the installation order and exit.
      --skip-check-system              Skip conflicts check with existing rootfs.
      --skip-finalizers                Skip the execution of the finalizers.
      --sync-repos                     Sync repositories before install. Note: If there are in memory repositories then the sync is done always.
  -y, --yes                            Don't ask questions

```

#### 4.1. Show packages candidates to install

This command permit to see what packages are candidates for the selected packages to install.

In particular, the option `--pretend|-p` shows the list of the packages selected from the solver
to install in alphabetic order.

```bash
$> luet i xdg-utils --pretend
🚀 Luet 0.35.4-geaaru-g3fcfc36cea5636d539d55117b8befc07e0812083 2023-04-04 09:46:02 UTC - go1.20.2
🏠 Repository:              geaaru-repo-index Revision:   5 - 2023-03-18 10:12:28 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision: 137 - 2023-03-19 11:49:39 +0000 UTC
🏠 Repository:             macaroni-eagle-dev Revision: 480 - 2023-04-13 01:14:59 +0000 UTC
🏠 Repository:                  mottainai-dev Revision:  88 - 2023-04-21 16:15:48 +0000 UTC
🧠 Solving install tree...
🍦 [  1 of  36] [N] dev-libs-2/glib::macaroni-eagle-dev                           - 2.70.0
🍦 [  2 of  36] [N] dev-libs/libpthread-stubs::macaroni-eagle-dev                 - 0.4
🍦 [  3 of  36] [N] dev-perl/File-BaseDir::macaroni-eagle-dev                     - 0.70.0
🍦 [  4 of  36] [N] dev-perl/File-DesktopEntry::macaroni-eagle-dev                - 0.220.0
🍦 [  5 of  36] [N] dev-perl/File-MimeInfo::macaroni-eagle-dev                    - 0.280.0
🍦 [  6 of  36] [N] dev-perl/IPC-System-Simple::macaroni-eagle-dev                - 1.250.0
🍦 [  7 of  36] [N] dev-perl/URI::macaroni-eagle-dev                              - 1.730.0
🍦 [  8 of  36] [N] dev-util/desktop-file-utils::macaroni-eagle-dev               - 0.23
🍦 [  9 of  36] [N] dev-util/gdbus-codegen::macaroni-eagle-dev                    - 2.70.0
🍦 [ 10 of  36] [N] virtual/libelf::macaroni-eagle-dev                            - 3
🍦 [ 11 of  36] [N] virtual/perl-Carp::macaroni-eagle-dev                         - 1.500.0
🍦 [ 12 of  36] [N] virtual/perl-Data-Dumper::macaroni-eagle-dev                  - 2.174.0
🍦 [ 13 of  36] [N] virtual/perl-Encode::macaroni-eagle-dev                       - 3.60.0
🍦 [ 14 of  36] [N] virtual/perl-Exporter::macaroni-eagle-dev                     - 5.740.0
🍦 [ 15 of  36] [N] virtual/perl-File-Path::macaroni-eagle-dev                    - 2.160.0
🍦 [ 16 of  36] [N] virtual/perl-File-Spec::macaroni-eagle-dev                    - 3.780.0
🍦 [ 17 of  36] [N] virtual/perl-MIME-Base64::macaroni-eagle-dev                  - 3.150.0
🍦 [ 18 of  36] [N] virtual/perl-Scalar-List-Utils::macaroni-eagle-dev            - 1.550.0
🍦 [ 19 of  36] [N] virtual/perl-libnet::macaroni-eagle-dev                       - 3.110.0
🍦 [ 20 of  36] [N] virtual/perl-parent::macaroni-eagle-dev                       - 0.238.0
🍦 [ 21 of  36] [N] x11-apps/xprop::macaroni-eagle-dev                            - 1.2.4
🍦 [ 22 of  36] [N] x11-apps/xset::macaroni-eagle-dev                             - 1.2.4
🍦 [ 23 of  36] [N] x11-base/xorg-proto::macaroni-eagle-dev                       - 2019.2
🍦 [ 24 of  36] [N] x11-libs/libICE::macaroni-eagle-dev                           - 1.0.10
🍦 [ 25 of  36] [N] x11-libs/libSM::macaroni-eagle-dev                            - 1.2.3
🍦 [ 26 of  36] [N] x11-libs/libX11::macaroni-eagle-dev                           - 1.8.2
🍦 [ 27 of  36] [N] x11-libs/libXau::macaroni-eagle-dev                           - 1.0.9
🍦 [ 28 of  36] [N] x11-libs/libXdmcp::macaroni-eagle-dev                         - 1.1.3
🍦 [ 29 of  36] [N] x11-libs/libXext::macaroni-eagle-dev                          - 1.3.4
🍦 [ 30 of  36] [N] x11-libs/libXmu::macaroni-eagle-dev                           - 1.1.3
🍦 [ 31 of  36] [N] x11-libs/libXt::macaroni-eagle-dev                            - 1.2.0
🍦 [ 32 of  36] [N] x11-libs/libxcb::macaroni-eagle-dev                           - 1.14+1
🍦 [ 33 of  36] [N] x11-libs/xtrans::macaroni-eagle-dev                           - 1.4.0
🍦 [ 34 of  36] [N] x11-misc/compose-tables::macaroni-eagle-dev                   - 1.8.1
🍦 [ 35 of  36] [N] x11-misc/shared-mime-info::macaroni-eagle-dev                 - 1.10
🍦 [ 36 of  36] [N] x11-misc/xdg-utils::macaroni-eagle-dev                        - 1.1.3
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 5966 µs).
🎊 All done.
```

Usually, it's better to see the packages in alphabetic order, this help research
and pre-install checks.

There are use cases, that could help to see what will be the install order, for
example, to validate the solver. In this case, it's possible to use the option
`--show-install-order` that will share the order of the operations after the download of
the packages.

```bash
# luet i xdg-utils --show-install-order 
🚀 Luet 0.35.4-geaaru-g3fcfc36cea5636d539d55117b8befc07e0812083 2023-04-04 09:46:02 UTC - go1.20.2
🏠 Repository:              geaaru-repo-index Revision:   5 - 2023-03-18 10:12:28 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision: 137 - 2023-03-19 11:49:39 +0000 UTC
🏠 Repository:             macaroni-eagle-dev Revision: 480 - 2023-04-13 01:14:59 +0000 UTC
🏠 Repository:                  mottainai-dev Revision:  88 - 2023-04-21 16:15:48 +0000 UTC
🧠 Solving install tree...
🍦 [  1 of  36] [N] dev-libs-2/glib::macaroni-eagle-dev                           - 2.70.0
🍦 [  2 of  36] [N] dev-libs/libpthread-stubs::macaroni-eagle-dev                 - 0.4
🍦 [  3 of  36] [N] dev-perl/File-BaseDir::macaroni-eagle-dev                     - 0.70.0
🍦 [  4 of  36] [N] dev-perl/File-DesktopEntry::macaroni-eagle-dev                - 0.220.0
🍦 [  5 of  36] [N] dev-perl/File-MimeInfo::macaroni-eagle-dev                    - 0.280.0
🍦 [  6 of  36] [N] dev-perl/IPC-System-Simple::macaroni-eagle-dev                - 1.250.0
🍦 [  7 of  36] [N] dev-perl/URI::macaroni-eagle-dev                              - 1.730.0
🍦 [  8 of  36] [N] dev-util/desktop-file-utils::macaroni-eagle-dev               - 0.23
🍦 [  9 of  36] [N] dev-util/gdbus-codegen::macaroni-eagle-dev                    - 2.70.0
🍦 [ 10 of  36] [N] virtual/libelf::macaroni-eagle-dev                            - 3
🍦 [ 11 of  36] [N] virtual/perl-Carp::macaroni-eagle-dev                         - 1.500.0
🍦 [ 12 of  36] [N] virtual/perl-Data-Dumper::macaroni-eagle-dev                  - 2.174.0
🍦 [ 13 of  36] [N] virtual/perl-Encode::macaroni-eagle-dev                       - 3.60.0
🍦 [ 14 of  36] [N] virtual/perl-Exporter::macaroni-eagle-dev                     - 5.740.0
🍦 [ 15 of  36] [N] virtual/perl-File-Path::macaroni-eagle-dev                    - 2.160.0
🍦 [ 16 of  36] [N] virtual/perl-File-Spec::macaroni-eagle-dev                    - 3.780.0
🍦 [ 17 of  36] [N] virtual/perl-MIME-Base64::macaroni-eagle-dev                  - 3.150.0
🍦 [ 18 of  36] [N] virtual/perl-Scalar-List-Utils::macaroni-eagle-dev            - 1.550.0
🍦 [ 19 of  36] [N] virtual/perl-libnet::macaroni-eagle-dev                       - 3.110.0
🍦 [ 20 of  36] [N] virtual/perl-parent::macaroni-eagle-dev                       - 0.238.0
🍦 [ 21 of  36] [N] x11-apps/xprop::macaroni-eagle-dev                            - 1.2.4
🍦 [ 22 of  36] [N] x11-apps/xset::macaroni-eagle-dev                             - 1.2.4
🍦 [ 23 of  36] [N] x11-base/xorg-proto::macaroni-eagle-dev                       - 2019.2
🍦 [ 24 of  36] [N] x11-libs/libICE::macaroni-eagle-dev                           - 1.0.10
🍦 [ 25 of  36] [N] x11-libs/libSM::macaroni-eagle-dev                            - 1.2.3
🍦 [ 26 of  36] [N] x11-libs/libX11::macaroni-eagle-dev                           - 1.8.2
🍦 [ 27 of  36] [N] x11-libs/libXau::macaroni-eagle-dev                           - 1.0.9
🍦 [ 28 of  36] [N] x11-libs/libXdmcp::macaroni-eagle-dev                         - 1.1.3
🍦 [ 29 of  36] [N] x11-libs/libXext::macaroni-eagle-dev                          - 1.3.4
🍦 [ 30 of  36] [N] x11-libs/libXmu::macaroni-eagle-dev                           - 1.1.3
🍦 [ 31 of  36] [N] x11-libs/libXt::macaroni-eagle-dev                            - 1.2.0
🍦 [ 32 of  36] [N] x11-libs/libxcb::macaroni-eagle-dev                           - 1.14+1
🍦 [ 33 of  36] [N] x11-libs/xtrans::macaroni-eagle-dev                           - 1.4.0
🍦 [ 34 of  36] [N] x11-misc/compose-tables::macaroni-eagle-dev                   - 1.8.1
🍦 [ 35 of  36] [N] x11-misc/shared-mime-info::macaroni-eagle-dev                 - 1.10
🍦 [ 36 of  36] [N] x11-misc/xdg-utils::macaroni-eagle-dev                        - 1.1.3
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 6343 µs).
🚚 Downloading 36 packages...
📦 [  1 of  36] x11-misc/xdg-utils::macaroni-eagle-dev                            - 1.1.3           # downloaded ✔
📦 [  2 of  36] x11-libs/libX11::macaroni-eagle-dev                               - 1.8.2           # downloaded ✔
📦 [  3 of  36] x11-libs/xtrans::macaroni-eagle-dev                               - 1.4.0           # downloaded ✔
📦 [  4 of  36] x11-libs/libSM::macaroni-eagle-dev                                - 1.2.3           # downloaded ✔
📦 [  5 of  36] x11-libs/libXt::macaroni-eagle-dev                                - 1.2.0           # downloaded ✔
📦 [  6 of  36] x11-base/xorg-proto::macaroni-eagle-dev                           - 2019.2          # downloaded ✔
📦 [  7 of  36] virtual/perl-Scalar-List-Utils::macaroni-eagle-dev                - 1.550.0         # downloaded ✔
📦 [  8 of  36] virtual/perl-MIME-Base64::macaroni-eagle-dev                      - 3.150.0         # downloaded ✔
📦 [  9 of  36] x11-misc/shared-mime-info::macaroni-eagle-dev                     - 1.10            # downloaded ✔
📦 [ 10 of  36] dev-util/desktop-file-utils::macaroni-eagle-dev                   - 0.23            # downloaded ✔
📦 [ 11 of  36] virtual/perl-Carp::macaroni-eagle-dev                             - 1.500.0         # downloaded ✔
📦 [ 12 of  36] dev-perl/File-BaseDir::macaroni-eagle-dev                         - 0.70.0          # downloaded ✔
📦 [ 13 of  36] virtual/perl-Encode::macaroni-eagle-dev                           - 3.60.0          # downloaded ✔
📦 [ 14 of  36] x11-libs/libXmu::macaroni-eagle-dev                               - 1.1.3           # downloaded ✔
📦 [ 15 of  36] x11-apps/xset::macaroni-eagle-dev                                 - 1.2.4           # downloaded ✔
📦 [ 16 of  36] virtual/perl-Data-Dumper::macaroni-eagle-dev                      - 2.174.0         # downloaded ✔
📦 [ 17 of  36] dev-perl/File-MimeInfo::macaroni-eagle-dev                        - 0.280.0         # downloaded ✔
📦 [ 18 of  36] x11-libs/libXau::macaroni-eagle-dev                               - 1.0.9           # downloaded ✔
📦 [ 19 of  36] x11-libs/libXext::macaroni-eagle-dev                              - 1.3.4           # downloaded ✔
📦 [ 20 of  36] dev-util/gdbus-codegen::macaroni-eagle-dev                        - 2.70.0          # downloaded ✔
📦 [ 21 of  36] dev-libs/libpthread-stubs::macaroni-eagle-dev                     - 0.4             # downloaded ✔
📦 [ 22 of  36] x11-libs/libxcb::macaroni-eagle-dev                               - 1.14+1          # downloaded ✔
📦 [ 23 of  36] virtual/perl-File-Spec::macaroni-eagle-dev                        - 3.780.0         # downloaded ✔
📦 [ 24 of  36] dev-perl/URI::macaroni-eagle-dev                                  - 1.730.0         # downloaded ✔
📦 [ 25 of  36] virtual/perl-File-Path::macaroni-eagle-dev                        - 2.160.0         # downloaded ✔
📦 [ 26 of  36] dev-perl/File-DesktopEntry::macaroni-eagle-dev                    - 0.220.0         # downloaded ✔
📦 [ 27 of  36] dev-perl/IPC-System-Simple::macaroni-eagle-dev                    - 1.250.0         # downloaded ✔
📦 [ 28 of  36] x11-libs/libXdmcp::macaroni-eagle-dev                             - 1.1.3           # downloaded ✔
📦 [ 29 of  36] x11-libs/libICE::macaroni-eagle-dev                               - 1.0.10          # downloaded ✔
📦 [ 30 of  36] x11-apps/xprop::macaroni-eagle-dev                                - 1.2.4           # downloaded ✔
📦 [ 31 of  36] virtual/perl-libnet::macaroni-eagle-dev                           - 3.110.0         # downloaded ✔
📦 [ 32 of  36] virtual/perl-parent::macaroni-eagle-dev                           - 0.238.0         # downloaded ✔
📦 [ 33 of  36] virtual/libelf::macaroni-eagle-dev                                - 3               # downloaded ✔
📦 [ 34 of  36] dev-libs-2/glib::macaroni-eagle-dev                               - 2.70.0          # downloaded ✔
📦 [ 35 of  36] virtual/perl-Exporter::macaroni-eagle-dev                         - 5.740.0         # downloaded ✔
📦 [ 36 of  36] x11-misc/compose-tables::macaroni-eagle-dev                       - 1.8.1           # downloaded ✔
🧠 Sorting 36 packages operations...
🧠 Install order:
🍦 [  1 of  36] [N] dev-libs/libpthread-stubs::macaroni-eagle-dev                 - 0.4
🍦 [  2 of  36] [N] dev-util/gdbus-codegen::macaroni-eagle-dev                    - 2.70.0
🍦 [  3 of  36] [N] virtual/libelf::macaroni-eagle-dev                            - 3
🍦 [  4 of  36] [N] virtual/perl-Carp::macaroni-eagle-dev                         - 1.500.0
🍦 [  5 of  36] [N] virtual/perl-Data-Dumper::macaroni-eagle-dev                  - 2.174.0
🍦 [  6 of  36] [N] virtual/perl-Encode::macaroni-eagle-dev                       - 3.60.0
🍦 [  7 of  36] [N] virtual/perl-Exporter::macaroni-eagle-dev                     - 5.740.0
🍦 [  8 of  36] [N] virtual/perl-File-Path::macaroni-eagle-dev                    - 2.160.0
🍦 [  9 of  36] [N] virtual/perl-File-Spec::macaroni-eagle-dev                    - 3.780.0
🍦 [ 10 of  36] [N] virtual/perl-MIME-Base64::macaroni-eagle-dev                  - 3.150.0
🍦 [ 11 of  36] [N] virtual/perl-Scalar-List-Utils::macaroni-eagle-dev            - 1.550.0
🍦 [ 12 of  36] [N] virtual/perl-libnet::macaroni-eagle-dev                       - 3.110.0
🍦 [ 13 of  36] [N] virtual/perl-parent::macaroni-eagle-dev                       - 0.238.0
🍦 [ 14 of  36] [N] x11-base/xorg-proto::macaroni-eagle-dev                       - 2019.2
🍦 [ 15 of  36] [N] x11-libs/xtrans::macaroni-eagle-dev                           - 1.4.0
🍦 [ 16 of  36] [N] x11-misc/compose-tables::macaroni-eagle-dev                   - 1.8.1
🍦 [ 17 of  36] [N] x11-libs/libXau::macaroni-eagle-dev                           - 1.0.9
🍦 [ 18 of  36] [N] x11-libs/libXdmcp::macaroni-eagle-dev                         - 1.1.3
🍦 [ 19 of  36] [N] dev-libs-2/glib::macaroni-eagle-dev                           - 2.70.0
🍦 [ 20 of  36] [N] x11-misc/shared-mime-info::macaroni-eagle-dev                 - 1.10
🍦 [ 21 of  36] [N] dev-util/desktop-file-utils::macaroni-eagle-dev               - 0.23
🍦 [ 22 of  36] [N] x11-libs/libICE::macaroni-eagle-dev                           - 1.0.10
🍦 [ 23 of  36] [N] x11-libs/libSM::macaroni-eagle-dev                            - 1.2.3
🍦 [ 24 of  36] [N] dev-perl/IPC-System-Simple::macaroni-eagle-dev                - 1.250.0
🍦 [ 25 of  36] [N] dev-perl/File-BaseDir::macaroni-eagle-dev                     - 0.70.0
🍦 [ 26 of  36] [N] x11-libs/libxcb::macaroni-eagle-dev                           - 1.14+1
🍦 [ 27 of  36] [N] x11-libs/libX11::macaroni-eagle-dev                           - 1.8.2
🍦 [ 28 of  36] [N] dev-perl/URI::macaroni-eagle-dev                              - 1.730.0
🍦 [ 29 of  36] [N] x11-libs/libXt::macaroni-eagle-dev                            - 1.2.0
🍦 [ 30 of  36] [N] dev-perl/File-DesktopEntry::macaroni-eagle-dev                - 0.220.0
🍦 [ 31 of  36] [N] x11-apps/xprop::macaroni-eagle-dev                            - 1.2.4
🍦 [ 32 of  36] [N] x11-libs/libXext::macaroni-eagle-dev                          - 1.3.4
🍦 [ 33 of  36] [N] x11-libs/libXmu::macaroni-eagle-dev                           - 1.1.3
🍦 [ 34 of  36] [N] x11-apps/xset::macaroni-eagle-dev                             - 1.2.4
🍦 [ 35 of  36] [N] dev-perl/File-MimeInfo::macaroni-eagle-dev                    - 0.280.0
🍦 [ 36 of  36] [N] x11-misc/xdg-utils::macaroni-eagle-dev                        - 1.1.3
🎊 All done.
```

### 5. Cleanup local cache

The tree of the installed repositories installed under the
directory `/var/cache/luet/repos` are not mandatory when the
user had installed the packages.

Through the `cleanup` command it's possible clean the cache
of the downloaded files:

```bash
$> luet cleanup
Cleaned:  36 packages.
```

and to clean all the repositories under the directory
`/var/cache/luet/repos` with:

```bash
$> luet cleanup --purge-repos
Cleaned:  0 packages.
Repos Cleaned:  17
```

### 6. Uninstall packages

The command `uninstall` or `rm` permits to uninstall installed packages.

```
$> luet uninstall --help

Remove one or more package and his dependencies recursively

	$ luet uninstall cat/foo1 ... cat/foo2

Remove one or more packages without dependencies

	$ luet uninstall cat/foo1 ... --nodeps

Remove one or more packages and skip errors

	$ luet uninstall cat/foo1 ... --force

Remove one or more packages without ask confirm

	$ luet uninstall cat/foo1 ... --yes

Remove one or more packages without ask confirm and skip execution
of the finalizers.

	$ luet uninstall cat/foo1 ... --yes --skip-finalizers

Usage:
  luet uninstall <pkg> <pkg2> ... [flags]

Aliases:
  uninstall, rm, un

Flags:
      --finalizer-env stringArray    Set finalizer environment in the format key=value.
      --force                        Force uninstall
  -h, --help                         help for uninstall
  -k, --keep-protected-files         Keep package protected files around
      --nodeps                       Don't consider package dependencies (harmful! overrides checkconflicts and full!)
      --preserve-system-essentials   Preserve system luet files (default true)
      --skip-finalizers              Skip the execution of the finalizers.
  -y, --yes                          Don't ask questions
```

By default the selected packages are removed with all packages that depend on
the candidates in reverse order. To avoid the dependencies could be used the
`--nodeps` option.

* `--yes|-y`: skip the confirm phase.

* `--force`: ignore errors and for uninstall of the selected packages.

* `--keep-protected-files|-k`: keep the protected files.

* `--nodeps`: ignore dependencies on uninstall selected packages.

* `--finalizer-env <key=value>`: define one or more environment variables to use on finalizer

### 7. Upgrade the system

The upgrade of the existing system is possible through the `upgrade`
command.

```bash
$> luet upgrade
🚀 Luet 0.35.4-geaaru-g3fcfc36cea5636d539d55117b8befc07e0812083 2023-04-04 09:46:02 UTC - go1.20.2
🏠 Repository:              geaaru-repo-index Revision:   5 - 2023-03-18 10:12:28 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision: 137 - 2023-03-19 11:49:39 +0000 UTC
🏠 Repository:             macaroni-eagle-dev Revision: 480 - 2023-04-13 01:14:59 +0000 UTC
🏠 Repository:                  mottainai-dev Revision:  88 - 2023-04-21 16:15:48 +0000 UTC
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍬 [  1 of   1] [U] system/luet-geaaru-testing::mottainai-dev                     - 0.35.5 [0.35.4::mottainai-stable]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 40018 µs).
Do you want to continue with this operation? [y/N]: 
```

* `--show-upgrade-order`: Show the order of the packages to upgrade

* `--sync-repos`: On upgrade the system, sync the repository before execute
  the solver.

* `--yes|y`: Skip the confirm question

* `--ignore-masks`: Ignores the masks

* `--ignore-conflicts`: Ignore the conflicts

* `--pretend`: Show the candidates for the upgrade

* `--show-upgrade-order`: Show the order of the packages to upgrade

* `--skip-finalizers`: Skip finalizers

* `--force`: Ignore errors and force installation of all candidates packages.

* `--download-only`: Download only the packages candidates.

```bash
$> luet upgrade --show-upgrade-order
🚀 Luet 0.35.4-geaaru-g3fcfc36cea5636d539d55117b8befc07e0812083 2023-04-04 09:46:02 UTC - go1.20.2
🏠 Repository:              geaaru-repo-index Revision:   5 - 2023-03-18 10:12:28 +0000 UTC
🏠 Repository:       macaroni-commons-testing Revision: 137 - 2023-03-19 11:49:39 +0000 UTC
🏠 Repository:             macaroni-eagle-dev Revision: 480 - 2023-04-13 01:14:59 +0000 UTC
🏠 Repository:                  mottainai-dev Revision:  88 - 2023-04-21 16:15:48 +0000 UTC
🤔 Computing upgrade, please hang tight... 💤 
🎉 Upgrades:
🍬 [  1 of   1] [U] system/luet-geaaru-testing::mottainai-dev                     - 0.35.5 [0.35.4::mottainai-stable]
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 107 µs).
🚚 Downloading 1 packages...
📦 [  1 of   1] system/luet-geaaru-testing::mottainai-dev                         - 0.35.5          # downloaded ✔
🧠 Sorting 2 packages operations...
🧠 Upgrade order:
🍬 [  1 of   1] [U] system/luet-geaaru-testing::mottainai-dev                     - 0.35.5 [0.35.4::mottainai-stable]
```


### 8. Show luet configuration

The command `config` permits to see the configuration parameters active
in `luet`.

```
# luet config --help
Show luet configuration

Usage:
  luet config [flags]

Aliases:
  config, c

Flags:
  -h, --help   help for config
```

### 9. Queries tools

`luet` supplies different commands to analyze the repositories and the
installed packages.

```
# luet query --help
Repository query tools.

Usage:
  luet query [command]

Aliases:
  query, q

Available Commands:
  belongs     Resolve what package a file belongs to.
  files       Show files owned by a specific package.
  orphans     Show orphans packages.

Flags:
  -h, --help   help for query
```

#### 9.1. Show files owned by a specific package

This command permits to show the files owned by a specific package.

```
$> luet q files --help
Show files owned by a specific package.

Usage:
  luet query files <pkg1> ... <pkgN> [OPTIONS] [flags]

Aliases:
  files, fi, f

Flags:
  -h, --help                 help for files
      --installed            Search between system packages
  -o, --output string        Output format ( Defaults: terminal, available: json,yaml ) (default "terminal")
      --with-rootfs-prefix   Add prefix of the configured rootfs path. (default true)
```

It's possible to see the list of files in JSON or YAML format:

```bash
$> luet q files lxd-compose -o json
["/usr/bin/lxd-compose"]
```

#### 9.2. Resolve what package a file belongs to

This command permits to search the packages that contains the file specified.

```
$> luet q belongs  --help
Resolve what package a file belongs to.

Usage:
  luet query belongs <file1> ... <fileN> [OPTIONS] [flags]

Aliases:
  belongs, be, b

Flags:
  -h, --help            help for belongs
      --installed       Search between system packages
  -o, --output string   Output format ( Defaults: terminal, available: json,yaml ) (default "terminal")
      --quiet           show output as list without version
      --table           show output in a table (wider screens)
```

* `--quiet`: show the list of the packages without the version

* `--output|-o string`: show the package list in JSON, or YAML format. Default as string.

* `--installed`: search only between the installed packages. It uses the local database.

```bash
$> luet q belongs /usr/bin/lxd-compose
app-emulation/lxd-compose-0.27.0

$> luet q belongs  /usr/bin/lxd-compose --quiet
app-emulation/lxd-compose

$> luet q belongs /usr/bin/lxd-compose --installed
app-emulation/lxd-compose-0.27.0
```

#### 9.3. Show orphans packages

On upgrading a system or on remove a custom repository it's possible that
some packages will be no more available.

In this use case having a way to retrieve the list of orphan packages is
helpful.

This operation could require a lot of time.

NOTE: It's important executing this command when there aren't packages
      to upgrade. So, after executing `luet upgrade`.

```
$> luet q orphans --help
An orphan package is a package that is no more
available in the configured and/or enabled repositories.

This operation could require a bit of time.

Usage:
  luet query orphans [OPTIONS] [flags]

Aliases:
  orphans, o

Flags:
  -h, --help            help for orphans
  -o, --output string   Output format ( Defaults: terminal, available: json,yaml ) (default "terminal")
      --quiet           show output as list without version
      --verbose         Show messages. (default true)
```

### 10. Local Database Operations

There are different commands to operate on local database.

#### 10.1. Reindex collections

On upgrade `luet` it's possible that is needed to update the indexes of
the local database.

```bash
$> luet  database reindex
```

#### 10.2. Get package data

Retrive metadata of a package installed in the YAML format.

```
$> luet  database get app-emulation/lxd-compose --help
Get a package in the system database in the YAML format:

		$ luet database get system/foo

To return also files:
		$ luet database get --files system/foo

Usage:
  luet database get <package> [flags]

Flags:
      --files   Show package files.
  -h, --help    help for get
```

* `--files`: Show also the package files.

An example:

```bash
$> luet database get app-emulation/lxd-compose --files
category: app-emulation
conflicts: []
description: Supply a way to deploy a complex environment to an LXD Cluster or LXD
  standalone installation
id: 467
labels:
  github.owner: lxd-compose
  github.repo: MottainaiCI
license: GPL-3.0
name: lxd-compose
repository: mottainai-stable
requires: []
uri:
- https://github.com/MottainaiCI/lxd-compose
version: 0.27.0

files:
- usr/bin/lxd-compose
```

#### 10.3. Remove an installed package from the database

This command is a low-level operation that normally must be not
used.

```
$> luet  database remove --help
Removes a package in the system database without actually uninstalling it:

		$ luet database remove foo/bar

This commands takes multiple packages as arguments and prunes their entries from the system database.

Usage:
  luet database remove [package1] [package2] ... [flags]

Flags:
      --force   Force uninstall
  -h, --help    help for remove
```

#### 10.4. Insert a package in the system database

It's a low-level command that permit to register a new
package in the system database.

This command is used by the `luet-portage-converter` tool
to sync the package installed with *emerge* to *luet* database.

```
 luet  database create --help
Inserts a package in the system database:

		$ luet database create foo.yaml

"luet database create" injects a package in the system database without actually installing it, use it with caution.
This commands takes multiple yaml input file representing package artifacts, that are usually generated while building packages.
The yaml must contain the package definition, and the file list at least.

For reference, inspect a "metadata.yaml" file generated while running "luet build"

Usage:
  luet database create <artifact_metadata1.yaml> <artifact_metadata1.yaml> [flags]

Flags:
  -h, --help   help for create
```




