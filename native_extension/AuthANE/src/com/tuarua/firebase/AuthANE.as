package com.tuarua.firebase {
import com.tuarua.firebase.auth.AuthCredential;
import com.tuarua.firebase.auth.FirebaseUser;
import com.tuarua.fre.ANEError;
import flash.events.EventDispatcher;

public final class AuthANE extends EventDispatcher {
    private static var _auth:AuthANE;
    /** @private */
    public function AuthANE() {
        if (AuthANEContext.context) {
            var theRet:* = AuthANEContext.context.call("init");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _auth = this;
    }

    public static function get auth():AuthANE {
        if (!_auth) {
            new AuthANE();
        }
        return _auth;
    }

    public function get currentUser():FirebaseUser {
        AuthANEContext.validate();
        var theRet:* = AuthANEContext.context.call("getCurrentUser");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as FirebaseUser;
    }

    public function sendPasswordResetEmail(email:String, listener:Function = null):void {
        AuthANEContext.validate();
        if (AuthANEContext.isNullOrEmpty(email)) throw ArgumentError("email is null or empty");
        var theRet:* = AuthANEContext.context.call("sendPasswordResetEmail", email, AuthANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function createUserWithEmailAndPassword(email:String, password:String, listener:Function = null):void {
        AuthANEContext.validate();
        if (AuthANEContext.isNullOrEmpty(email) || AuthANEContext.isNullOrEmpty(password)) {
            throw ArgumentError("email or password is null or empty");
        }
        var theRet:* = AuthANEContext.context.call("createUserWithEmailAndPassword", email, password, AuthANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function signInWithCustomToken(token:String):void {
        // TODO
        AuthANEContext.validate();
    }

    /*public function confirmPasswordReset(code:String, newPassword:String):void {

    }

    public function checkActionCode(code:String):void {

    }*/

    public function signInAnonymously(listener:Function = null):void {
        AuthANEContext.validate();
        var theRet:* = AuthANEContext.context.call("signInAnonymously", AuthANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function set languageCode(value:String):void {
        AuthANEContext.validate();
        var theRet:* = AuthANEContext.context.call("setLanguageCode", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get languageCode():String {
        AuthANEContext.validate();
        var theRet:* = AuthANEContext.context.call("getLanguageCode");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as String;
    }

    public function signIn(credential:AuthCredential, listener:Function = null):void {
        AuthANEContext.validate();
        var theRet:* = AuthANEContext.context.call("signIn", credential,
                AuthANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function signOut():void {
        var theRet:* = AuthANEContext.context.call("signOut");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function dispose():void {
        if (AuthANEContext.context) {
            AuthANEContext.dispose();
        }
    }
}
}
