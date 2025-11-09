---
author: "Daniele Rondina"
date: 2025-09-28
linktitle: Phoenix 25.09 and MARK-I 25.09 Released!
title: Phoenix 25.09 and MARK-I 25.09 Released!
tags:
  - mark
  - macaroni
  - release
  - phoenix
weight: 5
---


# MARK-I 25.09 is here!

We are excited to share that the first release of MARK-I 25.09 is been released!

The `mark-i` release is the stable source-based release for Desktop. I'm pretty sure that
is not perfect but it's an important milestone for us that sign the start point of the
MARK era also for Desktop.

This release is been pretty tested over the Phoenix pipeline in the *mark-iii* but there are
few packages not yet available in Phoenix that are not integrated in the build chain that
could be have issues, but normally, the core packages are all in the build chain and we can
consider the tree pretty stable for end users.

Together with this milestone we have started our Portage fork in order to start to drop
all features available in Gentoo and not used in Macaroni OS.

I'm really in difficult on trying to summarize the things done to have the first release
of mark-i, there are so much things that probably we can consider this first release our
starting point and begin to describe the evolutions from the next release 😎.

My special thanks go to the Macaroni's Developers that continue to be present and continue
to improve the OS, they are part of the milestone and of this success. Thank you very much!

We have worked a lot on documentation in order to clarify the connection between Sambuca/Anise
stack and MARK that is now available in the Documentation section of the website. There are a
lot of arguments to cover in the documentation that aren't detailed but it's a good start point.

A lot of things will be done in the next releases because now that the autogen technology is
pretty stable we will automize a lot of others packages in order to have more updates but a
lot of is been done to reach this result and I'm happy to see the this hard work begin to be
visible in the net with positive feedback. Really, thanks to all people that in the months
have share Macaroni OS to the world.

The list of all packages available on MARK are visible through the
[meta-repo](https://github.com/macaroni-os/meta-repo/releases/tag/v25.09-mark-i) repository
where are linked the tags of all kits available in the tree mark-i.

Inside this path we have finally written a lot of documentation about the logics about the
different releases and branches of MARK and how the two worlds of Sambuca Stack and MARK stack work.
See our [Documentation]({{< relref "/docs/" >}}) page for the details.

A [Became a Contributor]({{< relref "/docs/mark/contributors" >}}) section is been also
added and so:

<div style="text-align: center; margin-bottom: 20px">

<img src="../../images/macaroni_wait4you.png" width="300">

</div>

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG)!


## Debian Kernels available on MARK

Thanks to Macaroni's developer Kevin P. Wilson aka [cuantar](https://github.com/cuantar) the Debian kernels
is now autogen and available in our *kernel-kit* with different SLOTs: *bookworm*, *trixie* and *sid*.

It's been completed the integration with *dracut* like already was available in the Phoenix kernels and
thanks to this work we will have soon this kernel available as binary package for Phoenix for the
next release.

## KDE 6 incoming

Thanks to Macaroni's developer Rob Wheatley aka [r0b](https://github.com/linuxexplorer) we share a really
lovely preview of one of the incoming update for Desktop, KDE 6!


<div style="text-align: center; margin-bottom: 20px">

<img src="../../images/mark/kde6_preview.png" width="800">

</div>

We need to upgrade *cmake* to a new release and later we will start to share the new ebuild!

# AI technology on Macaroni OS

Starting from MARK world until to the Phoenix release we have start to create the packages
related to the AI technology. For now the packages are pretty few but in very simple steps
the users could have their local openAI with *Ollama*:

```shell
$> anise i --sync-repos ollama && macaronictl env-update
$> # or on MARK through Portage
$> emerge ollama
```

and now it's possible editing the server options in the configuration file:

```
$> cat /etc/conf.d/ollama
# Define the binding address
OLLAMA_HOST="127.0.0.1"

# Define the models directory
OLLAMA_MODELS=/var/lib/ollama/models/

# Working dir of the daemon
# OLLAMA_WORKDIR=/var/lib/ollama

# See ollama documentation for all available options
# OLLAMA_MAX_LOADED_MODELS=1
# OLLAMA_KEEP_ALIVE=1800
# OLLAMA_MAX_VRAM=5368709120
# OLLAMA_NUM_PARALLEL=4
# OLLAMA_SCHED_SPREAD=1
# OLLAMA_DEBUG=1

# Force using of CUDA for a specific
# GPU by id. In the example, GPU 0.
# CUDA_VISIBLE_DEVICES=0

OLLAMA_NOPRUNE=1

# Enable logging using deamon output redirect.
# OLLAMA_LOGGING=1

# In order to use libcuda library correctly
# set the path of the active nvidia driver
# LD_LIBRARY_PATH=/opt/nvidia/nvidia-drivers-565.77/lib64/
$>
```

In order to use the CUDA acceleration it's needed configure the *LD_LIBRARY_PATH*
in the configuration file with the release active that could be visible
with `gpu-configurator show` command.

When the configuration is done the server could be started easily with:

```shell
$> /etc/init.d/ollama start
$> # and optionally enabled at bootstrap with
$> rc-update add ollama
 * service ollama added to runlevel default
```

And later from your user terminal:

```shell
$> ollama run granite3.3:2b
pulling manifest 
pulling ac71e9e32c0b: 100% ▕█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏ 1.5 GB                         
pulling 3da071a01bbe: 100% ▕█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏ 6.6 KB                         
pulling 4a99a6dd617d: 100% ▕█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  11 KB                         
pulling f9ed27df66e9: 100% ▕█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  417 B                         
verifying sha256 digest 
writing manifest 
success 
>>> hi, i'm Daniele, creator of Macaroni OS Linux
Hello Daniele! It's great to meet you and learn about your project, Macaroni OS Linux. How can I assist you today?
>>> Send a message (/? for help)

>>> bye
Alright, take care, Daniele! If you have any questions or need help with Macaroni OS Linux in the future, feel free to reach out. Good luck with your project!

>>> /bye

```

Also the `llama-cpp` package is available but without init.d scripts for now.

If you have idea about what packages could be good to have in the distro about AI feel free to open an issue
on `mark-issue` repository.

# Phoenix 25.09

This release is a normal upgrade release that improve integration with MARK and few important
upgrade from Desktop and Server side.

In evidence:

* Incus 6.13

* Blender 4.5.1

* Openssh 10.0_p2

* LibreOffice 25.8.1

* Grafana 12.1.1

* Minio 2025.07.23

See the complete changelog of [Phoenix 25.09 release](https://github.com/macaroni-os/macaroni-funtoo/releases/tag/v25.09-phoenix).

## Security CVE fixed in evidence:

CVE-2025-22874: Golang

CVE-2025-32462, CVE-2025-32364: Sudo


# Macaroni ARM64 incoming!

Thanks to the work of our developer *Raphael Bastos* aka [coffnix](https://github.com/coffnix)
we have the first stage3 for ARM64 based on `mark-31` branch that will be used in near future
to create a Macaroni ARM binary repository too.

The stage3 could be downloaded using *anise* through the *macaroni-distfiles* repository:

```shell
$> anise i --sync-repos repository/macaroni-distfiles
$> anise i --sync-repos mark-31/stage3-arm64
```

The `mark-31` branch is pretty experimental, but we will work to stabilize things and
prepare SD images ready to be used on different embedded devices. Stay tuned!


# Thanks

Many thanks to all Developers and Contributors that are the sap of all this and to all
people that helps us with testing and donations.

# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru) or through the
[Liberay](https://liberapay.com/geaaru/) page.

