#!/bin/sh

grn=$'\e[1;32m'
white=$'\e[0m'

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"

echo "Packaging Google Services values into ANE."
zip "$pathtome/FirebaseANE.ane" META-INF/ANE/Android-ARM/com.tuarua.firebase.FirebaseANE-res/values/values.xml
zip "$pathtome/FirebaseANE.ane" META-INF/ANE/Android-x86/com.tuarua.firebase.FirebaseANE-res/values/values.xml

echo $grn"Finished" $white
