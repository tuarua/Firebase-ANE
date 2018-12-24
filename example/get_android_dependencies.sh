#!/bin/sh

AneVersion="0.2.0"
PlayerServicesVersion="15.0.1"
SupportV4Version="27.1.0"
FirebaseVersion="16.0.0"
StorageVersion="16.0.2"
PerfVersion="15.0.0"
FirestoreVersion="17.0.1"
MessagingVersion="17.0.0"
ConfigVersion="16.0.0"
AuthVersion="16.0.1"
EventBusVersion="3.0.0"
GsonVersion="2.8.4"
OkhttpVersion="2.7.2"
GuavaVersion="20.0"
LifeCycleVersion="1.1.1"
CrashlyticsVersion="2.9.5"

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

wget -O android_dependencies/com.google.firebase.firebase-analytics-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-auth-$AuthVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-auth-$AuthVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-config-$ConfigVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-$ConfigVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-dynamic-links-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-dynamic-links-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-invites-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-invites-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-firestore-$FirestoreVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-firestore-$FirestoreVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-iid-$FirebaseVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$FirebaseVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-messaging-$MessagingVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-messaging-$MessagingVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-perf-$PerfVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-perf-$PerfVersion.ane?raw=true
wget -O android_dependencies/com.google.firebase.firebase-storage-$StorageVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-storage-$StorageVersion.ane?raw=true
