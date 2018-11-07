#!/bin/sh

rm -r ios_dependencies/device
rm -r ios_dependencies/simulator

AneVersion="0.0.9"
FreSwiftVersion="2.5.0"

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/AIRSDK_additions.zip
unzip -u -o AIRSDK_additions.zip
rm AIRSDK_additions.zip

wget https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/assets.zip
unzip -u -o assets.zip
rm assets.zip

wget https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget -O ../native_extension/ane/FirebaseANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirebaseANE.ane?raw=true
wget -O ../native_extension/AnalyticsANE/ane/AnalyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AnalyticsANE.ane?raw=true

wget -O ../native_extension/VisionANE/ane/VisionANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionANE.ane?raw=true
wget -O ../native_extension/VisionBarcodeANE/ane/VisionBarcodeANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionBarcodeANE.ane?raw=true
wget -O ../native_extension/VisionFaceANE/ane/VisionFaceANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionFaceANE.ane?raw=true
wget -O ../native_extension/VisionTextANE/ane/VisionTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionTextANE.ane?raw=true
wget -O ../native_extension/VisionCloudTextANE/ane/VisionCloudTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudTextANE.ane?raw=true
wget -O ../native_extension/VisionCloudDocumentANE/ane/VisionCloudDocumentANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudDocumentANE.ane?raw=true
wget -O ../native_extension/VisionLabelANE/ane/VisionLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLabelANE.ane?raw=true
wget -O ../native_extension/VisionCloudLabelANE/ane/VisionCloudLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudLabelANE.ane?raw=true
wget -O ../native_extension/VisionLandmarkANE/ane/VisionLandmarkANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLandmarkANE.ane?raw=true
