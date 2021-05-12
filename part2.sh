#!/bin/bash

# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
yellow="\e[0;33m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

pm="pacman --noconfirm"

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc

echo "it_IT.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=it_IT.UTF-8" >> /etc/locale.conf
echo "KEYMAP=it" >> /etc/vconsole.conf

locale-gen

machine="ArchLinux"
echo "$machine" >> /etc/hostname

printf "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$machine.localdomain\t$machine" >> /etc/hosts

printf "${bold}${green}Input root password...${reset}\n"
passwd

$pm -S grub efibootmgr networkmanager
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "INSTALLATION TERMINATED"

sudo systemctl enable NetworkManager.service

printf "Input username [Default user]: "
read username
username=${username:-"user"}

useradd -m -G wheel -s /bin/bash "$username"
printf "${bold}${green}Input user password...${reset}\n"
passwd "$username"

pacman -S vim nano
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo

mv /root/after_reboot.sh "/home/$username/.bashrc"

$pm -S gnome gnome-extra xorg gdm
sudo systemctl enable gdm
if [ $? != 0 ]
then
    echo "${bold}${red} Failed to install desktop enviroment. Please do this manually!${reset}"
fi

exit
