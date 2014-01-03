#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/

#commenting out for now, may need to set this up later
#useradd -m -p "archassault" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/bash archassault

# Create the user directory for live session
if [ ! -d /home/archassault ]; then
    mkdir /home/archassault && chown -R archassault:users /home/archassault
else
    continue
fi

# Copy files over to home
cp -aT /etc/skel /home/archassault
chown archassault:users /home/archassault/.*
chmod 755 /home/archassault/.xinitrc
usermod -aG adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel archassault

#add entries for .xinitrc
#sed -i 's/# exec gnome-session/exec gnome-session/' /home/archassault/.xinitrc

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

#start up systemctl processes
#systemctl enable multi-user.target pacman-init.service choose-mirror.service
systemctl disable multi-user.target sshd dhcpcd
systemctl enable graphical.target pacman-init.service choose-mirror.service
systemctl enable slim.service

#disable network interface names
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# set archassault users password to reset at login
#chage -d0 archassault
