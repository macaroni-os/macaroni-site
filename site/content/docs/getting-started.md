---
title: "Getting Started"
type: docs
---

# Getting Started

# Install Macaroni ISO

Choice the right ISO for your requirements from our [Download](https://www.macaronios.org/iso/) page.

## 1.Validate downloaded ISO

After the you have downloaded the ISOs file, I suggest to verify the quality of the download throw
our SHA256 hash:

```shell
$ sha256sum Macaroni-Funtoo-Phoenix-Gnome-23.03.02.iso
8637d8c6ba72f8694aabd631f038473acaadd0fbb8fc9fa7cec7bb0d495f1f54  Macaroni-Funtoo-Phoenix-Gnome-23.03.02.iso

$ cat  Macaroni-Funtoo-Phoenix-Gnome-23.03.02.iso.sha256 
8637d8c6ba72f8694aabd631f038473acaadd0fbb8fc9fa7cec7bb0d495f1f54
```

If the download is correct the hash will be the same.

Until the issue [#7](https://github.com/macaroni-os/macaroni-funtoo/issues/7) will be fixed
you need to compare the sha256 manually.


## 2.Flash your USB drive

To write an ISO there are different tools and ways. My suggestion is to use the wonderful tool
[Balena Etcher](https://etcher.download/) that validate the written bytes before share the result.

**NOTE**: At the moment the `ventoy` USB Solution is not supported.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Balena Etcher](../../images/install/etcher2.png)

</div>

## 3.Check your BIOS

At the moment, the Macaroni ISOs don't support an EFI-signed bootstrap.
So, before bootstrapping your USB drive just check and disable EFI security
check.

Hereinafter is an example of how setup the right options:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![ASUS T300 Bios](../../images/install/bios1.jpg)

</div>

Normally, based on device there are different way to enter on BIOS,
through `F10`, `Canc`, `F2`. You need to check your device manual.

## 4.Boot the ISO


When the Menu is visible could be possible customize boot options with
`E` keyboard button. After push to `E` keyboard button compares in the foot
the default command line options where you can add every kernel options.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![EFI ISO Menu](../../images/install/isomenu-efi.png)

</div>

#### Disable Nouveau driver

By default we prefer using nouveau driver for the NVIDIA cards on bootstrap
our live ISOs. But it's possible that some new cards could be not be
yet supported.

To force the loading of the NVIDIA kernel module you can add this
option:

```
modprobe.blacklist=nouveau
```

#### Enter in the ISO bootstrap shell

If there are issues on bootstrap correctly the Macaroni ISOs you can
enter in the initrd shell and to recover informations about your
system and help us to check what happens.

To enter in the shell before the probing of the ISO squashfs to debug
the probing phase and the switch root command you need to add `shell=1` as
option.

#### ISOLinux bootstrap

The described option at the moment are not available in the ISOLinux
menu visible hereinafter:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Syslinux Menu](../../images/install/isolinux.png)

</div>a

The ISOLinux menu normally is available for not-EFI systems.

## 5. Start Installer

All our ISOs are configured with *Network Manager* by default which is better
integrated with the Calamares installer. You are free to disable and change it
later when the system is installed.

The default user of Macaroni ISO is `macaroni` with password `macaroni`.

#### Server ISO

The Server ISO automatically starts an X server with Calamares without
a Desktop Environment.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Calamares Server](../../images/install/installer-server.png)

</div>

The X server available with the Server ISO is limited. If you don't have
a network with DHCP you can change the `tty` and using `nmtui` to setup
Networking correctly.

#### XFCE ISO

To start the Macaroni Installer click to *Install System* from
*Applications* → *System* → *Install System*.


<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Install System XFCE](../../images/install/xfce-menu-install.png)

</div>

#### Gnome ISO

To start the Macaroni installer you need to enter on Applications dashboard
and search for *install*:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Install System Gnome](../../images/install/install-gnome.png)

</div>

## 6. Follow Installer workflow

#### 6.1 Welcome: Select Language

In this page if the installer detects correctly at least one hard drive
is present the first choice of the user: the select of the language.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Language](../../images/install/installer-language.png)

</div>

At the moment the tested languages are English and Italian but other languages are available.
If you find some problem with the other languages open an issue.

#### 6.2 Location: Select Region and Zone

The second page of the installer permits to configure the Region and the timzone.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Region](../../images/install/installer-region.png)

</div>

Choice the right value from the map and go ahead.

#### 6.3 Keyboard: Select Keyboard Model and Language

The third page of the installer permits to configure the Keyboard Model and the langauge.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Keyboard](../../images/install/installer-keyboard.png)

</div>


#### 6.4 Partitions: Select storage device and Partitions

In this page you need to select the storage device from the menu and choice how the installer will prepare the partitions.

If the selected this is empty the installer will propose only two voices: *Erase disk* and *Manual partitioning*.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Partitions](../../images/install/installer-partitions-erase.png)

</div>

If you try to reinstall Macaroni OS to an existing system and/or replace existing partitions you can select the
voice *Replace a partition*:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Partitions and Replace](../../images/install/installer-replace.png)

</div>

If you are a newbie, my suggestion is to use the self partitioning mode from the Macaroni Installer that automatically
define three main parititions: efi boot (if you are in EFI env), Swap partition and a Root partition for all data.

#### *Encrypt Full Disk*

Macaroni support Encryption of full system, the only partition left in clear is the EFI partition.

To enable the encryption you need to flag *Encrypt system* and write the passphrase as visible in the screenshot hereinafter:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Partition Encrypted](../../images/install/installer-partitions-encrypt.png)

</div>

With the set *Encrypt System* also the *swap* partition will be encrypted. The passphrase will be ask on GRUB before
to print the Menu.

#### *Manual Partitioning*

An expert user could create his custom installation with different partitions, for example, to divide `/var/` from `/`,
etc.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Partitions Manual](../../images/install/installer-parts-manual.png)

</div>

#### *Encrypt Home Partition Only*

Personally, I think that could be a good compromise to have the rootfs without encryption, this takes things easier
on restoring a broken system and instead encrypt the `home` with user data.

This is possible from *Manual Partioning* on creating an encrypted partition.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Partition Home Encrypted](../../images/install/part-home-encrypt.png)

</div>

To this it's only needed after selecting the File System type (in the screenshot *ext4*),
to set the *Encrypt* flag and set the passphrase.

**NOTE: On setup, with a configuration with there are single partitions encrypted you
need to do some manual operations when the installation is completed or at the first boot.
Unfortunately, at the moment the configuration of a single encrypted partition is not
handled correctly and automatically by the Calamares installer. So, these
steps will be described later.**

#### 6.5 Users: Define User and Passwords

It's now time to define the user of your system, write your name and the name of your computer
and choice your password.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Users](../../images/install/installer-users.png)

</div>

Normally, the defined user will be the admin user and the same password will be
used for `root`. If you want a different password for root, you need to disable the
flag related to the option: *Use the same password for the administrator account*.

#### 6.6 Summary: Show configured options

At this point, you are near to starting the installation of your Macaroni OS system.

Just check the selected options before starting the installation.

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Summary](../../images/install/installer-summary.png)

</div>

If all is ok, go ahead with *Install* button.

#### 6.7 Install: The Installation is started

Finally, the Macaroni Installer begins to write your hard drive. The time needed
depends on your hardware and the speed of the hard drive.

#### 6.8 Finish: The Installation is completed

Wohoo! Your Macaroni system is ready!

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Installer Summary](../../images/install/installer_done.png)

</div>

Set the *Restart now* flag to reboot your computer and to start your Macaroni OS.

#### 6.9 The First boot

#### *Full Encrypted Disk*

If you have choice to encrypt the full disk on bootstrap the GRUB will
ask for the passphrase inserted in installation phase before display
the GRUB menu and go ahead with the bootstrap of your system.

Hereinafter, an example of what could be happens:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Grub Password](../../images/install/grub-passphrase.png)

</div>

#### *Complete the setup of Home's encrypted partition*

If you have encrypted only the home partition or any other partition with the
workflow described before to have the installation correctly working you need
to execute few steps.

a. **Retrieve the LUKS filesystem Id**

```shell
# cat /etc/fstab 
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a device; this may
# be used with UUID= as a more robust way to name devices that works even if
# disks are added and removed. See fstab(5).
#
# <file system>             <mount point>  <type>  <options>  <dump>  <pass>
UUID=ABF5-91D0                                        /boot/efi      vfat    defaults,noatime 0 2
UUID=f202c1d1-b131-45f5-8973-8f82cb63d688             /              ext4    defaults,noatime 0 1
/dev/mapper/luks-f1504aa0-2594-4221-b741-7ba315b47de0 /home          ext4    defaults,noatime 0 2
```

In this case the needed value is `f1504aa0-2594-4221-b741-7ba315b47de0`.

b. **Editing the GRUB configuration file `/etc/default/grub` and add this option:**

```
GRUB_CMDLINE_LINUX="rd.luks.uuid=f1504aa0-2594-4221-b741-7ba315b47de0"
```

Where it's used the LUKS filesystem ID with the option `rd.luks.uuid` that
say to `dracut` to manage the prompt on Plymouth for uncrypt the home partition
before start X.

c. **Rebuild the *initramfs* image with `macaronictl`**

```shell
$> macaronictl kernel gi --all --grub 
Creating initrd image /boot/initramfs-vanilla-x86_64-6.1.18-macaroni...DONE
Creating grub config file /boot/grub/grub.cfg...
Generating grub configuration file ...
Found linux image: /boot/kernel-vanilla-x86_64-6.1.18-macaroni
Found initrd image: /boot/initramfs-vanilla-x86_64-6.1.18-macaroni
fgrep: warning: fgrep is obsolescent; using /bin/grep -F
  WARNING: Failed to connect to lvmetad. Falling back to device scanning.
done
```

d. **Reboot your system.**

If all is been configured correctly on bootstrap you will see the Plymouth page
with the prompt where insert the passphrase to mount *home* partition:

<div style="width:60%;display:block;margin-left:auto; margin-right: auto;">

![Grub Password](../../images/install/dracut-boot-enc-home.png)

</div>
