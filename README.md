Arch Linux
======================

> Romain

--------------------------

Install.sh
=================

```
./install.sh <romain>
```


Installation
------------

**Telecharger l'ISO**


Après avoir telecharger `archlinux-20xx.xx.xx-x86_64.iso` du lien: [https://www.archlinux.org/download/](https://www.archlinux.org/download/).

**Burn l'ISO sur une USB**


Il faut booter depuis le CD/USB. **S'assurer de bien booter en UEFI**

Pour l'install, suivre leur guide [Installation Guide](https://wiki.archlinux.org/index.php/installation_guide).

Si besoin de changer le clavier : 
```
loadkeys fr-latin1.map.gz
```

Etre sûr si nous sommes bien en UEFI :
```
ls /sys/firmware/efi/efivars
```
Si affiche des fichiers, c'est bon !!

**Connexion à internet**

```
ip link
```

Si connexion en wifi, ce referer à ce guide [Iwd Guide](https://wiki.archlinux.org/index.php/Iwd#iwctl)

**Ensuite le partiotionement de disques**

Pour voir les partition :
```
fdisk -l
```
ou
```
lsblk
```

Si déjà partionné, tranquille.

_Si besoin de partionner, utiliser `cfdisk` (simple d'utilisation)._

Si on part du principe que (les tailles sont des exemples, je pense que pour l'efi on peut mettre moins 521MiB?):

|Partition|Nom|Taille|Format|
|----|----|-----|-------|
| /dev/sda1 | pour efi | 1GB | fat32 |
| /dev/sda2 | pour la swap | 2GB | swap |
| /dev/sda3 | pour le system | le reste | ext4 |


Une fois partitionné, on construit les fichiers systeme :
```
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
```


**Monter les systèmes de fichiers**

```
mount /dev/sda3 /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```

**Installation d'Arch**

```
pacstrap /mnt base
```

**Generer le fichier fstab des partitions montées**

```
genfstab -U /mnt >> /mnt/etc/fstab
```

**Chroot dans le systeme** (/mnt)

```
arch-chroot /mnt
```

**Configurer le password root**

```
passwd
```

**Installer GRUB**

```
pacman -Sy grub os-prober efibootmgr
```

```
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

Et maintenant on peut utiliser le script `install.sh`.


**LA FIN**
Après avoir fait toutes ces commandes, il faut quitter le chroot.

Puis unmount les differents /dev/sdax

```
umount -R /mnt
```

Et enfin `shutdown now` ou `reboot`.