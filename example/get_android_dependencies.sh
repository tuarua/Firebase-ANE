#!/bin/sh

AneVersion="0.6.0"
PlayerServicesVersion="16.0.1"
SupportV4Version="27.1.0"
AnalyticsVersion="16.0.5"
DynamicLinksVersion="16.1.3"
InvitesVersion="16.0.5"
IidVersion="17.0.4"
StorageVersion="16.0.5"
PerfVersion="16.2.1"
FirestoreVersion="18.0.1"
MessagingVersion="17.3.4"
ConfigVersion="16.1.0"
AuthVersion="16.0.5"
EventBusVersion="3.0.0"
GsonVersion="2.8.4"
OkhttpVersion="2.7.5"
GuavaVersion="26.0-android"
LifeCycleVersion="1.1.1"
CrashlyticsVersion="2.9.9"

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
wget -O ../native_extension/InvitesANE/ane/InvitesANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/InvitesANE.ane?raw=true
wget -O ../native_extension/CrashlyticsANE/ane/CrashlyticsANE.ane https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/CrashlyticsANE.ane?raw=true

wget -O android_dependencies/com.tuarua.frekotlin.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin.ane?raw=true
wget -O android_dependencies/org.greenrobot.eventbus-$EventBusVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-$EventBusVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O android_dependencies/com.squareup.okhttp.okhttp-$OkhttpVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.squareup.okhttp.okhttp-$OkhttpVersion.ane?raw=true
wget -O android_dependencies/com.android.support.support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.guava.guava-$GuavaVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.guava.guava-$GuavaVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-auth-$PlayerServicesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-auth-$PlayerServicesVersion.ane?raw=true
wget -O android_dependencies/android.arch.lifecycle.runtime-$LifeCycleVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/android.arch.lifecycle.runtime-$LifeCycleVersion.ane?raw=true
wget -O android_dependencies/com.crashlytics.sdk.android.crashlytics-$CrashlyticsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.crashlytics.sdk.android.crashlytics-$CrashlyticsVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-analytics-$AnalyticsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-$AnalyticsVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-auth-$AuthVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-auth-$AuthVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-config-$ConfigVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-$ConfigVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-dynamic-links-$DynamicLinksVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-dynamic-links-$DynamicLinksVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-invites-$InvitesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-invites-$InvitesVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-firestore-$FirestoreVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-firestore-$FirestoreVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-$IidVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$IidVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-messaging-$MessagingVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-messaging-$MessagingVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-perf-$PerfVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-perf-$PerfVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-storage-$StorageVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-storage-$StorageVersion.ane?raw=true
