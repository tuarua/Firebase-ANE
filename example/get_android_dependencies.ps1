$AneVersion = "0.13.0"
$FreKotlinVersion = "1.40.0"
$PlayerServicesAuthVersion = "18.1.0"
$PlayerServicesBaseVersion = "17.1.0"
$PlayerServicesMeasurementVersion = "17.5.0"
$SupportV4Version = "1.0.0"
$AnalyticsVersion = "17.5.0"
$DynamicLinksVersion = "19.1.0"
$IidVersion="20.2.4"
$FirebaseComponentsVersion="16.0.0"
$StorageVersion="19.1.1"
$PerfVersion = "19.0.8"
$FirestoreVersion = "21.5.0"
$MessagingVersion = "20.2.3"
$ConfigVersion = "19.2.0"
$AuthVersion = "19.3.2"
$EventBusVersion = "3.0.0"
$GsonVersion = "2.8.6"
$OkhttpVersion = "3.12.1"
$GuavaVersion = "28.1-android"
$CrashlyticsVersion = "17.1.1"
$OneSignalVersion = "3.13.2"

$currentDir = (Get-Item -Path ".\" -Verbose).FullName
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirebaseANE.ane?raw=true -OutFile "$currentDir\extensions\FirebaseANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AnalyticsANE.ane?raw=true -OutFile "$currentDir\extensions\AnalyticsANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AuthANE.ane?raw=true -OutFile "$currentDir\extensions\AuthANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/DynamicLinksANE.ane?raw=true -OutFile "$currentDir\extensions\DynamicLinksANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirestoreANE.ane?raw=true -OutFile "$currentDir\extensions\FirestoreANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/MessagingANE.ane?raw=true -OutFile "$currentDir\extensions\MessagingANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/PerformanceANE.ane?raw=true -OutFile "$currentDir\extensions\PerformanceANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/RemoteConfigANE.ane?raw=true -OutFile "$currentDir\extensions\RemoteConfigANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/StorageANE.ane?raw=true -OutFile "$currentDir\extensions\StorageANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/GoogleSignInANE.ane?raw=true -OutFile "$currentDir\extensions\GoogleSignInANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/CrashlyticsANE.ane?raw=true -OutFile "$currentDir\extensions\CrashlyticsANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/OneSignalANE.ane?raw=true -OutFile "$currentDir\extensions\OneSignalANE.ane"

Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.tuarua.frekotlin-$FreKotlinVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\org.greenrobot.eventbus-$EventBusVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-$EventBusVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.code.gson.gson-$GsonVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.squareup.okhttp3.okhttp-$OkhttpVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.squareup.okhttp3.okhttp-$OkhttpVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.guava.guava-$GuavaVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.guava.guava-$GuavaVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\androidx.legacy.legacy-support-v4-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\androidx.cardview.cardview-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.cardview.cardview-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\androidx.browser.browser-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.browser.browser-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-auth-$PlayerServicesAuthVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-auth-$PlayerServicesAuthVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-measurement-$PlayerServicesMeasurementVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-measurement-$PlayerServicesMeasurementVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-components-$FirebaseComponentsVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-components-$FirebaseComponentsVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-analytics-ktx-$AnalyticsVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-ktx-$AnalyticsVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-auth-ktx-$AuthVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-auth-ktx-$AuthVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-config-ktx-$ConfigVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-ktx-$ConfigVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-dynamic-links-ktx-$DynamicLinksVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-dynamic-links-ktx-$DynamicLinksVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-firestore-ktx-$FirestoreVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-firestore-ktx-$FirestoreVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-iid-$IidVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$IidVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-messaging-$MessagingVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-messaging-$MessagingVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-perf-$PerfVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-perf-$PerfVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-storage-ktx-$StorageVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-storage-ktx-$StorageVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-crashlytics-$CrashlyticsVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-crashlytics-$CrashlyticsVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.onesignal.OneSignal-$OneSignalVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.onesignal.OneSignal-$OneSignalVersion.ane?raw=true

