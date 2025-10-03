---
title: "MARK Stack"
type: docs
---

# M.A.R.K. Stack or M.A.R.K. OS

The **M.A.R.K.** ( **M**acaroni **A**utomated **R**epositories **K**it ) *stack* could be see
like a source-based OS with a name that reference the technologies used for his building, 
the automation that wants introduce and an acronym that reference the Iron Man Armor.
The softwares change so fastly and to keep a system updates
begin very hard for a distro. In MARK starting from the idea used in Funtoo, we want
improve the automation and the pipeline of delivery of the packages in order to balance the
speed and the choice of upgrading particular services and/or packages.

So, the main keys of MARK are:

1. *automation*: to reduce the effort on updates packages and keep the system updates is one of
   the main target. Automatic updates obviously will not be always easy to manage and a
   maintenance activity will be always needed, but the first target is try to reduce this
   effort and have a way to automatically receive news about the new versions. To do this,
   we use the `mark-devkit` tool that permits to define YAML file used to autogen new ebuild
   based on templates and to manage the comparition of ebuilds without kits and/or overlay
   available through Git repositories. The updates could be sent through direct commits
   or through Github PR.

2. *dynamism*: one of the pros of Gentoo and Funtoo is the easy way to add patches to
   upstream sources, at the same way we want follow this pattern and try to share an OS
   that is a good place for developers.

3. *reproducibility*: share technologies, how to configure it and using Opensource is one
of the core and more important key of MARK OS. Without sharing the knowledge this world
will never grow. So, another important point a bit complex, for a lot of reason and just
for the volume of the documentation will be sharing our *Distro from Scratch* steps
used in MARK.

Now the we have described the main principles under this stack it's time to describe
how the magic is started and how will be improved.


After the Funtoo shutdown in August 2024, Macaroni OS thanks to the support of the ex-Funtoo
developers decides to start a new adventure to keep the system independent from other distro
in order to have a better control of the system and avoid that external changes could be
dangerous in the Macaroni OS itself. Obviously, starting from zero was not possible, and so,
based of the experience get in Funtoo we have applied the first changed to the *metatools*,
*ego* needed to create the base for what is been developed in one year and that will be evolved
again in the future. But having a clear target, trying to join the two worlds and create a gate
between the Anise/binary stack and the sourced-based world of MARK. But not only this, the
Portage itself it's a software created in Gentoo that will be replaced too in the future or at
least we hope on this. Working on our free time doesn't permit to share specific dates and/or
milestone so what we can share is at least the plan.

Through this vision we are been really lucky to find our Sponsors, really thanks always for their
support, and through them we also oriented the development of our tools to be more connected to
their technologies in order to share the better experience possible to our users.

For this reason, the `mark-devkit` tool that is the main (but not the only) module used to keep
the distfiles server updated is been developed to have a better integration with Object Store S3
exposed in **CDN77**.

Before enter in the details of our releases we want try to compare Gentoo, Funtoo and MARK
in order to help users from these distro to understand the differences:

## 🚀 MARK vs Gentoo vs Funtoo

| Feature              | **Gentoo**                                | **Funtoo**                              | **MARK**                                        |
|----------------------|--------------------------------------------|------------------------------------------|-------------------------------------------------------------|
| **Package management** | `emerge`                 | `emerge`                         | `emerge` and `anise` + `anise-portage-converter` |
| **Portage format** | Monolitic tree + external overlays | Kits with main release | Kits with different branches, different targets and different stability levels. |
| **Software distribution** | Pure source-based + xpak                       | Source-based with curated kits + xpak           | Source-based with curated kits + xpak and anise binary packages |
| **Profiles/config**  | Portage profiles (`eselect profile`)       | `ego` + mix-ins / arch / flavor                   | `ego` + mix-ins / arch / flavor (replaced with mark soon)                |
| **System updates**   | `emerge --sync && emerge -avuDU @world`    | `ego sync && emerge -avuDU @world`        | `ego sync && emerge -avuDU @world` or `anise upgrade --sync-repos` |
| **NVIDIA Drivers** | Single SLOT installation | Single SLOT installation | multi slotted autogen managed by `gpu-configurator` tool. |
| **initramfs generator** | genkernel | ramdisk | dracut |
| **Ebuild generator** | - | metatools | `mark-devkit autogen`, `mark-devkit kit merge`, `mark-devkit kit bump-release` |
| **Stage tarballs generator** | `catalyst` | `metro` | `mark-devkit metro` |
| **Stability level assurance** | single tree where using KEYWORDS and portage.mask | single tree fully autogen with KEYWORDS and portage.mask | multiple versions for every package, portage.mask and different branches with different stability levels |
| **Config files manager** | `etc-update` | `etc-update` | `macaronictl etc-update` |
| **Environment Settings manager** | `env-update` | `env-update` | `macaronictl env-update` |
| **Installer** | manual | manual | manual or calamares |


# 💂 Stability Levels

### 🐳 Container/Server releases

For support MARK releases containers and servers oriented don't require necessary tons
of packages for Desktop stuff, and following this idea we have created the release
`mark-xl` and `mark-v` with a subset of the packages. In addition, having less desktop
packages with a lot of constraints and cross dependencies between permit to simplify
the life of the solver, speedup the dependencies calculation and permit to experiment
new new libraries, compiler, etc. reducing issues with the upgrade for ABI change not
yet supported. So, this permits to experiment and move ahead packages on this releases
without the pain on broken desktop softwares that are updates with less periodicity.


<div style="text-align: center; margin-bottom: 30px">

<img src="../../images/mark/mark-containers-branches.png" width="930">

</div>

As visible from the schema, on `mark-unstable` the *mark-bot* automatically create
new PR for the packages with autogen specs (through `mark-devkit autogen` command).
But it's also possible receive PR directly from contributors and/or developers.
After a testing period the new versions pushed with other PRs to the `mark-xl` branch
could be merged and moved to testing environment.

The `mark-devkit kit bump-release` is used to update the JSON files of the
[meta-repo](https://github.com/macaroni-os/meta-repo) repository in the
branch related to the release that is later used by `ego` to fetch the Portage
tree split in kits. This behaviour is also a protection about errors done in the
kits that could be quickly reverted because until a new bump is done users will be
synced to the git hash of the last bump in the kit updated. Cons is that until a
new bump is done new updates will be not visible to users. Normally, an automatic
task run every day in our CD/CI that try to bump a new update the align the JSON
files to last commit of every kits.

The `mark-devkit kit clean` instead is used to generate PRs to remove versions
of the packages exceeded the max number of version admitted by the YAML specs.
Also in this case, the mark-bot task running for this is executed periodically
from our CD/CI chain.

So, the `mark-unstable` release is the *world of the chaos*. We can push PR to upgrade and
break everything. But better in an organized mode if it's possible. It's easy that this
branch will be often broken because is where we do experiment with new versions and releases
of the packages.

When a new package is been merged on `mark-unstable` the mark-bot checking for updates in
the `mark-xl` branch creates new PRs for the testing branch that could be leave there until
a testing phase is been done or just merged directly. If the mark-bot's task is executed
again and the PR for a specific package and version is already present, it just ignore
the upgrade because already in the queue for a validation.

Depending of the level of upgrade, for example for patch release version (I mean following
the semver paradigm) we could merge new versions with less attention because at the end
also `mark-xl` is a testing branch and it's possible that sometime a specific version could
be broken. In that case, the developers can choice to fix the issue or just create a PR that
revert the previous and waiting for a fix from mark-unstable.


At the end, after a testing period of the `mark-xl` branch, normally, this is also been with
the creation of the new versions over the Macaroni Terragon and Eagle releases that
automatically test the existing tree a manual task is fired over our CD/CI to execute
`mark-devkit kit merge` that doesn't use PR but just merge versions as a commits. Potentially,
could be used PRs also on mark-v but we prefer using directly commit because when the new
release is tagged through goreleaser tool we generate the ChangeLog automatically with the
list of the new versions available.

The upgrade of the core packages (GCC, Glibc, etc.) will be always done before in these
releases and later to the Desktop releases.

### 💻 Desktop releases

The Desktop Linux world is something complex with tons of packages that
are connected between them and is not easy planning specific upgrade without
break the tree. For this reason we prefer keep a separated tree for Desktop respect
the Container/Server and like describe before, it keeps a simple life for the solver with
less packages.

Having multiple releases take more effort but we think that could be a choice right
that permits to experiment in different way the upgrades.

For now, the only shared branch between the Desktop world and the Container/Server world
is `mark-unstable` that share a common place where define the autogen specifications and
later choice with `mark-devkit kit merge` of the upper branches what packages go where.
It's not excluded that in the future will not change.

The logic describes in the previous chapter are pretty equal for the Desktop world,
the difference is only that the testing branch of Desktop is `mark-iii` and the stable
tree of the Desktop is `mark-i`.


<div style="text-align: center; margin-bottom: 30px">

<img src="../../images/mark/mark-desktop-branches.png" width="930">

</div>

### 🔬 Embedded releases

Not ready yet for end users we have started in August 2025 the branch
`mark-31` with the target to support ARM/ARM64 arches. We consider it
*experimental* for now but when will be ready we will add testing and stable
branches too.

<div style="text-align: center; margin-bottom: 30px">

<img src="../../images/mark/mark-embedded-branches.png" width="930">

</div>

So, the `mark-31` branch could be considered like an unstable branch for embedded
that receive incoming PRs from `mark-unstable` too.

Our target is to supply in the near future SD images for these devices as starting point:

    - Raspberry PI4
    - Banana PI
    - Orange Pi
    - Pine64

Stay tuned!

## 📦 Portage

At the moment, Macaroni OS uses a forked version of Portage with original patches from Funtoo as main package
manager system in MARK but with an eye for improve integration with `anise` and the Macaroni binary
layer.

The Macaroni Portage fork follow the Funtoo/Gentoo paradigm where is used the ebuild to describe
the steps to compile and install a package and different repositories (the *kits*) where aggregate specific
packages for example about server services, networking, etc.
Like described in [The Story]({{< relref "/docs/story" >}}) we love the core concepts used
in FreeBSD, Gentoo and Funtoo about *knobs*/*USE* in order to customize easily a source-based
distribution. These concepts will be always core elements also in the future when we will replace Portage
itself.

Using different branches ensure different levels of stability already and so the behaviour of the
*KEYWORDS* variable used in Gentoo is less important, indeed, normally we use the value
`*` and in the future could be probably removed.

In a different way respect Gentoo and Funtoo, MARK doesn't generate the overlay metadata cache
directly in the exposed repository. The main reason is that is more simple to manage in an
upgrade workflow based on Github PR that could be merged, reverted, etc. without introduce jobs
to update constantly the same repository that receive the update of the package, etc.
Without the metadata the *emerge* solver could be slow, but this could be solved
with the execution of the command:

```
$> # As root user
$> for i in $(ls -1 /var/git/meta-repo/kits/) ; do egencache --update --repo=$i ; done
$> chown portage:portage -R /var/git/meta-repo/kits/
```

This step is temporary and managed automatically in the near future by the replacement of
the `ego` tool.

### The Bridge between Bashing and Solver

As a core element of the integration between Portage and `anise-portage-converter` tool, it
seems a good idea describe the changes originally done by Funtoo and later used in MARK to have
a better integration and used by `mark-devkit` and before from `metatools`.

Portage, like a lot of Gentoo/Funtoo users know, uses the files `.ebuild` and `.eclass` to describe
the build steps of a package. These files are elaborated using Bash through the core file `ebuild.sh`
supplied inside the Portage:

```
$> anise q files portage | grep ebuild.sh
/usr/lib/portage/python3.9/ebuild.sh
```

This file is the main script that implements the ebuild engine:

1. *it’s written in Bash and used by Portage to manage a package’s lifecycle.*

2. *provides all the standard functions that an ebuild can use, such as src_unpack, src_compile,
   src_install, etc.*

3. *handles the phases of an ebuild: unpack, prepare, configure, compile, test, install, package,
   merge, etc.*

4. *loads eclasses and applies shared logic across multiple ebuilds.*

5. *sets up the environment in which an ebuild runs (variables like S, WORKDIR, D, ED,
   PORTAGE_BUILDDIR, etc.).*

6. *essentially, it is the “skeleton” that translates ebuild syntax into concrete actions
   executed by the package manager.*

The reason it’s under *python3.9/* is that Portage itself is written in Python, but ebuilds are shell
scripts. So Portage calls this ebuild.sh as a bridge between the Python world (Portage) and
the Bash world (ebuilds).

In particular, the file `ebuild.sh` when used with the variable `EBUILD_PHASE` with value `DEPEND`,
and with `PORTAGE_PIPE_FD` with value `1` permits to obtain from stdout the description of a specific
package where is been executed the bash code. The output is split into multiple lines where every line
has a specific meaning. The same output is the same written in the metadata cache files.

This the list of positional lines generated with the specific meaning:

```bash
    DEPEND RDEPEND SLOT SRC_URI RESTRICT HOMEPAGE LICENSE
    DESCRIPTION KEYWORDS INHERITED IUSE REQUIRED_USE PDEPEND BDEPEND
    EAPI PROPERTIES DEFINED_PHASES HDEPEND _PY_COMPAT
    UNUSED_03 UNUSED_02 UNUSED_01"
```

where:

1. *DEPEND*: this line contains the list of dependencies needed only for the build of a package

2. *RDEPEND*: this line contains the list of dependencies needed at runtime

3. *SLOT*: this line contains the SLOT of the package

4. *SRC_URI*: this line contains the list of the sources needed for build a package.

5. *RESTRICT*: this line contains the list of restriction applied in the building, for example,
   RESTRICT="test" to avoid execution of the tests, etc.

6. *HOMEPAGE*: this line contains a list of URL with the homepage of the website related to the
   analyzed package.

7. *LICENSE*: this line contains the list of licenses of the package

8. *DESCRIPTION*: this line contains the description of the package

9. *KEYWORDS*: this line contains the arches enabled for the package. In Macaroni, like before
   in Funtoo normally is used `*`.

10. *INHERITED*: this line contains the list of the *eclass* used by the ebuild of the package

11. *IUSE*: this line contains the list of USE flags supported by the package

12. *REQUIRED_USE*: this line contains the condition used by the USE flags, for example
    `REQUIRED_USE="gtk? ( gstreamer )"` means that if the `gtk` USE flag is enable also the
    USE flag *gstreamer* must be set.

13. *PDEPEND*: this line contains the list of the optional dependencies that could be installed
    after the installation of the package

14. *BDEPEND*: this line contains the list of the dependencies strictly needed for build the package.

15. *EAPI*: this line contains the version of the Ebuild API used.

16. *PROPERTIES*: this line contains the properties of the package.

17. *DEFINED_PHASES*: this line contains the list of the phases defined and/or over-ridden in the ebuild,
    for example `src_unpack`, `src_compile`, etc.

18. *HDEPEND*: this line contains the list of hard dependencies for specific eclasses / helper packages.

19. *_PY_COMPAT*: this line contains the values of the PYTHON_COMPAT variable.

20. *UNUSED_03*, *UNUSED_02*, *UNUSED_01*: available for future changes.


The line/variable \_PY_COMPAT is the change added in Funtoo where is reported the values of `PYTHON_COMPAT`
variable defined in the analyzed ebuild and not present in Gentoo.

So, the Portage solver uses these information to elaborate dependencies and later start the *emerge*
process.


The `anise-portage-converter` tool uses the *ebuild.sh* script (like visible [here](https://github.com/macaroni-os/anise-portage-converter/blob/master/pkg/reposcan/generator.go#L526))
to generate the JSON file with all the packages available in a specific kit and later used to generate
*anise* spec files and/or used by `mark-devkit` to compare different branches.

The structure of the JSON file is pretty similar to the structure originally created by Daniel Robbins
for the `reposcan` tool to support Macaroni OS bootstrap. For now we have keep the same structure for compatibility
of the other Macaroni tools used to generate *anise* specs file but it could change in the near future.


Here, an example about how generate the JSON file of a specific kit to stdout:

```bash
$> anise-portage-converter  reposcan-generate --kit ai-kit --branch mark-unstable \
        --eclass-dir /var/git/meta-repo/kits/core-kit/ \
        ~/dev/macaroni/kits/ai-kit/ --concurrency 20 |  jq

{
  "cache_data_version": "1.0.6",
  "atoms": {
    "app-ai/llama-cpp-0.0.6327": {
      "atom": "app-ai/llama-cpp-0.0.6327",
      "category": "app-ai",
      "package": "llama-cpp",
      "revision": "0",
      "catpkg": "app-ai/llama-cpp",
      "eclasses": [
        [
          "toolchain-funcs",
          "24921b57d6561d87cbef4916a296ada4"
        ],
        [
          "multilib",
          "d410501a125f99ffb560b0c523cd3d1e"
        ],
        [
          "multiprocessing",
          "cac3169468f893670dac3e7cb940e045"
        ],
        [
          "ninja-utils",
          "e7575bc4a90349d76e72777013b2bbc2"
        ],
        [
          "eutils",
          "6e6c2737b59a4b982de6fb3ecefd87f8"
        ],
        [
          "flag-o-matic",
          "d0939f99dd528dd0c5ec25284877bf5c"
        ],
        [
          "xdg-utils",
          "14d00d009167652b1fa363e55effe213"
        ],
        [
          "cmake",
          "ac7cb516f6a288b6a82bc0649ce49878"
        ]
      ],
      "kit": "ai-kit",
      "branch": "mark-unstable",
      "relations": [
        "dev-util/vulkan-headers",
        "dev-util/ninja",
        "dev-util/cmake",
        "x11-drivers/nvidia-drivers",
        "dev-util/vulkan-tools",
        "media-libs/vulkan-layers",
        "media-libs/vulkan-loader",
        "media-libs/shaderc",
        "sci-libs/gsl",
        "virtual/blas",
        "virtual/lapack"
      ],
      "relations_by_kind": {
        "BDEPEND": [
          "dev-util/vulkan-headers",
          "dev-util/ninja",
          "dev-util/cmake"
        ],
        "DEPEND": [
          "x11-drivers/nvidia-drivers",
          "dev-util/vulkan-tools",
          "media-libs/vulkan-layers",
          "media-libs/vulkan-loader",
          "media-libs/shaderc",
          "sci-libs/gsl",
          "virtual/blas",
          "virtual/lapack"
        ],
        "RDEPEND": [
          "x11-drivers/nvidia-drivers",
          "dev-util/vulkan-tools",
          "media-libs/vulkan-layers",
          "media-libs/vulkan-loader",
          "media-libs/shaderc",
          "sci-libs/gsl",
          "virtual/blas",
          "virtual/lapack"
        ]
      },
      "metadata": {
        "BDEPEND": "vulkan? ( dev-util/vulkan-headers ) dev-util/ninja dev-util/cmake",
        "DEFINED_PHASES": "compile configure install prepare test",
        "DEPEND": "cuda? ( x11-drivers/nvidia-drivers ) vulkan? ( dev-util/vulkan-tools media-libs/vulkan-layers media-libs/vulkan-loader media-libs/shaderc sci-libs/gsl ) blas? ( virtual/blas virtual/lapack )",
        "DESCRIPTION": "LLM inference in C/C++",
        "EAPI": "7",
        "HDEPEND": "",
        "HOMEPAGE": "https://github.com/ggml-org/llama.cpp",
        "INHERITED": "toolchain-funcs multilib multiprocessing ninja-utils eutils flag-o-matic xdg-utils cmake",
        "IUSE": "static blas cuda vulkan",
        "KEYWORDS": "*",
        "LICENSE": "MIT",
        "PDEPEND": "",
        "PROPERTIES": "",
        "PYTHON_COMPAT": "",
        "RDEPEND": "cuda? ( x11-drivers/nvidia-drivers ) vulkan? ( dev-util/vulkan-tools media-libs/vulkan-layers media-libs/vulkan-loader media-libs/shaderc sci-libs/gsl ) blas? ( virtual/blas virtual/lapack )",
        "REQUIRED_USE": "",
        "RESTRICT": "",
        "SLOT": "0",
        "SRC_URI": "https://api.github.com/repos/ggml-org/llama.cpp/tarball/b6327 -> llama-cpp-0.0.6327-4d74393.tar.gz"
      },
      "metadata_out": "cuda? ( x11-drivers/nvidia-drivers ) vulkan? ( dev-util/vulkan-tools media-libs/vulkan-layers media-libs/vulkan-loader media-libs/shaderc sci-libs/gsl ) blas? ( virtual/blas virtual/lapack )\ncuda? ( x11-drivers/nvidia-drivers ) vulkan? ( dev-util/vulkan-tools media-libs/vulkan-layers media-libs/vulkan-loader media-libs/shaderc sci-libs/gsl ) blas? ( virtual/blas virtual/lapack )\n0\nhttps://api.github.com/repos/ggml-org/llama.cpp/tarball/b6327 -> llama-cpp-0.0.6327-4d74393.tar.gz\n\nhttps://github.com/ggml-org/llama.cpp\nMIT\nLLM inference in C/C++\n*\ntoolchain-funcs multilib multiprocessing ninja-utils eutils flag-o-matic xdg-utils cmake\nstatic blas cuda vulkan\n\n\nvulkan? ( dev-util/vulkan-headers ) dev-util/ninja dev-util/cmake\n7\n\ncompile configure install prepare test\n\n\n\n\n\n",
      "manifest_md5": "524cff112b1038d03d32c97cbda0a829",
      "md5": "eb27bb05670f95f1dd860d03b0dabd7b",
      "files": [
        {
          "src_uri": [
            "https://api.github.com/repos/ggml-org/llama.cpp/tarball/b6327"
          ],
          "size": "25625309",
          "hashes": {
            "blake2b": "562e1245ff03a8f4b33375bcff07b7eb8016d271d3afdab69096fd9e4e10bcffca270e8d4293f62cb9d44fab01afb92c1697c328f6b298c2cd5178808c0bbe12",
            "sha512": "095aa4964b7eee946d600f63546f2ba4a4e61841ab21e9bf1778d1c8e641e164385ceca275080f9a272882c5c7eaba09e7a2df6fc2e53b4d9174c11b57df1b7d"
          },
          "name": "llama-cpp-0.0.6327-4d74393.tar.gz"
        }
      ]
    },
    "app-ai/llama-cpp-0.0.6402": {
    ...

```

or to a specific file:

```bash
$> anise-portage-converter  reposcan-generate --kit ai-kit --branch mark-unstable \
        --eclass-dir /var/git/meta-repo/kits/core-kit/ \
        ~/dev/macaroni/kits/ai-kit/ --concurrency 20 \
        -o file -f /tmp/ai-kit-mark-unstable
```

where the convention of the target file is *\<kit-name\>-\<kit-branch\>*.


> The ebuild.sh script is an important point where will be possible to integrate new technologies
> without replace totally Portage at the begin.

### Impacts on upgrading Python release

Considering that Portage engine is written in Python and a lot of packages using PYTHON_COMPAT
through the evoluted syntax introduced by Funtoo about *python3+* to automatically support all available Python
versions we share especially for *staff* developers a list of important points to verify on
upgrading Python release:

1. *anise-portage-converter*: as a core tool of the Macaroni workflow this tool must be
   updated to support a new release on expand *python3+* string.
   So, it's important check the supported [implementations](https://github.com/macaroni-os/anise-portage-converter/blob/master/pkg/reposcan/generator.go#L80).

2. *python-utils-r1.eclass*: another core eclass used in the Portage engine to expand *python3+*
   string. It's needed check the [\_python_set_impls](https://github.com/macaroni-os/core-kit/blob/mark-unstable/eclass/python-utils-r1.eclass#L146) function and update it with new Python releases

3. *python-kit profile*: modify the [make.defaults](https://github.com/macaroni-os/kit-fixups/blob/mark-unstable/core-kit/profiles/funtoo/kits/python-kit/mark/make.defaults) file with the correct value for the variables
   `PYTHON_TARGETS` and `PYTHON_SINGLE_TARGET`.

