#!/bin/sh

rm -r ios_dependencies/device
rm -r ios_dependencies/simulator

AneVersion="0.13.0"
FreSwiftVersion="4.5.0"

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/${FreSwiftVersion}/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/${FreSwiftVersion}/AIRSDK_additions.zip
unzip -u -o AIRSDK_additions.zip
rm AIRSDK_additions.zip

wget https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/assets.zip
unzip -u -o assets.zip
rm assets.zip

wget https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget -O extensions/FirebaseANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/FirebaseANE.ane?raw=true
wget -O extensions/AnalyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/AnalyticsANE.ane?raw=true

wget -O extensions/VisionANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionANE.ane?raw=true
wget -O extensions/VisionCloudTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudTextANE.ane?raw=true
wget -O extensions/VisionCloudDocumentANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudDocumentANE.ane?raw=true
wget -O extensions/VisionCloudLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudLabelANE.ane?raw=true
wget -O extensions/VisionLandmarkANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionLandmarkANE.ane?raw=true
wget -O extensions/ModelInterpreterANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/ModelInterpreterANE.ane?raw=true
