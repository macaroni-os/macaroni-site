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

2. *dynamicity*: one of the pros of Gentoo and Funtoo is the easy way to add patches to
   upstream sources, at the same way we want follow this pattern and try to share an OS
   that is a good place for developers.

3. *reproducibility*: share technologies, how to configure it and using Opensource is one
of the core and more important key of MARK OS. Without sharing the knowledge this world
will never grow. So, another important point a bit complex, for a lot of reason and just
for for the volume of the documentation will be sharing our *Distro from Scratch* steps
used in MARK.

Now the we have described the main principles under this stack it's time to describe
how the magic is started and how will be improved.


After the Funtoo shutdown in August 2024, Macaroni OS thanks to the support of the ex-Funtoo
developers decides to start a new adventure to keep the system independent from other distro
in order to have a better control of the system and avoid that external changes could be
dangerous in the Macaroni OS itself. Obviously, starting from zero was not possible, and so,
based of the expirience get in Funtoo we have applied the first changed to the *metatools*,
*ego* needed to create the base for what is been developed in one year and that will be evolved
again in the future. But having a clear target, trying to join the two worlds and create a gate
between the Anise/binary stack and the sourced-based world of MARK. But not only this, the
Portage itself it's a software created in Gentoo that will be replaced too in the future or at
least we hope on this. Working on our free time doesn't permit to share specific dates and/or
milestone so what we can share is at least the plan.

Through this vision we are been really lucky to find our Sponsors, really thanks always for their
support, and thourgh them we also oriented the development of our tools to be more connected to
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
tree splitted in kits. This behaviour is also a protection about errors done in the
kits that could be fastly reverted because until a new bump is done users will be
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
list of the new versions availables.

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
experimental for now but when will be ready we will add testing and stable
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

At the moment, Macaroni OS uses a forked version of Portage with patches from Funtoo as main package
manager system but with an eye for improve integration with `anise` and the Macaroni binary
layer.

The Macaroni Portage fork follow the Funtoo/Gentoo paradigm where is used the ebuild to describe
the steps to compile and install a package and different repositories (the *kits*) where aggregate specific
packages for example about server services, networking, etc.
Like described in [The Story]({{< relref "/docs/story" >}}) we love the core concepts used
in FreeBSD, Gentoo and Funtoo about *knobs*/*USE* in order to customize easily a source-based
distribution. These concepts will be always core elements also in the future when w will replace Portage
itself.

Using different branches ensure different levels of stability already and so the behaviour of the
*KEYWORDS* variable used in Gentoo is less important, indeed, normally we use the value
`*` and in the future could be probably removed.

In a different way respect Gentoo and Funtoo, MARK doesn't generate the overlay metadata cache
directly in the exposed repository. The main reason is that is more simple to manage in an
upgrade workflow based on Github PR that could be merged, reverted, etc. without introduce jobs
to update costantly the same repository that receive the update of the package, etc.
Without the metadata the *emerge* solver could be slow, but this could be solved
with the execution of the command:

```
$> # As root user
$> for i in $(ls -1 /var/git/meta-repo/kits/) ; do egencache --update --repo=$i ; done
```

This step is temporary and managed automatically in the near future from the replacer of
the `ego` tool.


