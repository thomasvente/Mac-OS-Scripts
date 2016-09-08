#!/bin/bash

# Kickstart ARD
# Enable Remote Management for admin-group

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu
