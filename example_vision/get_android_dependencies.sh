#!/bin/sh

AneVersion="0.0.5"
PlayerServicesVersion="15.0.1"
SupportV4Version="27.1.0"
FirebaseVersion="16.0.0"
KotlinxCoroutinesVersion="0.0.24"
EventBusVersion="3.0.0"
GsonVersion="2.8.4"

wget -O ../native_extension/ane/FirebaseANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirebaseANE.ane?raw=true
wget -O ../native_extension/AnalyticsANE/ane/AnalyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AnalyticsANE.ane?raw=true
wget -O ../native_extension/VisionANE/ane/VisionANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionANE.ane?raw=true
wget -O ../native_extension/VisionBarcodeANE/ane/VisionBarcodeANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionBarcodeANE.ane?raw=true
wget -O ../native_extension/VisionFaceANE/ane/VisionFaceANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionFaceANE.ane?raw=true
wget -O ../native_extension/VisionTextANE/ane/VisionTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionTextANE.ane?raw=true
wget -O ../native_extension/VisionCloudTextANE/ane/VisionCloudTextANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudTextANE.ane?raw=true
wget -O ../native_extension/VisionLabelANE/ane/VisionLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLabelANE.ane?raw=true
wget -O ../native_extension/VisionCloudLabelANE/ane/VisionCloudLabelANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudLabelANE.ane?raw=true
wget -O ../native_extension/VisionLandmarkANE/ane/VisionLandmarkANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLandmarkANE.ane?raw=true

wget -O android_dependencies/com.tuarua.frekotlin.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin.ane?raw=true
wget -O android_dependencies/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane?raw=true
wget -O android_dependencies/org.greenrobot.eventbus-$EventBusVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-$EventBusVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O android_dependencies/com.android.support.support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane?raw=true

wget -O android_dependencies/com.google.firebase.firebase-analytics-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-ml-vision-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.com.google.firebase.firebase-ml-model-interpreter-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-model-interpreter-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-vision-image-label-15.0.0.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.android.gms.play-services-vision-image-label-15.0.0.ane?raw=true




