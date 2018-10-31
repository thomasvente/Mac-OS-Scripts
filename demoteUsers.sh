#!/bin/sh

    IFS=$'\n'
        declare -a localusers=($(dscl . list /Users UniqueID | grep -v localadmin | awk '$2 >= 501 && $2 < 1000 {print $1}'))
    unset IFS

    for i in "${localusers[@]}"
        do          
            /usr/sbin/dseditgroup -o edit -d $i -t user admin

        done