#!/bin/bash

# Script to set the primary language of OS X.

# --------------    edit the variables below this line    ----------------

# Language
primary_language="Nederlands"

# ------------------    do not edit below this line    ------------------

# Override language is specified
if [ -n "$4" ]; then
	primary_language="$4"
fi

# Get position of language
language_number=$(echo q | languagesetup | grep ${primary_language} | cut -c1-2)

# Set language
set_language=$(echo ${language_number} | languagesetup)

exit $?
