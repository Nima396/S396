#!/bin/bash

nano /etc/locale.gen
locale-gen
read -p "Continues?" ans
if [ $ans == 'y' ]; then
	echo "Clear"
fi

clear	

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
cat /etc/locale.conf

sleep 5
clear

echo "nine" >> /etc/hostname
cat /etc/hostname

sleep 5
clear

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 nine.localdomin nine" >> /etc/hosts
cat /etc/hosts

sleep 7
clear

pacman -S grub efibootmgr networkmanager dialog wpa_supplicant git wget reflector grub-btrfs

pacman -S xf86-video-amdgpu mesa

clear

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
read -p "Continues?" ans
if [ $ans == 'y']; then
	echo "Try another way"
	else
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable
fi

sleep 10

clear

grub-mkconfig -o /boot/grub/grub.cfg

sleep 10
clear

systemctl enable NetworkManager
 
sed -i "s|^MODULES=.*|MODULES=(amdgpu btrfs)|g" /etc/mkinitcpio.conf
sed -i "s|^HOOKS=.*|HOOKS=(base udev autodetect modconf block encrypt filesystem keyboard fsck)|g" /etc/mkinitcpio.conf

mkinitcpio -p linux

sleep 10
clear

blkid

read -p "Please enter UUID: " uuid
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID='$uuid':cryptio root=/dev/mapper/cryptio"|g' /etc/default/grub

echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg



passwd

exit
