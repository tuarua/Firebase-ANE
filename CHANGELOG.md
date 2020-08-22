### 0.13.0
- AND: Updated to FreKotlin 1.40.0
- iOS: Updated to FreSwift 4.5.0
- AND: Analytics 17.5.0
- AND: Crashlytics 17.1.1
- AND: Firestore 21.5.0
- AND: Remote Config 19.2.0
- AND: Auth 19.3.2
- AND: Play Services Auth 18.1.0
- AND: Performance 19.0.8
- AND: Messaging 20.2.4
- AND: [Auth] - added `auth.signInWithCredential()`
- AND: [Auth] - added `auth.signInWithProvider()`
- AND: [Crashlytics] - now uses `FirebaseCrashlytics` API
- AND: [Vision] - Move Barcode to MLKitANE
- AND: [Vision] - Move Face Detection to MLKitANE
- AND: [Vision] - Move Label Detection to MLKitANE
- AND: [Vision] - Move Text Detection to MLKitANE
- AND: [Vision] - Move Natural Language to MLKitANE

### 0.12.0
- Added OneSignal 

### 0.11.0
- AND: Updated to FreKotlin 1.10.0
- AND: Analytics 17.3.0
- AND: Storage 19.1.1
- AND: Crashlytics 2.10.1
- AND: Firestore 21.4.2
- AND: Dynamic Links 19.1.0
- AND: Remote Config 19.1.3
- AND: Auth 19.3.0
- AND: Performance 19.0.5
- AND: Messaging 20.1.5

### 0.10.0
- Restructure API. See example for full changes.
- AND: Updated to FreKotlin 1.9.5
- iOS: Updated to FreSwift 4.3.0
- iOS: Firebase 6.13.0
- AND: Analytics 17.2.1
- AND: Storage 19.1.0
- AND: Crashlytics 2.10.1
- AND: Vision 24.0.1
- AND: Firestore 21.3.0
- AND: Dynamic Links 19.0.0
- AND: Remote Config 19.0.3
- AND: Auth 17.0.0
- AND: Performance 19.0.2
- AND: Messaging 20.0.1
- AND: Play Services 17.1.0
- AND: Support androidx 1.0.0
- Remove Invites. Now unsupported by Google

### 0.6.0
- Match package structure of official Firebase libraries
- Match name of `CloudLabeler` and `OnDeviceLabeler`
- Android manifest `com.tuarua.firebase.vision.PermissionActivity` is now `com.tuarua.firebase.ml.vision.PermissionActivity`
- AND: Updated to FreKotlin 1.8.0
- Updated to AIR 33 ARM 64bit

### 0.5.0
- Upgraded to AIR 32.0.0.116
- AND: Updated to FreKotlin 1.7.0
- iOS: Updated to FreSwift 3.1.0

### 0.4.0
- iOS: Package Fabrio.io with FirebaseANE as it is required by mulitple frameworks not just Crashlytics. Issue #28

### 0.3.0
- iOS: Firebase 5.18.2
- AND: Firebase Core 16.0.5
- AND: Analytics 16.0.5
- AND: Storage 16.0.5
- AND: Crashlytics 2.9.9
- AND: Vision 19.0.2
- AND: Firestore 18.0.1
- AND: Invites 16.0.5
- AND: Dynamic Links 16.1.3
- AND: Remote Config 16.1.0
- AND: Auth 16.0.5
- AND: Performance 16.2.1
- AND: Messaging 17.3.4
- AND: Play Services 16.0.1
- [Vision]  Added Natural Language from MLKit
- iOS: [Vision] Remove Simulator binaries from ANE. iOS simulator not supported for Vision.
- AND: [Vision] Face model is now packaged with app - See assets/models
- [Messaging] allow custom sounds (via patched adt.jar)
- [Messaging] remove `<service android:name="com.tuarua.firebase.messaging.InstanceIDService"/>`
- [Performance] deprecate `Trace.incrementCounter()`
- [Analytics] deprecate `AnalyticsANE.minimumSessionDuration`
- [Dynamic Links] replace `DynamicLink.dynamicLinkDomain` with `DynamicLink.domainUriPrefix`
- [Vision] `com.tuarua.firebase.vision.Label` is now `com.tuarua.firebase.vision.ImageLabel`
- [Vision] remove `com.tuarua.firebase.vision.CloudLabel`
- [Vision] set correct properties of `FaceDetectorOptions`

### 0.2.0
- iOS: Updated to FreSwift 3.0.0
- AND: Updated to FreKotlin 1.6.0
- Updated to AIR 32
- iOS: Update to Firebase 5.12.0

### 0.1.0
- iOS: Support AIR 32

### 0.0.9
- iOS/AND: Vision: Add `BarcodeDetector.closeCamera()` method
- iOS/AND: Vision: Add `vision.cameraOverlay` to allow buttons and images to be added over the camera view
- iOS: Vision: use `AVCaptureSession.Preset.medium`
- AND: Vision: Convert CameraActivity into Fragment

### 0.0.8
- AND: Vision: Fix dependency script Issue #13
- iOS/AND: Vision: Fix missing `close()` method Issue #12
- iOS/AND: Vision: Remove obsolete options setters Issue #10
- iOS/AND: Vision: `barcodeDetector.isCameraSupported` is now `vision.isCameraSupported`
- iOS/AND: Vision: Fix BarcodeValueType properties scope
- iOS: Vision: `device.isSmoothAutoFocusEnabled = true`
- iOS: Vision: `device.focusMode = .continuousAutoFocus`
- AND: Vision: Align camera `center_vertical`

### 0.0.7
- iOS/AND: Vision Add `close()` method

### 0.0.6
- iOS: Update to Firebase 5.8.0
- AND: Updated to Storage 16.0.2
- AND: Crashlytics 2.9.5
- AND: Vision 17.0.0
- iOS: Crashlytics 3.10.7. Fabric 1.7.11

### 0.0.5
- Invites: Fix error not returning on clicking back
- AND: Updated to FreKotlin 1.5.0
- iOS/AND: Added Vision from MLKit
- iOS/AND: Improve map conversion performance

### 0.0.3
- iOS: Updated to FreSwift 2.5.0
- AND: Updated to FreKotlin 1.4.0

### 0.0.2
Invites and Google Sign In

### 0.0.1  
- initial commit
