#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"


echo $pathtome

PROJECTNAME=FirebaseANE

AIR_SDK="/Users/User/sdks/AIR/AIRSDK_29"
echo $AIR_SDK



#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECTNAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/$PROJECTNAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/android"


echo "Copying Android aars into place"
cp "$pathtome/../../native_library/android/$PROJECTNAME/Firebase/build/outputs/aar/Firebase-release.aar" "$pathtome/platforms/android/Firebase-release.aar"
echo "getting Android jars"
unzip "$pathtome/platforms/android/Firebase-release.aar" "classes.jar" -d "$pathtome/platforms/android"
unzip "$pathtome/platforms/android/Firebase-release.aar" "res/*" -d "$pathtome/platforms/android"
mv "$pathtome/platforms/android/res" "$pathtome/platforms/android/com.tuarua.firebase.$PROJECTNAME-res"



#Run the build command.
echo "Building ANE."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME.ane" "$pathtome/extension_android.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform Android-ARM \
-C "$pathtome/platforms/android" "library.swf" "classes.jar" \
com.tuarua.firebase.$PROJECTNAME-res/. \
-platformoptions "$pathtome/platforms/android/platform.xml" \


#remove the frameworks from sim and device, as not needed any more
rm "$pathtome/platforms/android/classes.jar"
rm "$pathtome/platforms/android/Firebase-release.aar"
rm "$pathtome/platforms/android/library.swf"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"
rm -r "$pathtome/platforms/android/com.tuarua.firebase.$PROJECTNAME-res"

echo "Packaging Google Services values into ANE."
zip "$pathtome/$PROJECTNAME.ane" META-INF/ANE/Android-ARM/com.tuarua.firebase.FirebaseANE-res/values/values.xml

echo "Finished."
