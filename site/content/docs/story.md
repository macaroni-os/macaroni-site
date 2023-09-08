---
title: "The Story"
type: docs
---

I write this article because I think that it's needed to understand the
story to improve things and instead follow the original choices when
they make sense.

# The Origins

After a lot of years working with opensource packages, I can for sure
to said that there are so many possibilities to configure our systems
that it isn't sufficient one life to test all combinations.

But the power to choose is one of the more powerful things that the
open-source world gift and the same packages often are created with
the possibility to compile and build them in different ways.
Also, the compiler used to compile and build a package supplies a
lot of options to compile, optimize and validate the code (for example
using -O2 or -O3 options) and this introduces again others combinations.

On August 21, 1994, **Jordan Hubbard** committed his *port make macros* to
the FreeBSD CVS repository, and the FreeBSD ports is born.
The FreeBSD `ports` through *Makefile*, supplies a way to define how
it's possible to compile a package and what are the `knobs` (or options)
available to customize the compilation. So, the FreeBSD `ports` defines
a way to supply metadata with the rules for compiling packages and
optionally customize the *configure* options.

Following the concept to optimize the packages of a system based on
specific hardware optimization in December 1999, **Daniel Robbins**
initially created **Gentoo Linux** (previously called Enoch Linux).
Daniel Robbins and the other contributors experimented with a fork
of GCC known as EGCS, developed by Cygnus Solutions. At this point,
"Enoch" was renamed "Gentoo" Linux (the Gentoo species is the
fastest-swimming penguin). The modifications to EGCS eventually
became part of the official GCC (version 2.95), and other Linux
distributions experienced similar speed increases.
After problems with a bug on his own system, Robbins halted Gentoo
development and switched to FreeBSD for several months, later saying,
"I decided to add several FreeBSD features to make our autobuild
system (now called *Portage*) a true next-generation ports system".

Gentoo Linux 1.0 was released on March 31, 2002. In 2004,
Robbins set up the non-profit Gentoo Foundation, transferred all
copyrights and trademarks to it, and stepped down as chief architect
of the project.

Gentoo is a source-based distribution with a repository describing
how to build the packages, and adding instructions to build on
different machine architectures. In particular, the rules about
how build a package are defined inside `Ebuild` files and on `Eclasses`
files which are both files using Bash language. The Portage written
in Python is the Package Manager System that calculates dependencies
and the order to build using the underlying rules read from the
Ebuild and Eclass files.

What are called `knobs` on **FreeBSD** in Gentoo are called `USE` flags.

Inside an ebuild there are some important pieces of information in
addition to the rules about how to compile a package, pieces of 
information defined inside Bash variables:

* `IUSE`: The list of the USE flags that an user could select or not
  to configure the build process.

* `DEPEND`, `PDEPEND`, and `BDEPEND`: these variables contain the
  list of the packages needed to compile the package

* `RDEPEND`: contains the list of the packages needed at runtime
  to use the package.

These pieces of information with others are what is called the
`metadata` of the package and for an installed package are visible
under the directory `/var/db/pkg`.

In Macaroni, like in both binary `luet-portage-converter` and `luet`
we use code available in the `pkgs-checker` tool that I written in
Golang that between the rest, it has a way to retrieve package *metadata*
and convert them to JSON:

```shell
$> sudo pkgs-checker portage metadata app-emulation/lxd  -j | jq
[
  {
    "package": {
      "name": "lxd",
      "category": "app-emulation",
      "version": "5.12",
      "slot": "0",
      "Condition": 5,
      "repository": "geaaru-kit",
      "use_flags": [
        "-apparmor",
        "ipv6",
        "-nios2",
        "nls",
        "-sh"
      ],
      "license": "Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
    },
    "iuse": [
      "apparmor",
      "ipv6",
      "nls",
      "kernel_linux"
    ],
    "iuse_effective": [
      "alpha",
      "amd64",
      "amd64-fbsd",
      "amd64-linux",
      "apparmor",
      "arm",
      "arm-linux",
      "arm64",
      "elibc_AIX",
      "elibc_Cygwin",
      "elibc_Darwin",
      "elibc_DragonFly",
      "elibc_FreeBSD",
      "elibc_HPUX",
      "elibc_Interix",
      "elibc_NetBSD",
      "elibc_OpenBSD",
      "elibc_SunOS",
      "elibc_Winnt",
      "elibc_bionic",
      "elibc_glibc",
      "elibc_mingw",
      "elibc_mintlib",
      "elibc_musl",
      "elibc_uclibc",
      "hppa",
      "ia64",
      "ipv6",
      "kernel_AIX",
      "kernel_Darwin",
      "kernel_FreeBSD",
      "kernel_HPUX",
      "kernel_NetBSD",
      "kernel_OpenBSD",
      "kernel_SunOS",
      "kernel_Winnt",
      "kernel_freemint",
      "kernel_linux",
      "m68k",
      "m68k-mint",
      "mips",
      "nios2",
      "nls",
      "ppc",
      "ppc-aix",
      "ppc-macos",
      "ppc64",
      "ppc64-linux",
      "prefix",
      "prefix-chain",
      "prefix-guest",
      "riscv",
      "riscv32",
      "riscv64",
      "s390",
      "sh",
      "sparc",
      "sparc-fbsd",
      "sparc-solaris",
      "sparc64-solaris",
      "userland_BSD",
      "userland_GNU",
      "x64-cygwin",
      "x64-macos",
      "x64-solaris",
      "x86",
      "x86-cygwin",
      "x86-fbsd",
      "x86-linux",
      "x86-macos",
      "x86-solaris",
      "x86-winnt"
    ],
    "use": [
      "amd64",
      "elibc_glibc",
      "ipv6",
      "kernel_linux",
      "nls",
      "userland_GNU"
    ],
    "eapi": "7",
    "cxxflags": "-mtune=generic -O2 -pipe",
    "cflags": "-mtune=generic -O2 -pipe",
    "ldflags": "-Wl,-O1 -Wl,--sort-common -Wl,--as-needed",
    "chost": "x86_64-pc-linux-gnu",
    "bdepend": ">=dev-lang/go-1.18 >=sys-kernel/linux-headers-4.15 sys-devel/gettext >=app-portage/elt-patches-20170815 !<sys-devel/gettext-0.18.1.1-r3 || ( >=sys-devel/automake-1.16.1:1.16 >=sys-devel/automake-1.15.1:1.15 ) >=sys-devel/autoconf-2.69 >=sys-devel/libtool-2.4 >=dev-lang/go-1.10",
    "rdepend": "app-arch/xz-utils app-arch/lz4 >=app-emulation/lxc-4.0.6 dev-lang/tcl dev-libs/libuv dev-libs/lzo >=dev-util/xdelta-3.0 net-dns/dnsmasq[dhcp,ipv6] net-firewall/ebtables net-firewall/iptables[ipv6] sys-apps/iproute2[ipv6] sys-fs/fuse:* sys-fs/lxcfs sys-fs/squashfs-tools[lzma] virtual/acl",
    "depend": "app-arch/xz-utils app-arch/lz4 >=app-emulation/lxc-4.0.6 dev-lang/tcl dev-libs/libuv dev-libs/lzo >=dev-util/xdelta-3.0 net-dns/dnsmasq[dhcp,ipv6] sys-apps/shadow",
    "requires": "x86_64: libacl.so.1 libc.so.6 libcap.so.2 libdl.so.2 libgcc_s.so.1 liblxc.so.1 liblz4.so.1 libpthread.so.0 libsqlite3.so.0 libudev.so.1 libutil.so.1 libuv.so.1",
    "keywords": "*",
    "provides": "x86_64: libdqlite.so.0 libraft.so.3",
    "size": "232869057",
    "build_time": "1679645369",
    "cbuild": "x86_64-pc-linux-gnu",
...
```

*The Portage together with the Ebuild is a very powerful tool to
compile and customize packages and the OS.*

I began to play with Gentoo around the year 2003 when I was a student
at the Computer Science University and in one of my first job. Yet,
I remember now how much time was needed to compile the *kernel* in
a Pentium 233Mhz (if I remember correctly the model) and how much time
I used to improve the old systems and yet, how much time to download
tarball with a 56Kbit Analogic Line. Gentoo helped a lot with this.

Compile everything and every time could be more expensive as time
and costs, it's so in 2005 is created **Sabayon Linux** or **Sabayon**
(formerly RR4 Linux and RR64 Linux), an Italian Gentoo-based Linux
distribution created by **Fabio Erculiani**. Sabayon followed the
"out of the box" philosophy, aiming to give the user a wide number
of applications ready to use and a self-configured operating system.

The Sabayon's Package Management System called `Entropy`, developed
by Fabio Erculiani and others extends the Gentoo Portage. The Portage
downloads *source-code* and compiles it specifically for the target
system, Entropy manages binary files from servers; the binary tarball
packages are precompiled using the Gentoo Linux tree using `emerge`
(the Portage tool).

On the other side of the world, at the beginning of 2008, is created
the **Funtoo Linux** Linux distribution based on Gentoo Linux. It
was created by **Daniel Robbins** after that the Gentoo Foundation
doesn't want to follow the ideas proposed by Robbins.

Thanks to the high quality of the solution and the easy customization
in 2009 Google chose to create the **Chrome OS** (or **Chromium OS**)
based on Gentoo (previously based on Ubuntu).

Between battles with Solaris servers and Debian's VMs on beginning
working on supplying ready-to-use binary packages for my Clients,
my colleague, and friend **Walter Curtetti** (aka `kurtz81`) shared
with me a new Distribution that is based on Gentoo: **Sabayon**.
So, in 2010, I started my interest on follow the Sabayon Team before
as a Contributor and then as Developer in 2018.

In my years in Sabayon, I saw different things happen and I learn
what are the areas that could be improved in a distribution and/or
critical:

1. The Sabayon's Packages Manager is written in Python and every time
   a new release of Python (for example from 3.6 to 3.7) was upgraded
   it was needed to support both releases for a bit of time and then
   to drop the previous to do an upgrade safe.

2. The big change in converting the `/lib` from a link to a directory
   it's been a disaster, but it's funny now to see the new SystemD
   release now prefers the old way with /lib and /usr/lib as links.

3. The pros to having `Entropy` as an extension of the Portage are
   fewer of the cons when Gentoo had to begin to do changes to the
   Portage that was not so easy to integrate with a code old to rewrite.

4. Supply a way for users to build additional packages through the
   [SARK](https://github.com/Sabayon/sabayon-sark) engine was really
   difficult because the Portage tree changes so fastly that was injected
   often dependencies that were for the sabayon core repository.
   We have tried with a Portage tree fixed to a specific Git Hash but
   also in this case sometimes wasn't sufficient.

5. Entropy doesn't handle correctly a reboot of a repository or only
   with forcing the sync of the repository.

With these words I don't want to say that Entropy was bad, instead, it's
been a good product but without good maintenance of the code, it becomes
slowly obsolete and too hard to fix.

After years, what is been an important element for the change is been
following a path where the PMS was statically linked, without dependencies
to other elements of the system that could be a problem in the upgrade
phase. And so, in 2019/2020, this idea became real through a tool written
in Golang: and it that born the  `luet` project. With the release of the
first versions, we have decided to a rebranding with the name **Mocaccino OS**.

The `luet` project was born to be a tool that is no more strictly connected
to a specific compilation engine, thanks to the experience had with Entropy,
but also free to use existing compilation systems without losing the prons.
To reach this target it uses primarily Docker containers and this ensures
reproducibility and isolation.
Thanks to this independence, luet can be used to supply generic binary from
every distributions.

The second big problem to resolve is been to have a more managed environment
where builds and upgrades packages at the same time in a way independent but
more controlled. It's here that I began to work with integration between
Mocaccino and **Funtoo** because it seems to me a better solution than Gentoo
for our targets. I really appreciate the separation done by Funtoo in Kits and
the use of branches to separate the big changes and personally, I think that
these are been a very good choice by Daniel Robbins.

This integration starts my collaboration with Daniel Robbins and the
announcement of the joining between [Sabayon and Funtoo](https://forums.funtoo.org/topic/4882-funtoo-linux-and-sabayon-joining-forces/#comment-17039)
to work together.

Thanks to the support of **Daniel Robbins**, the `reposcan` tool was borns
inside the metatools project to help in this integration. The `reposcan` tool
generates the JSON files with the Portage metadata of every kit, these files
are then used by the `luet-portage-converter` tool to generate the luet
specs used for build packages.

The `luet-portage-converter` tool uses the *reposcan* files to calculate
the build dependencies like the runtime dependencies based on the USE flags
defined in its specs and then executes simplification stages to reduce
the dependencies complexity. For example, if dependency A is an RDEPEND
of the package B and C and package C has also a dependency to B, then we
could avoid adding A as a dependency of C because is already injected by B.

# Macaroni OS Era begins

In the middle of all this, at some point, my ideas about proceeding and
changing `luet`, to continue the Funtoo integration, and with the Mocaccino
Desktop release begins to be considered wrong and not accepted.
In December 2021, I left the Sabayon/Mocaccino Team and create the
**Macaroni OS** Project with the precious support of Daniel Robbins that
help me bootstrap the domain `macaroni.funtoo.org` under the Funtoo umbrella.

In January 2023, I buy the domain `macaronios.org` and create the Github
project [macaroni-os](https://github.com/macaroni-os/) so that the Macaroni OS
became an independent project always strictly related to the Funtoo Community.

I want to thank every people that this long story is been part of it,
in the bad and in the good, without you all of this will not be present.
Good luck and good life to all of you.

And so, this is the begin...
