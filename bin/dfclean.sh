#!/bin/bash


_help()
{

echo "
usage: dfclean.sh <schema> 

dfclean.sh deletes all files with name <schmea>.* from directory ${DUPFILESDB}.
"
}



[ $# -ne 1 ] && {
	_help
	exit 255
}

rm -fv ${DUPFILESDB}/${1}.*
