#!/bin/bash


_help()
{

echo "
usage: dfcompare.sh <schema> <table1> <table2>

dfcompare.sh compares the files <schema>.<table1> (masters) with <schema>.<table2> (duplicates) in directory ${DUPFILESDB},
and creates a file <schema>.DUPFILES in directory ${DUPFILESDB}. The file <schema>.DUPFILES contains a list with files
that exist in 'duplicates' and in 'masters' and have the same checksum in 'duplicates' and in 'masters'.
"
}



[ $# -ne 3 ] && {
	_help
	exit 255
}

_masters=${DUPFILESDB}/${1}.${2}
_duplicates=${DUPFILESDB}/${1}.${3}
_fname=${DUPFILESDB}/${1}.DUPLICATES

# source: https://stackoverflow.com/questions/6047043/diff-files-comparing-only-first-n-characters-of-each-line

diff --new-line-format='' --old-line-format='' --unchanged-line-format='%dn'$'\n' <(cut -f1 -d "|" ${_duplicates}) <(cut -f1 -d "|" ${_masters}) | (
    lnum=0;
    while read lprint; do
        while [ $lnum -lt $lprint ]; do read line <&3; ((lnum++)); done;
        echo $line;
    done
) 3<${_duplicates} | cut -f2 -d "|" | tee ${_fname}

echo
wc -l ${_fname}