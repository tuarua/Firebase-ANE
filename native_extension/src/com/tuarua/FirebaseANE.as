package com.tuarua {
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public final class FirebaseANE extends EventDispatcher {
    private static var _firebase:FirebaseANE;

    public function FirebaseANE() {
        if (_firebase) {
            throw new Error(FirebaseANEContext.NAME + " use .init");
        }
        if (FirebaseANEContext.context) {
            var theRet:* = FirebaseANEContext.context.call("init");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _firebase = this;
    }

    public static function init():void {
        if (!_firebase) {
            new FirebaseANE();
        }
    }

    public static function get options():FirebaseOptions {
        var theRet:* = FirebaseANEContext.context.call("getOptions");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as FirebaseOptions;
    }

    public static function dispose():void {
        if (FirebaseANEContext.context) {
            FirebaseANEContext.dispose();
        }
    }

}
}
