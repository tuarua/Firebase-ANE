$AneVersion = "0.0.7"
$PlayerServicesVersion = "15.0.1"
$SupportV4Version = "27.1.0"
$FirebaseVersion = "16.0.0"
$VisionVersion = "17.0.0"
$KotlinxCoroutinesVersion = "0.0.24"
$EventBusVersion = "3.0.0"
$GsonVersion = "2.8.4"


$currentDir = (Get-Item -Path ".\" -Verbose).FullName
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest -Uri https://github.com/tuarua/FirebaseANE/releases/download/$AneVersion/assets.zip?raw=true -OutFile "$currentDir\assets.zip"

Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/FirebaseANE.ane?raw=true -OutFile "$currentDir\..\native_extension\ane\FirebaseANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/AnalyticsANE.ane?raw=true -OutFile "$currentDir\..\native_extension\AnalyticsANE\ane\AnalyticsANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionFaceANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionFaceANE\ane\VisionFaceANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionBarcodeANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionBarcodeANE\ane\VisionBarcodeANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionANE\ane\VisionANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionTextANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionTextANE\ane\VisionTextANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudTextANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionCloudTextANE\ane\VisionCloudTextANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudDocumentANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionCloudTextANE\ane\VisionCloudDocumentANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLabelANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionLabelANE\ane\VisionLabelANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionCloudLabelANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionCloudLabelANE\ane\VisionCloudLabelANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Firebase-ANE/releases/download/$AneVersion/VisionLandmarkANE.ane?raw=true -OutFile "$currentDir\..\native_extension\VisionLandmarkANE\ane\VisionLandmarkANE.ane"

Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.tuarua.frekotlin.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\org.greenrobot.eventbus-$EventBusVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/org.greenrobot.eventbus-$EventBusVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.code.gson.gson-$GsonVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.android.support.support-v4-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-base-$PlayerServicesVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane?raw=true

Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-analytics-$FirebaseVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-analytics-$FirebaseVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-iid-$FirebaseVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-iid-$FirebaseVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.firebase.firebase-ml-vision-$VisionVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.firebase.firebase-ml-vision-$VisionVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-vision-image-label-15.0.0.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/firebase/com.google.android.gms.play-services-vision-image-label-15.0.0.ane?raw=true
