#!/bin/bash

# This script will set the time zone and time server.

# --------------    edit the variables below this line    ----------------

# Time zone
time_zone="Europe/Amsterdam"

# Time server
time_server="time.apple.com"

# ------------------    do not edit below this line    ------------------

# Override time zone if specified as Parameter 4
if [ -n "$4" ]; then
	time_zone="$4"
fi

# Override tim server if specified as Parameter 4
if [ -n "$5" ]; then
	time_server="$5"
fi

# Set the local time zone
systemsetup -settimezone ${time_zone}

# Set network time server
systemsetup -setnetworktimeserver ${time_server}

# Set using network time server
systemsetup -setusingnetworktime on

# Force update time
ntpdate -u ${time_server}
