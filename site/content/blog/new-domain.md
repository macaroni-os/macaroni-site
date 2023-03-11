
---
author: "Daniele Rondina"
date: 2023-01-20
linktitle: Macaroni OS new domain!
next: /tutorials/github-pages-blog
prev: /tutorials/automated-deployments
title: macaronios.org is here!
tags:
  - macaroni
weight: 5
---

After 1 year of incubation under the Funtoo Foundation, the Macaroni OS has now
its domain `macaronios.org` and its infrastructure. Really, *thanks to the Funtoo
Foundation and Daniel Robbins for its support that helped to Macaroni OS to be here today*.

From the infrastructure aspect nothing is changed, all compilation tasks are executed
over MottainaiCI cluster but with less resource power for now.

We hope that the community will help us to maintain the infrastructure costs
with donations over our Github [Sponsor](https://github.com/sponsors/geaaru) or
with VMs donations for compilation.

# New Github Organization

With the review of the Macaroni OS domain, it's been created a new and independent
GitHub organization [macaroni-os](https://github.com/macaroni-os/) and migrated all
Git repositories there.

# Domain migration and users impacts

The old domain `*.macaroni.funtoo.org` will expire soon, the existing users
that are yet with the repository `geaaru-repo-index` configured with the
Github URL will receive automatically the upgrade of the `repository/*` packages.

```bash
$# luet repo update
ℹ️  Repository:              geaaru-repo-index Priority:   1 Type:  http Revision:   2
ℹ️  Repository:               macaroni-commons Priority:   2 Type:  http Revision: 117
ℹ️  Repository:                macaroni-funtoo Priority:   2 Type:  http Revision: 620
ℹ️  Repository:               mottainai-stable Priority:   1 Type:  http Revision:  55

$# luet upgrade
ℹ️  Repository:              geaaru-repo-index Priority:   1 Type:  http Revision:   2
ℹ️  Repository:               macaroni-commons Priority:   2 Type:  http Revision: 117
ℹ️  Repository:                macaroni-funtoo Priority:   2 Type:  http Revision: 620
ℹ️  Repository:               mottainai-stable Priority:   1 Type:  http Revision:  55
🤔  Computing upgrade, please hang tight... 💤 
🌏 Using solver implementation  solverv2 .
🌎 Completed compute upgrade analysis in 23323842 µs.
+-------------------------------------+-------------+-------------+-------------------+---------+
| PACKAGE                             | NEW VERSION | OLD VERSION | REPOSITORY        | LICENSE |
+-------------------------------------+-------------+-------------+-------------------+---------+
| repository/geaaru-repo-index        | 20230118    | 20220819    | geaaru-repo-index |         |
| repository/macaroni-commons         | 20230118    | 20211210    | geaaru-repo-index |         |
| repository/macaroni-funtoo          | 20230118    | 20211210    | geaaru-repo-index |         |
| repository/mottainai-stable         | 20230118    | 20220318    | geaaru-repo-index |         |
+-------------------------------------+-------------+-------------+-------------------+---------+
By going forward, you are also accepting the licenses of the packages that you are going to install in your system.
Do you want to continue with this operation? [y/N]: 

```

Instead, the users with the new configuration could receive the new repositories address on change
the content of the the `/etc/luet/luet.yaml` (if the geaaru-repo-index is configured inline and not through
the repository config file or editing the file `/etc/luet/repos.conf.d/geaaru-repo-index.yml` with
this content:

```yaml
- name: "geaaru-repo-index"
  description: "Geaaru Repository index"
  type: "http"
  enable: true
  cached: true
  priority: 1
  urls:
  - "https://cdn.macaronios.org/mottainai/geaaru-repo-index"
  - "https://raw.githubusercontent.com/geaaru/repo-index/gh-pages"
```

After that to get the new updates just run:

```bash
$# macaronictl etc-update
```

The map with the changes of the URL is available [here](https://github.com/macaroni-os/macaroni-funtoo#news).

# What next?

Hereinafter, our hot points for the near future:

1. We working to complete the review of the `luet` installer and his algorithms
   to reduce the memory usage, rewrite the solver and introduce the
   packages mask concept. This will permit us to begin on working a Macaroni
   release for ARM (Banana PI, Raspberry).

2. The `terragon` release will drop the support to Python 3.7 to leave
   active only Python 3.9.

3. Create a full and clear documentation of all Macaroni features.

3. When the first two points will be reached will start the integration
   of `macaroni-ffs` project related to the Funtoo FFS technology and permit
   users to have easy the toolchains for compilation

A lot of things are in our plan, stay tuned!

# Additional thanks

On setup of the new infrastructure, I want to thank the all people who helped me in
setting up the Cloudflare services in about two days. Really, thanks.
