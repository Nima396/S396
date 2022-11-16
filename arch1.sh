#!/bin/bash

clear

echo "gdisk"
#n enterx2 +300M ef00 boot
#n "     " +8G 	 8200 swap
#

gdisk /dev/sda

sleep 5 sec

mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2

sleep 5
clear

cryptsetup luksFormat /dev/sda3
cryptsetup luksOpen /dev/sda3 cryptio

mkfs.btrfs /dev/mapper/cryptio

sleep 5
clear

mount /dev/mapper/cryptio /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
cd
umount /mnt

sleep 5

mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptio /mnt
mkdir /mnt/home
mount
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptio /mnt/home
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap -i /mnt base base-devel linux linux-headers linux-firmware git nano intel-ucode btrfs-progs

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt














