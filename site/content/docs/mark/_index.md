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
| **Ebuild generator** | - | metatools | `mark-devkit autogen`, `mark-devkit kit merge` |
| **Stage tarballs generator** | `catalyst` | `metro` | `mark-devkit metro` |
| **Stability level assurance** | single tree where using KEYWORDS and portage.mask | single tree fully autogen with KEYWORDS and portage.mask | multiple versions for every package, portage.mask and different branches with different stability levels |
| **Installer** | manual | manual | calamares |


### Portage

At the moment, it uses a forked version of Portage with patches from Funtoo as main package
manager system but with an eye for improve integration with `anise` and the Macaroni binary
layer.

The Macaroni Portage fork follow the Funtoo/Gentoo paradigm where is used the ebuild to describe
the steps to compile and install a package and different repositories (the *kits*) where aggregate specific
packages for example about server services, networking, etc.

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


