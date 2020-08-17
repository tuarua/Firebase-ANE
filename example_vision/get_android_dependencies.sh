#!/bin/sh

AneVersion="0.13.0"
FreKotlinVersion="1.10.0"
PlayerServicesBaseVersion="17.1.0"
SupportV4Version="1.0.0"
AnalyticsVersion="17.4.4"
IidVersion="20.2.3"
VisionVersion="24.0.3"
ModelInterpreterVersion="22.0.3"
KotlinxCoroutinesVersion="1.3.5"
EventBusVersion="3.0.0"
GsonVersion="2.8.6"
ConfigVersion="19.2.0"

wget https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/assets.zip
unzip -u -o assets.zip
rm assets.zip

wget -O extensions/FirebaseANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/FirebaseANE.ane?raw=true
wget -O extensions/AnalyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/AnalyticsANE.ane?raw=true
wget -O extensions/VisionANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionANE.ane?raw=true
wget -O extensions/VisionCloudTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudTextANE.ane?raw=true
wget -O extensions/VisionCloudDocumentANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudDocumentANE.ane?raw=true
wget -O extensions/VisionCloudLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionCloudLabelANE.ane?raw=true
wget -O extensions/VisionLandmarkANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/VisionLandmarkANE.ane?raw=true
wget -O extensions/ModelInterpreterANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/${AneVersion}/ModelInterpreterANE.ane?raw=true

wget -O android_dependencies/com.tuarua.frekotlin-${FreKotlinVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-${FreKotlinVersion}.ane?raw=true
wget -O android_dependencies/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane?raw=true
wget -O android_dependencies/org.greenrobot.eventbus-${EventBusVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-${EventBusVersion}.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-${GsonVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-${GsonVersion}.ane?raw=true
wget -O android_dependencies/androidx.legacy.legacy-support-v4-${SupportV4Version}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-${PlayerServicesBaseVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-analytics-${AnalyticsVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-${AnalyticsVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-${IidVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-${IidVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-${VisionVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-${VisionVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-model-interpreter-${ModelInterpreterVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-model-interpreter-${ModelInterpreterVersion}.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-config-$ConfigVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-$ConfigVersion.ane?raw=true
