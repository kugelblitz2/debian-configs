initwifi(){
	WIFI_DEVICE=$(ip link | grep 'wlp' | awk '{print substr($2, 1, length($2)-1)}')
	WIFI_DIRECTORY=$HOME/.wifis
	
	if [ ! -d "$WIFI_DIRECTORY" ]; then mkdir $WIFI_DIRECTORY; fi
	HAS_CONFIG=$(cat /etc/network/interfaces | grep $WIFI_DIRECTORY)
	if [ -z $HAS_CONFIG ]; then
		echo "" >> /etc/network/interfaces
		echo "" >> /etc/network/interfaces
		echo "source $WIFI_DIRECTORY/currentnetwork" >> /etc/network/interfaces
		echo "done"
	else
		echo "config already exits, doing nothing"
	fi
}

addwifi(){
	echo 'Adding connection to $WIFI-DEVICE'
	WIFI_DEVICE=$(ip link | grep 'wlp' | awk '{print substr($2, 1, length($2)-1)}')
	WIFI_DIRECTORY=$HOME/.wifis
	
	if [ ! -d "$WIFI_DIRECTORY" ]; then mkdir $WIFI_DIRECTORY; fi

	SSID=POO
	echo 'Enter SSID'
	read SSID
	
	if [ -e "$WIFI_DIRECTORY/$SSID" ]; then echo 'This network already exists. Continuing will overwrite it. Press [Ctrl+C] now to cancel.'; fi 

	PSK=POO
	echo 'Enter Password'
	read PSK

	# writes wifi configs
	if [ -e "$WIFI_DIRECTORY/$SSID" ]; then rm $WIFI_DIRECTORY/$SSID; fi
	touch $WIFI_DIRECTORY/$SSID
	echo "allow-hotplug $WIFI_DEVICE" >> $WIFI_DIRECTORY/$SSID
	echo "iface $WIFI_DEVICE inet dhcp" >> $WIFI_DIRECTORY/$SSID
	echo "wpa-ssid: $SSID" >> $WIFI_DIRECTORY/$SSID
	echo "wpa-psk: $PSK" >> $WIFI_DIRECTORY/$SSID


	if [ -e "$WIFI_DIRECTORY/currentnetwork" ]; then rm $WIFI_DIRECTORY/currentnetwork; fi
	cp $WIFI_DIRECTORY/$SSID $WIFI_DIRECTORY/currentnetwork

	echo 'Restarting the wifi, this might take a few seconds'
	ifdown $WIFI_DEVICE
	ifup $WIFI_DEVICE
}

clearwifi(){
	WIFI_DEVICE=$(ip link | grep 'wlp' | awk '{print substr($2, 1, length($2)-1)}')
	WIFI_DIRECTORY=$HOME/.wifis
	
	ifdown $WIFI_DEVICE
	if [ -d "$WIFI_DIRECTORY" ]; then rm -rf $WIFI_DIRECTORY; echo 'wifi configs cleared'; else echo 'no wifi configs to clear'; fi
}

resetwifi(){
	WIFI_DEVICE=$(ip link | grep 'wlp' | awk '{print substr($2, 1, length($2)-1)}')
	WIFI_DIRECTORY=$HOME/.wifis

	ifdown $WIFI_DEVICE
	ifup $WIFI_DEVICE
}

help(){
	echo "Please run this script as root or sudo"
	echo "initwifi - initialize this wifi script; don't use unless running this script for the first time"
	echo "addwifi - add a wifi network"i
	echo "clearwifi - clears saved wifi networks"
	echo "resetwifi - turns wifi off and on again"
}


"$@"
