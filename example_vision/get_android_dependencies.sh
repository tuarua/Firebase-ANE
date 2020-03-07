#!/bin/sh

AneVersion="0.10.0"
FreKotlinVersion="1.9.5"
PlayerServicesBaseVersion="17.1.0"
SupportV4Version="1.0.0"
AnalyticsVersion="17.2.1"
IidVersion="20.0.1"
VisionVersion="24.0.1"
ImageLabelVersion="19.0.0"
ModelInterpreterVersion="22.0.1"
NaturalLanguageVersion="22.0.0"
FaceModelVersion="19.0.0"
BarcodeModelVersion="16.0.2"
KotlinxCoroutinesVersion="1.3.3"
EventBusVersion="3.0.0"
GsonVersion="2.8.6"
ConfigVersion="19.0.3"

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

wget -O android_dependencies/com.tuarua.frekotlin-${FreKotlinVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-${FreKotlinVersion}.ane?raw=true
wget -O android_dependencies/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane?raw=true
wget -O android_dependencies/org.greenrobot.eventbus-${EventBusVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-${EventBusVersion}.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-${GsonVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-${GsonVersion}.ane?raw=true
wget -O android_dependencies/androidx.legacy.legacy-support-v4-${SupportV4Version}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-${PlayerServicesBaseVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-analytics-${AnalyticsVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-${AnalyticsVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-${IidVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-${IidVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-${VisionVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-${VisionVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-image-label-model-${ImageLabelVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-image-label-model-${ImageLabelVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-natural-language-${NaturalLanguageVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-natural-language-${NaturalLanguageVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-face-model-${FaceModelVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-face-model-${FaceModelVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-barcode-model-${BarcodeModelVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-barcode-model-${BarcodeModelVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-model-interpreter-${ModelInterpreterVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-model-interpreter-${ModelInterpreterVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-config-$ConfigVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-$ConfigVersion.ane?raw=true
