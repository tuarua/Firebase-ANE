#!/bin/sh

grn=$'\e[1;32m'
white=$'\e[0m'

#Get the path to the script and trim to get the directory.
pathtome=$0
pathtome="${pathtome%/*}"

echo "Packaging resources into ANE."

pathLen=${#pathtome}

function pack {
    find "$pathtome/META-INF" -iname "*.$1" -type f -print0 | while IFS= read -r -d '' file; do
    filePathLen=${#file}
    subLen=filePathLen-pathLen-1
    subStr=${file:pathLen+1:subLen}
    zip "$pathtome/FirebaseANE.ane" "$subStr"
    done
}

pack 'xml'
pack 'png'
pack 'gif'
pack 'jpg'
pack 'mp3'
pack 'wav'
pack 'mp4'

echo $grn"Finished" $white
