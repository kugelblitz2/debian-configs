#!/bin/sh

# This script must be run as root
if [ $(whoami) != "root" ]; then
	echo 'Please run me as root!'
	return
fi

# Copy sources.list
cp /etc/apt/sources.list mist_configs/sources.list
apt update

# Add user configs
USR=poo
echo "Tell me which users' configs you want to save."
read USR

# Copy .config folder
rm -rf dotfiles/dotconfig
mkdir -p dotfiles/dotconfig
for i in /home/$USR/.config/*; do
    cp -R $i dotfiles/dotconfig
done

# Copy other dotfiles
cp /home/$USR/.profile dotfiles/.profile
cp /home/$USR/.bashrc dotfiles/.bashrc
chown -R $USR ./*

# Copy system-wide config files
cp /usr/share/rofi/themes misc_configs/falcon.rasi

echo 'Config saving done!'