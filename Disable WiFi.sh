#!/bin/bash

# This script will disable Wi-Fi and Airport

# Detect new network hardware
networksetup -detectnewhardware

# List all network services and read one by one
networksetup -listallnetworkservices | tail -n +2 | while read service
do
	if [[ "${service}" =~ 'AirPort' ]] || [[ "${service}" =~ 'Wi-Fi' ]]
	then
		# Turn off the network interface
		networksetup -setairportpower "${service}" off
		echo -e "networksetup -setairportpower \"${service}\" off"
		# Get port
		port=`networksetup -listallhardwareports | awk "/$service/,/Ethernet Address/" | awk 'NR==2' | cut -d " " -f 2`
		# Set preferences
		/usr/libexec/airportd "${port}" prefs RequireAdminPowerToggle=Yes
	fi
done
