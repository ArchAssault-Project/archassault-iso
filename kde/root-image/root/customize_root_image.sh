#!/bin/bash

set -e -u

__arch=$(uname -m)

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# /etc/passwd already has the shell as bash
usermod -s /usr/bin/bash root
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
usermod -aG adm,audio,floppy,video,log,network,rfkill,scanner,storage,optical,power,wheel archassault

#add entries for .xinitrc
#sed -i 's/# exec gnome-session/exec gnome-session/' /home/archassault/.xinitrc

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

#Adding in our pacman.conf
if [[ ${__arch} == i686 ]]; then
      cat <<- _EOF  > /etc/pacman.conf
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -C - -f %u > %o
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
#UseDelta    = 0.7
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
#Color
#TotalDownload
# We cannot check disk space from within a chroot environment
#CheckSpace
#VerbosePkgLists

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have \$repo replaced by the name of the current repo
#   - URLs will have \$arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

#[testing]
#Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

[archassault-testing]
SigLevel = Optional
Server = http://s3-us-west-2.amazonaws.com/archassault/\$repo/os/\$arch

#[archassault]
#SigLevel = Optional
#Server = repo.archassault.org/archassault/\$repo/os/\$arch

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs

_EOF
else
     cat <<- _EOF  > /etc/pacman.conf
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -C - -f %u > %o
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
#UseDelta    = 0.7
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
#Color
#TotalDownload
# We cannot check disk space from within a chroot environment
#CheckSpace
#VerbosePkgLists

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have \$repo replaced by the name of the current repo
#   - URLs will have \$arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

#[testing]
#Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[archassault-testing]
SigLevel = Optional
Server = http://s3-us-west-2.amazonaws.com/archassault/\$repo/os/\$arch

#[archassault]
#SigLevel = Optional
#Server = repo.archassault.org/archassault/\$repo/os/\$arch

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs

_EOF
fi

#start up systemctl processes
systemctl disable multi-user.target sshd dhcpcd
systemctl enable graphical.target pacman-init.service choose-mirror.service
# per https://wiki.archlinux.org/index.php/NetworkManager#KDE4 must enable 'NetworkManager-dispatcher' 'ModemManager' services to keep logs clean
systemctl enable NetworkManager NetworkManager-dispatcher ModemManager

#enable vboxclient
echo "/usr/bin/VBoxClient-all" >> /root/.xinitrc

#disable network interface names
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# set archassault users password to reset at login
#chage -d0 archassault

#speed-up kde per https://wiki.archlinux.org/index.php/Kde#Speed_up_application_startup
mkdir -p --mode=755 /home/archassault/.compose-cache/
chown -R archassault:users /home/archassault/.compose-cache

# To allow root login in KDM do:
sed -ie 's/AllowRootLogin=false/AllowRootLogin=true/' /usr/share/config/kdm/kdmrc
# To change GreeterUID from kdm to root
sed -ie 's/GreeterUID=kdm/GreeterUID=root/' /usr/share/config/kdm/kdmrc
# To set KDM Language to 'en_US'
sed -ie 's|#Language=[[:alnum:]]*_[[:alnum:]]*|Language=en_US|' /usr/share/config/kdm/kdmrc
# To set KDM default Theme to archassault
sed -ie 's|Theme=/usr/share/apps/kdm/themes/elarun|Theme=/usr/share/apps/kdm/themes/archassault|' /usr/share/config/kdm/kdmrc

# Overwrite the default wallpaper of KDE with archassault wallpaper
#cp /usr/share/wallpapers/archassault/archassault-city1.jpg /usr/share/wallpapers/archassault/stripes.png

#set default icons for KDE to oxygen
ln -sf /usr/share/icons/oxygen /usr/share/icons/default.kde4
