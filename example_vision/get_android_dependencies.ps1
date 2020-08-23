$AneVersion = "0.13.0"
$FreKotlinVersion = "1.40.0"
$PlayerServicesBaseVersion = "17.1.0"
$SupportV4Version = "1.0.0"
$AnalyticsVersion = "17.5.0"
$IidVersion = "20.2.3"
$FirebaseComponentsVersion="16.0.0"
$VisionVersion = "24.0.3"
$ModelInterpreterVersion = "22.0.3"
$KotlinxCoroutinesVersion = "1.3.9"
$EventBusVersion = "3.0.0"
$GsonVersion = "2.8.6"
$ConfigVersion="19.2.0"

$currentDir = (Get-Item -Path ".\" -Verbose).FullName
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/assets.zip?raw=true -OutFile "$currentDir\assets.zip"

Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirebaseANE.ane?raw=true -OutFile "$currentDir\extensions\FirebaseANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AnalyticsANE.ane?raw=true -OutFile "$currentDir\extensions\AnalyticsANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionANE.ane?raw=true -OutFile "$currentDir\extensionsVisionANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudTextANE.ane?raw=true -OutFile "$currentDir\extensions\VisionCloudTextANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudDocumentANE.ane?raw=true -OutFile "$currentDir\extensions\VisionCloudDocumentANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudLabelANE.ane?raw=true -OutFile "$currentDir\extensions\VisionCloudLabelANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLandmarkANE.ane?raw=true -OutFile "$currentDir\extensions\VisionLandmarkANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/ModelInterpreterANE.ane?raw=true -OutFile "$currentDir\extensions\ModelInterpreterANE.ane"

Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.tuarua.frekotlin-$FreKotlinVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\org.greenrobot.eventbus-$EventBusVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-$EventBusVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.code.gson.gson-$GsonVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\androidx.legacy.legacy-support-v4-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesBaseVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-components-$FirebaseComponentsVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-components-$FirebaseComponentsVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-analytics-$AnalyticsVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-$AnalyticsVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-iid-$IidVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$IidVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-ml-vision-$VisionVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-$VisionVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-ml-model-interpreter-$ModelInterpreterVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-model-interpreter-$ModelInterpreterVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-config-ktx-$ConfigVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-config-ktx-$ConfigVersion.ane?raw=true