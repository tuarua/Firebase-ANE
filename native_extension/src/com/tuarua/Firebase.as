package com.tuarua {
import com.tuarua.firebase.Analytics;
import com.tuarua.firebase.Auth;
import com.tuarua.firebase.Crashlytics;
import com.tuarua.firebase.DynamicLinks;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.Firestore;
import com.tuarua.firebase.Messaging;
import com.tuarua.firebase.RemoteConfig;
import com.tuarua.firebase.Storage;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public final class Firebase extends EventDispatcher {
    private static var _firebase:Firebase;
    /** @private */
    public function Firebase() {
        if (FirebaseANEContext.context) {
            var ret:* = FirebaseANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _firebase = this;
    }

    /** Initialise the ANE */
    public static function init():void {
        if (!_firebase) {
            new Firebase();
        }
    }

    /** Returns the FirebaseFirestore instance. */
    public static function firestore():Firestore {
        return Firestore.shared;
    }

    /** Returns the FirebaseStorage instance. */
    public static function storage():Storage {
        return Storage.shared;
    }

    /** Returns the FirebaseRemoteConfig instance. */
    public static function remoteConfig():RemoteConfig {
        return RemoteConfig.shared;
    }

    /** Returns the FirebaseAuth instance. */
    public static function auth():Auth {
        return Auth.shared;
    }

    /** Returns the FirebaseAnalytics instance. */
    public static function analytics():Analytics {
        return Analytics.shared;
    }

    /** Returns the Crashlytics instance. */
    public static function crashlytics():Crashlytics {
        return Crashlytics.shared;
    }

    /** Returns the FirebaseDynamicLinks instance. */
    public static function dynamicLinks():DynamicLinks {
        return DynamicLinks.shared;
    }

    /** Returns the FirebaseMessaging instance. */
    public static function messaging():Messaging {
        return Messaging.shared;
    }

    public static function get options():FirebaseOptions {
        FirebaseANEContext.validate();
        var ret:* = FirebaseANEContext.context.call("getOptions");
        if (ret is ANEError) throw ret as ANEError;
        return ret as FirebaseOptions;
    }

    /** returns true if the user has the required version of Google Play Services. Always returns true on iOS.*/
    public static function get isGooglePlayServicesAvailable():Boolean {
        FirebaseANEContext.validate();
        var ret:* = FirebaseANEContext.context.call("isGooglePlayServicesAvailable");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (FirebaseANEContext.context) {
            FirebaseANEContext.dispose();
        }
    }

}
}
