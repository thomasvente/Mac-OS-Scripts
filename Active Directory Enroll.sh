#!/bin/bash
# Enroll to Active Directory with specific settings
#
#
### You must edit these for your specific environment

## Basic AD options
domain="EXAMPLE.COM"            # fully qualified DNS name of Active Directory Domain
udn="ADMIN-USER"                   # username of a privileged network user
password="SUPERSECRETPASSWORD"         # password of a privileged network user
ou="ou=Mac_Workstations,ou=Workstations,dc=example,dc=com"        # Distinguished name of container for the computer

# Advanced AD options
alldomains="enable"             # 'enable' or 'disable' automatic multi-domain authentication
localhome="enable"              # 'enable' or 'disable' force home directory to local drive
protocol="smb"                  # 'afp' or 'smb' change how home is mounted from server
mobile="enable"                # 'enable' or 'disable' mobile account support for offline logon
mobileconfirm="disable"        # 'enable' or 'disable' warn the user that a mobile acct will be created
useuncpath="enable"            # 'enable' or 'disable' use AD SMBHome attribute to determine the home dir
user_shell="/bin/bash"        # e.g., /bin/bash or "none"
preferred="-nopreferred"    # Use the specified server for all Directory lookups and authentication (e.g. "-nopreferred" or "-preferred ad.server.edu")
admingroups=""               # These comma-separated AD groups may administer the machine (e.g. "" or "APPLE\mac admins")
packetsign="allow"            # allow | disable | require
packetencrypt="allow"        # allow | disable | require
passinterval="0"            # number of days
namespace="domain"            # forest | domain

### End of configuration

# Get the local computer's name.
computerid=`/usr/sbin/scutil --get LocalHostName`

# Activate the AD plugin, just to be sure
defaults write /Library/Preferences/DirectoryService/DirectoryService "Active Directory" "Active"
plutil -convert xml1 /Library/Preferences/DirectoryService/DirectoryService.plist

# Bind to AD
VERSION=`/usr/libexec/PlistBuddy -c "Print :ProductVersion" "/System/Library/CoreServices/SystemVersion.plist"`
case "$VERSION" in
    10.[5-6]*)
       dsconfigad -f -a $computerid -domain $domain -u "$udn" -p "$password" -ou "$ou"
        ;;
    10.[7-9]* | 10.10* | 10.11*)
        dsconfigad -force -add $domain -computer $computerid  -username "$udn" -password "$password" -ou "$ou"
        ;;
    *)
        echo "Unsupported version of OS"
        ;;
esac

dsconfigad -alldomains $alldomains -localhome $localhome -protocol $protocol \
    -mobile $mobile -mobileconfirm $mobileconfirm -useuncpath $useuncpath \
    -shell $user_shell $preferred -packetsign $packetsign -packetencrypt $packetencrypt \
    -passinterval $passinterval -namespace $namespace

# Add the AD node to the search path
if [ "$alldomains" = "enable" ]; then
	csp="/Active Directory/All Domains"
else
	csp="/Active Directory/$domain"
fi

dscl /Search -append / CSPSearchPath "$csp"
dscl /Search -create / SearchPolicy dsAttrTypeStandard:CSPSearchPath
dscl /Search/Contacts -append / CSPSearchPath "$csp"
dscl /Search/Contacts -create / SearchPolicy dsAttrTypeStandard:CSPSearchPath

# Restart Directory Service
killall DirectoryService
sleep 2

exit 0
