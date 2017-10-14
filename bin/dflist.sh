#!/bin/bash

_help()
{

echo "
usage: dflist.sh <schema> 
dflist.sh lists all files with name <schmea>.* in directory ${DUPFILESDB}.

List of available schemas:
"
find ${DUPFILESDB} -type f -exec basename {} \; | cut -f1 -d"." | sort -u
}


[ $# -ne 1 ] && {
	_help
	exit 255
}

find ${DUPFILESDB} -name "${1}.*" -exec basename {} \; | cut -f2 -d"." 

