#!/bin/sh

# This script must be run as root
if [ $(whoami) != "root" ]; then
	echo 'Please run me as root!'
	return
fi

# Copy sources.list
cp mist_configs/sources.list /etc/apt/sources.list
apt update

# Add user configs
USR=poo
while ["$USR" != "kk"]
do:
	echo "Tell me which users you want to set up configs for. Type 'kk' when you're done!"
	read USR

	# Copy .config folder
	mkdir -p /home/$USR/.config/
	for i in dotfiles/dotconfig/*; do
		cp -R $i /home/$USR/.config
	done

	# Copy other dotfiles
	cp dotfiles/.profile /home/$USR/.profile
	cp dotfiles/.bashrc /home/$USR/.bashrc
	chown -R $USR /home/$USR/.config
done

# Copy system-wide config files
cp misc_configs/falcon.rasi /usr/share/rofi/themes

echo 'Config loading done!'