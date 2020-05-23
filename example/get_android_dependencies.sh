#!/bin/sh

AneVersion="0.11.0"
FreKotlinVersion="1.10.0"
PlayerServicesAuthVersion="17.0.0"
PlayerServicesBaseVersion="17.1.0"
SupportV4Version="1.0.0"
AnalyticsVersion="17.3.0"
DynamicLinksVersion="19.1.0"
IidVersion="20.1.5"
StorageVersion="19.1.1"
PerfVersion="19.0.5"
FirestoreVersion="21.4.2"
MessagingVersion="20.1.5"
ConfigVersion="19.1.3"
AuthVersion="19.3.0"
EventBusVersion="3.0.0"
GsonVersion="2.8.6"
OkhttpVersion="2.7.5"
GuavaVersion="28.1-android"
CrashlyticsVersion="2.10.1"

wget -O ../native_extension/ane/FirebaseANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirebaseANE.ane?raw=true
wget -O ../native_extension/AnalyticsANE/ane/AnalyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AnalyticsANE.ane?raw=true
wget -O ../native_extension/AuthANE/ane/AuthANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AuthANE.ane?raw=true
wget -O ../native_extension/DynamicLinksANE/ane/DynamicLinksANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/DynamicLinksANE.ane?raw=true
wget -O ../native_extension/FirestoreANE/ane/FirestoreANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirestoreANE.ane?raw=true
wget -O ../native_extension/MessagingANE/ane/MessagingANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/MessagingANE.ane?raw=true
wget -O ../native_extension/PerformanceANE/ane/PerformanceANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/PerformanceANE.ane?raw=true
wget -O ../native_extension/RemoteConfigANE/ane/RemoteConfigANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/RemoteConfigANE.ane?raw=true
wget -O ../native_extension/StorageANE/ane/StorageANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/StorageANE.ane?raw=true
wget -O ../native_extension/GoogleSignInANE/ane/GoogleSignInANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/GoogleSignInANE.ane?raw=true
wget -O ../native_extension/CrashlyticsANE/ane/CrashlyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/CrashlyticsANE.ane?raw=true

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/org.greenrobot.eventbus-$EventBusVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-$EventBusVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O android_dependencies/com.squareup.okhttp.okhttp-$OkhttpVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.squareup.okhttp.okhttp-$OkhttpVersion.ane?raw=true
wget -O android_dependencies/androidx.legacy.legacy-support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/androidx.cardview.cardview-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.cardview.cardview-$SupportV4Version.ane?raw=true
wget -O android_dependencies/androidx.browser.browser-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.browser.browser-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.guava.guava-$GuavaVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.guava.guava-$GuavaVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-auth-$PlayerServicesAuthVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-auth-$PlayerServicesAuthVersion.ane?raw=true

wget -O android_dependencies/com.crashlytics.sdk.android.crashlytics-$CrashlyticsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.crashlytics.sdk.android.crashlytics-$CrashlyticsVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-analytics-$AnalyticsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-$AnalyticsVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-auth-$AuthVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-auth-$AuthVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-config-$ConfigVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-$ConfigVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-dynamic-links-$DynamicLinksVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-dynamic-links-$DynamicLinksVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-firestore-$FirestoreVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-firestore-$FirestoreVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-$IidVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$IidVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-messaging-$MessagingVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-messaging-$MessagingVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-perf-$PerfVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-perf-$PerfVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-storage-$StorageVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-storage-$StorageVersion.ane?raw=true
