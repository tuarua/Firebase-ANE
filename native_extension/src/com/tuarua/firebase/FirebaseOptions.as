package com.tuarua.firebase {
[RemoteClass(alias="com.tuarua.firebase.FirebaseOptions")]
public class FirebaseOptions {
    /** <p>API key used for authenticating requests from your app.</p> */
    public var apiKey:String;
    /** <p>The bundle ID for the application. Defaults to [[NSBundle mainBundle] bundleID] when not set
     * manually or in a plist.</p> */
    public var bundleId:String;
    /** <p>The OAuth2 client ID for iOS application used to authenticate Google users, for
     * example &#64;12345.apps.googleusercontent.com, used for signing in with Google.</p> */
    public var clientId:String;
    /** <p>The tracking ID for Google Analytics, e.g. &#64;UA-12345678-1, used to configure Google Analytics.</p> */
    public var trackingId:String;
    /** <p>The Project Number from the Google Developer's console, for example 012345678901, used to
     * configure Google Cloud Messaging.</p> */
    public var gcmSenderId:String;
    /** <p>The Google Cloud project ID, e.g. my-project-1234</p> */
    public var projectId:String;
    /** <p>The Android client ID used in Google AppInvite when an iOS app has its Android version,
     * for example &#64;12345.apps.googleusercontent.com.</p> */
    public var androidClientId:String;
    /** <p>The Google App ID that is used to uniquely identify an instance of an app.</p> */
    public var googleAppId:String;
    /** <p>The database root URL, e.g. //abc-xyz-123.firebaseio.com.</p> */
    public var databaseUrl:String;
    /** <p>The URL scheme used to set up Durable Deep Link service.</p> */
    public var deepLinkUrlScheme:String;
    /** <p>The Google Cloud Storage bucket name, e.g. abc-xyz-123.storage.firebase.com.</p> */
    public var storageBucket:String;
    public function FirebaseOptions() {
    }
}
}
