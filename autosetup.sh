#!/bin/sh

# This script must be run as root
if [ $(whoami) != "root" ]; then
	echo 'Please run me as root!'
	return
fi


# Installs cli-based packages
echo 'Installing command line packages...'
apt install sudo neofetch build-essential python3 vim smartmontools git alsa-utils rsync zip lolcat python3-pip


# Adds appropriate users to sudoers
export PATH="/usr/sbin:$PATH"
SUDOER=poo
while ["$SUDOER" != "kk"]
do:
	echo "Tell me which users you want to make sudoers. Type 'kk' when you're done!"
	read SUDOER
	adduser $SUDOER sudo
done


# Copy sources.list
cp misc_configs/sources.list /etc/apt/sources.list
apt update


# Attempts to detect missing wifi drivers
WIFI_CHIPSET_MAKER=$(lspci | grep 'Network controller' | awk '{print $4}')
WIFI_DRIVER=poo
case $WIFI_CHIPSET_MAKER in
	Intel)
		WIFI_DRIVER=firmware-iwlwifi
		;;
	Qualcomm)
		WIFI_DRIVER=firmware-atheros
		;;
	Atheros)
		WIFI_DRIVER=firmware-atheros
		;;
	Realtek)
		WIFI_DRIVER=firmware-realtek
		;;
esac

# Installs missing wifi drivers
if [ $WIFI_DRIVER != 'poo' ]; then
	echo '$WIFI_CHIPSET_MAKER wifi chipset found. Install (nonfree) drivers? [y/n]'
	read DRIVER_RESPONSE
	if [ DRIVER_RESPONSE = 'yes'] || [ DRIVER_RESPONSE = 'y' ]; then
		apt install $WIFI_DRIVER
	fi
fi


# Install AMD Ryzen utilities if AMD cpu detected
CPU_VENDOR=$(lscpu | grep Vendor | awk '{print $3}')
if [ $CPU_VENDOR = "AuthenticAMD" ]; then
	apt install zenmonitor wraithmaster
fi


# Installs AMD binary firmware and other utilities if Radeon card detected
GPU_CHIPSET_VENDOR=$(lspci | grep VGA | awk '{print $5}')
if [ $GPU_CHIPSET_VENDOR = "AMD" ]; then
	apt install firmware-amd-graphics
	pip3 install amdgpu-fan
fi


# Copies fonts 
for i in fonts/*; do
	cp -R $i /usr/local/share/fonts
done


# Install wayland-related elements
apt install sway xwayland waybar rofi-wayland x11-xkb-utils x11-apps

# Install GUI apps
apt install firefox kitty slack discord vscode github-desktop imv grim

# Load configs
sh loadconfigs.sh

echo "All done, ready to go!"
