---
author: "Daniele Rondina"
linktitle: FAQ
title: Frequently Asked Questions
type: contact
#menu:
#    main:
weight: 4
---

### **1. How to update Macaroni Repositories URLs?**

In the last period due to the changes in the new domain and the stabilization of
the Macaroni infra there are a lot of changes in the repository URLs.
Working with donated resources and/or free resources has the consequence that
changes could happen.

So, I will describe the better way to upgrade our repositories safely.

a) leave only the `geaaru-repo-index` repository enabled.
This means to call `luet repo disable` for all other repositories

```
$# anise repo disable macaroni-commons mottainai-stable macaroni-funtoo

$# anise repo list --enabled
geaaru-repo-index
  Macaroni OS Repository Index
  Revision     4 - 2023-02-25 10:32:39 +0000 -00
  Priority     1 - Type http

```

b) At this point, it's possible to update the repository and get the new urls:

```
$# anise repo update
🏠 Repository:              geaaru-repo-index Revision:   4 - 2023-02-25 10:32:39 +0000 -00
$# anise upgrade
```

The upgrade creates the files `/etc/luet/repos.conf.d/._cfg_<repo>.yml` that could be merged with the
command `etc-update` (in the old system) or with the command `macaronictl etc-update`
in more updated systems.

After the upgrade and the merge of the new configs the system is ready for the
updates: `anise repo update` and `anise upgrade`.

It's possible to check the repository urls with:

```
# anise repo list --urls --enabled
geaaru-repo-index
  Geaaru Repository index
  Revision     4 - 2023-02-25 10:32:39 +0000 UTC
  Priority     1 - Type http
  Urls:
   * https://cdn.macaronios.org/mottainai/geaaru-repo-index
macaroni-commons-dev
  Macaroni OS Commons Development Repository
  Revision   129 - 2023-03-03 22:16:31 +0000 UTC
  Priority    10 - Type http
  Urls:
   * https://dev.macaronios.org/macaroni-commons-dev/
macaroni-funtoo-systemd-dev
  Macaroni OS Eagle Develop Repository
  Revision   452 - 2023-02-26 11:14:32 +0000 UTC
  Priority     2 - Type http
  Urls:
   * https://images.macaronios.org/macaroni-funtoo-systemd-dev/
mottainai-dev
  Mottainai Development Repository
  Revision    72 - 2023-02-25 23:47:52 +0000 UTC
  Priority    10 - Type http
  Urls:
   * https://dev.macaronios.org/mottainai-dev/
mottainai-stable
  Mottainai official Repository
  Revision    72 - 2023-02-25 23:47:52 +0000 UTC
  Priority    30 - Type http
  Urls:
   * https://dl.macaronios.org/repos/mottainai/
   * https://cdn2.macaronios.org/repos/mottainai/
   * https://macaronios.mirror.garr.it/repos/mottainai/
```

### **2. What to do after the upgrade of the anise binary?**

I leave this point in the FAQ because I began to rewrite the Macaroni PMS and until
I will rewrite the `luet-build` binary the `luet repo update` command executes
some post-fetch operations on the downloaded tree to speed up the research,
and to have the files used by the new solver available in the `luet` 
version 0.33.0 and followed.

So, after the upgrade of luet there are two things that are better to do:

```
$# anise database reindex
```
This will rebuild the Bolt Database indexes and

```
$# anise repo update --force
```
that downloads and executes again the post-fetch hooks in the downloaded tree.

One of the errors reported by users when a full fetch of the Macaroni 
repositories is not executed after the upgrade is this:

```
🤔 Computing upgrade, please hang tight... 💤
Error: Package net-libs-4/webkit not found on map
```

### **3. Why `anise search` doesn't return packages?**

Excluding the search of installed packages, I mean with the `--installed`
option, the `anise search` command works only when the enabled repositories have
been synced. 

It's just needed to download one time the repository tree and then all works
fine.

```
$# anise repo update
...

$# anise s macaronictl
app-admin/macaronictl-0.6.2
app-admin/macaronictl-thin-0.6.2

# anise s portage-converter
macaroni/anise-portage-converter-0.11.2
```

<<<<<<< Updated upstream
### **4. `luet` or `anise`? What is the difference?**

The tool `anise` is the Macaroni OS Package Manager that previously
was called `luet`. We will definitively rename it when we have
completed the refactor of `anise-build` tool.


=======
### **4. Upgrade old systems**

When weight
>>>>>>> Stashed changes
