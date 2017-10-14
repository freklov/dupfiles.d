#!/bin/bash


_help()
{

echo "
usage: dfcmd.sh <schema> <command>

dfcmd.sh creates a file <schema>.execute.<cmd>.sh in current working directory. The file contains one command <command> per
file listed in <schema>.DUPLICATES in directory ${DUPFILESDB}.
"
}



[ $# -ne 2 ] && {
	_help
	exit 255
}


sed "s/^/${2} \"/;s/$/\"/" ${DUPFILESDB}/${1}.DUPLICATES | tee ./${1}.execute.$(echo ${2} | cut -f1 -d " ").sh
