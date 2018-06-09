package com.tuarua {
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public final class FirebaseANE extends EventDispatcher {
    private static var _firebase:FirebaseANE;

    /** @private */
    public function FirebaseANE() {
        if (FirebaseANEContext.context) {
            var theRet:* = FirebaseANEContext.context.call("init");
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _firebase = this;
    }

    /** Initialise the ANE */
    public static function init():void {
        if (!_firebase) {
            new FirebaseANE();
        }
    }

    public static function get options():FirebaseOptions {
        FirebaseANEContext.validate();
        var theRet:* = FirebaseANEContext.context.call("getOptions");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as FirebaseOptions;
    }

    /** returns true if the user has the required version of Google Play Services. Always returns true on iOS.*/
    public static function get isGooglePlayServicesAvailable():Boolean {
        FirebaseANEContext.validate();
        var theRet:* = FirebaseANEContext.context.call("isGooglePlayServicesAvailable");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (FirebaseANEContext.context) {
            FirebaseANEContext.dispose();
        }
    }

}
}
