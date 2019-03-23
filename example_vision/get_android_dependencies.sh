#!/bin/sh

AneVersion="0.4.0"
PlayerServicesVersion="16.0.1"
SupportV4Version="27.1.0"
AnalyticsVersion="16.0.5"
IidVersion="17.0.4"
VisionVersion="19.0.2"
ImageLabelVersion="17.0.2"
ModelInterpreterVersion="17.0.3"
NaturalLanguageVersion="18.1.1"
FaceModelVersion="17.0.2"
KotlinxCoroutinesVersion="1.0.1"
EventBusVersion="3.0.0"
GsonVersion="2.8.4"
FreSwiftVersion="3.0.0"

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/${FreSwiftVersion}/AIRSDK_patch.zip
unzip -u -o AIRSDK_patch.zip
rm AIRSDK_patch.zip

wget https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/assets.zip
unzip -u -o assets.zip
rm assets.zip

wget -O ../native_extension/ane/FirebaseANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/FirebaseANE.ane?raw=true
wget -O ../native_extension/AnalyticsANE/ane/AnalyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/AnalyticsANE.ane?raw=true
wget -O ../native_extension/VisionANE/ane/VisionANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionANE.ane?raw=true
wget -O ../native_extension/VisionBarcodeANE/ane/VisionBarcodeANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionBarcodeANE.ane?raw=true
wget -O ../native_extension/VisionFaceANE/ane/VisionFaceANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionFaceANE.ane?raw=true
wget -O ../native_extension/VisionTextANE/ane/VisionTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionTextANE.ane?raw=true
wget -O ../native_extension/VisionCloudTextANE/ane/VisionCloudTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudTextANE.ane?raw=true
wget -O ../native_extension/VisionCloudDocumentANE/ane/VisionCloudDocumentANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudDocumentANE.ane?raw=true
wget -O ../native_extension/VisionLabelANE/ane/VisionLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionLabelANE.ane?raw=true
wget -O ../native_extension/VisionCloudLabelANE/ane/VisionCloudLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudLabelANE.ane?raw=true
wget -O ../native_extension/VisionLandmarkANE/ane/VisionLandmarkANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionLandmarkANE.ane?raw=true
wget -O ../native_extension/NaturalLanguageANE/ane/NaturalLanguageANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/NaturalLanguageANE.ane?raw=true
wget -O ../native_extension/ModelInterpreterANE/ane/ModelInterpreterANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/ModelInterpreterANE.ane?raw=true

wget -O android_dependencies/com.tuarua.frekotlin.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin.ane?raw=true
wget -O android_dependencies/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane?raw=true
wget -O android_dependencies/org.greenrobot.eventbus-${EventBusVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-${EventBusVersion}.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-${GsonVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-${GsonVersion}.ane?raw=true
wget -O android_dependencies/com.android.support.support-v4-${SupportV4Version}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-${SupportV4Version}.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-${PlayerServicesVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-${PlayerServicesVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-analytics-${AnalyticsVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-${AnalyticsVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-${IidVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-${IidVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-${VisionVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-${VisionVersion}.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-vision-image-label-${ImageLabelVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.android.gms.play-services-vision-image-label-${ImageLabelVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-natural-language-${NaturalLanguageVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-natural-language-${NaturalLanguageVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-face-model-${FaceModelVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-face-model-${FaceModelVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-model-interpreter-${ModelInterpreterVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-model-interpreter-${ModelInterpreterVersion}.ane?raw=true
