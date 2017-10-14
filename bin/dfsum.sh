#!/bin/bash


_help()
{

echo "
usage: dfsum.sh <schema> <table> <directory>

dfsum.sh creates a file <schema>.<table> in directory ${DUPFILESDB}.
The file contains the checksum and full path of each file in <directory> and subdirectories.
"
}



[ $# -ne 3 ] && {
	_help
	exit 255
}

_fname=${DUPFILESDB}/${1}.${2}
find "${3}" -type f -exec shasum {} \; | sed 's/[[:space:]]\{1,\}/|/' | sort -k 1 -t "|" | tee ${_fname}
echo
wc -l ${_fname}