---
author: "Daniele Rondina"
date: 2026-05-17
linktitle: Copy Fail and Dirty Frag
title: Copy Fail and Dirty Frag on Macaroni OS
menu:
  main:
tags:
  - mark
  - macaroni
  - security
weight: 5
---

A little detail about last security issues in Linux world
and the impact in the Macaroni OS world.

# Copy Fail on Macaroni OS

In the last period a lot of important CVEs (CVE-2026-31431, CVE-2026-43500, etc.)
in the Linux world that have shaken all Linux distros.
We speak about *Copy Fail*, *Dirty Frag* and derived exploits.

We are surprised that an important mitigation strategy is not yet
been shared and analyzed by the Macaroni OS Team. This strategy doesn't
resolve the security issue but at least give to the OS administrator
a bit more time to organize structured upgrade process.

So, this article wants share what is been discovery in order to be usable
not only in Macaroni OS but in all distros where possible.

We was titubante to share or not this informations, because share them means
also give a new means to attacker but we think that is something interesting
that need to be shared considering that the fixes of the security issues are
now available.

The security issues related to the *Copy Fail* exploit uses a Linux kernel
bug on page cache that permits root escalation where the files with *suid*
have readable permissions.

Before enter in the detail we share a real example did in the `macaroni/mark-unstable` LXD/Incus
container using the Golang [copyfail-go](https://github.com/badsectorlabs/copyfail-go)
tool now available in our `forensics-kit` to show the exploit and the mitigation.

So, the first step is create the testing container:

```bash
$> incus launch -p default macaroni:macaroni/mark-unstable test-cve

$> incus exec test-cve bash

test-cve / $ ego sync

test-cve / $ anise repo update

test-cve / $ anise i go entities
🚀 Luet 0.41.1-geaaru-gc4815024d03bc88794c76a165ba4018ae07296a3 2026-02-21 08:31:25 UTC - go1.25.7
🏠 Repository:              geaaru-repo-index Revision:   15 - 2025-01-04 18:10:44 +0000 -00
🏠 Repository:               macaroni-commons Revision:  281 - 2025-09-20 16:58:24 +0000 -00
🏠 Repository:              macaroni-terragon Revision:  716 - 2026-02-28 08:38:26 +0000 -00
🏠 Repository:                           mark Revision:  118 - 2026-05-12 18:01:03 +0000 -00
🧠 Solving install tree...
🍦 [  1 of   2] [N] app-admin/entities::mark                                      - 0.9.3+5
🍦 [  2 of   2] [N] dev-lang/go::macaroni-terragon                                - 1.25.7
💂 Checking for file conflicts...
✔️  No conflicts found (executed in 31259 µs).
Do you want to continue with this operation? [y/N]: y
🚚 Downloading 2 packages...
📦 [  1 of   2] app-admin/entities::mark                                          - 0.9.3+5         # downloaded ✔ 
📦 [  2 of   2] dev-lang/go::macaroni-terragon                                    - 1.25.7          # downloaded ✔                              
🧠 Sorting 2 packages operations...
🍻 Executing 2 packages operations...
🍰 [  1 of   2] app-admin/entities::mark                                          - 0.9.3+5         # installed ✔ 
[/usr/lib/go/test/fixedbugs/issue27836.dir/Þfoo.go] Ignoring xattr path not supported by the underlying filesystem: operation not supported
[/usr/lib/go/test/fixedbugs/issue27836.dir/Þmain.go] Ignoring xattr path not supported by the underlying filesystem: operation not supported
🍰 [  2 of   2] dev-lang/go::macaroni-terragon                                    - 1.25.7          # installed ✔ 
🎊 All done.

test-cve / $ emerge openssh copyfail-go --nodeps -j

test-cve / $ useradd -s /bin/bash -m geaaru -g users

test-cve / $ entities list users --filter geaaru
+----------+--------------------+---------+----------+------+--------------+-----------+
| USERNAME | ENCRYPTED PASSWORD | USER ID | GROUP ID | INFO |   HOMEDIR    |   SHELL   |
+----------+--------------------+---------+----------+------+--------------+-----------+
| geaaru   | x                  |    1000 |      100 |      | /home/geaaru | /bin/bash |
+----------+--------------------+---------+----------+------+--------------+-----------+

test-cve / $ /etc/init.d/sshd start
 * Caching service dependencies ...                                                                                                        [ ok ]
ssh-keygen: generating new host keys: RSA ECDSA ED25519 
 * Starting sshd ...

test-cve / $ passwd geaaru
```


The `copyfail-go` could be downloaded from the website, compiled locally or directly
in the container through `emerge`. We use SSH connection with a unprivileged user *geaaru* to test
the exploit.

This is what happens in the container:

```bash
# The container has ip 172.18.10.54
$> ssh geaaru@172.18.10.54
(geaaru@172.18.10.54) Password:

geaaru@test-cve ~ $  copyfail-go --backup /tmp/su-original
2026/05/17 08:10:30 Backup failed: open /bin/su: open /bin/su: permission denied

```

The exploit doesn't work because by default the `/bin/su` binary has 4711 as
file permissions while a lot of distro install it with 4755.

Here, the dimostration: as root (through `incus exec` for example), we
change the permissions of the /bin/su binary with 4755:


```bash
test-cve ~ $ ls -l /bin/su
-rws--x--x 1 root root 45496 Mar 15 19:05 /bin/su
test-cve ~ $ chmod a+r /bin/su
test-cve ~ $
```

and again we try the exploit:

```bash
geaaru@test-cve ~ $ whoami
geaaru
geaaru@test-cve ~ $  copyfail-go --backup /tmp/su-original
2026/05/17 08:10:52 Backed up /bin/su to /tmp/su-original
2026/05/17 08:10:52 Overwriting page cache of /bin/su with 158 bytes
2026/05/17 08:10:52   ... wrote 4 bytes
2026/05/17 08:10:52   ... wrote 104 bytes
2026/05/17 08:10:52   ... wrote 158 bytes
2026/05/17 08:10:52 Executing payload
root@test-cve /home/geaaru $
root@test-cve /home/geaaru $ whoami
root

```

💥 the exploit works and the user has root privileges!

Any setuid-root binary readable by the user works, so the mitigation
needs to be applied to all binary. This is an example of a simple script usable
for non-macaroniOS systems to mitigate the security issue:

```
for bin in passwd chsh chfn mount sudo pkexec; do
  path=$(readlink -f "$(which $bin 2>/dev/null)")
  [ -n "$path" ] && echo "fix $path" && chmod 4711 "$path"
done
```

In conclusion, for `copy-fail` setting 4711 as permission to all suid-root binary mitigate the exploit.

# Dirty frag on Macaroni OS

Following the Page-Cache Write described for the Copy Fail exploit there is 
another security issue that permits root escalation: *Dirty frag*.

Using the same container created before, this is what happens
in our MARK container:

```bash
geaaru@test-cve ~ $ git clone https://github.com/V4bel/dirtyfrag.git
Cloning into 'dirtyfrag'...
remote: Enumerating objects: 64, done.
remote: Counting objects: 100% (37/37), done.
remote: Compressing objects: 100% (23/23), done.
remote: Total 64 (delta 18), reused 20 (delta 14), pack-reused 27 (from 1)
Receiving objects: 100% (64/64), 5.83 MiB | 25.29 MiB/s, done.
Resolving deltas: 100% (23/23), done.

geaaru@test-cve ~ $ cd dirtyfrag && gcc -O0 -Wall -o exp exp.c -lutil

geaaru@test-cve ~/dirtyfrag $ ./exp
dirtyfrag: failed (rc=0)
```

Before describe the reason we suggest to use the mitigation process
already described in Internet:

```bash
$> sh -c "printf 'install esp4 /bin/false\ninstall esp6 /bin/false\ninstall rxrpc /bin/false\n' > /etc/modprobe.d/dirtyfrag.conf; rmmod esp4 esp6 rxrpc 2>/dev/null; true"
```

My special thanks to our developer `cuantar` for this precise description
of the exploit and the analysis that I report.


In the test program there are two exploits:

1) try to poison the page cache version of *su* so that it starts a root shell, by exploiting the suid root.
   This fails on Macaroni due to our o-r permissions on suid root binaries.

2) try to poison the page cache version of `/etc/passwd` to re-write the root entry so that root no longer has a shadow password,
   and make the password blank. It fails on Macaroni because our root line isn't at the top of the file, and the GECOS field doesn't just
   say root like the test program assumes. The `/etc/passwd` is generated by `entities` tool and the root user is created later
   in the `markdev-kit metro` process.
   Related to this, since we use `wheel` group for `su` automatically in our PAM configuration, that's another reason the `/etc/passwd`
   file modification doesn't work on Macaroni.  Even if the attacker succeeds at setting the password for root to be blank, he can't use the
   regular unmodified `su` to switch to it unless he's in wheel group but we're still vulnerable to an attack on a different binary like `df`.

It's important to understand that point 2 is still a problem on Macaroni. A clever attacker with local access can
just tailor the exploit to the target system, instead of hard-coding wrong strings in it.

Although point 1 fails on Macaroni to get root, the attacker could still use the same procedure to modify some other binary,
like `df`, and wait for an admin to log in as root and run it. The exploit allows to change the cached version of a binary into
something else, by replacing the beginning of it with an ELF executable.  Suppose instead of a shell, the executable spawns a child
process that makes an outgoing connection to a server the attacker controls, connects it to a shell, and then disowns the child;
when the admin logs in as root and runs df, a backdoor will be created.

So, we are still vulnerable to point 1 and 2 in the hands of a clever attacker but we have a good temporary mitigation until the
new kernel will be upgraded.


Again, my special thanks to `cuantar` and `coffnix` for monitoring security vulnerabilities and share details.

We hope that these informations will help other distro and OS administrator in their jobs.

# Phoenix - WIP

We are sorry for this long waiting in the new release of Phoenix but we have really tons of upgraded
related to the continue improves done in MARK that requires a lot of testing and fix before been released.

Between the upgrades these some important new features incoming:

    - QT 6.10
    - Gnome 48/49 (an hybrid release that works yet with OpenRC)
    - LXQT 2.3.3
    - KDE 6.22.0

Stay tuned!

Enjoy!


# Thanks

Many thanks to all Developers and Contributors that are the sap of all this and to all
people that helps us with testing and donations.

A [Became a Contributor]({{< relref "/docs/mark/contributors" >}}) section is available in our
website and we hope to have a lot of contributors soon.

<div style="text-align: center; margin-bottom: 20px">

<img src="../../images/macaroni_wait4you.png" width="300">

</div>

We waiting for you in our [Discord Server](https://discord.gg/AMuVCRZEvG)!




# Support Us

Any user that wants to support our work for Macaroni could do this through the
Github [Sponsor](https://github.com/sponsors/geaaru) or through the
[Liberay](https://liberapay.com/geaaru/) page.
