package com.tuarua.firebase {
import com.tuarua.firebase.auth.FirebaseUser;
import com.tuarua.fre.ANEError;
import com.tuarua.utils.GUID;

import flash.events.EventDispatcher;

public final class AuthANE extends EventDispatcher {
    private static var _auth:AuthANE;
    private static const INIT_ERROR_MESSAGE:String = "AuthANE... use .auth";

    public function AuthANE() {
        if (_auth) {
            throw new Error(INIT_ERROR_MESSAGE);
        }
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
        if (!_auth) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AuthANEContext.context.call("getCurrentUser");//TODO don't create new object every time in the ANE
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as FirebaseUser;
    }

    public function sendPasswordResetEmail(email:String):void {
        var theRet:* = AuthANEContext.context.call("sendPasswordResetEmail", email);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function createUserWithEmailAndPassword(email:String, password:String):void {
        if (!_auth) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AuthANEContext.context.call("createUserWithEmailAndPassword", email, password);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function signInWithEmailAndPassword(email:String, password:String):void {
        if (!_auth) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AuthANEContext.context.call("signInWithEmailAndPassword", email, password);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function signInWithCustomToken(token:String):void {

    }


    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
                                              priority:int = 0, useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }


    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        super.removeEventListener(type, listener, useCapture);
    }


    public function confirmPasswordReset(code:String, newPassword:String):void {

    }

    public function checkActionCode(code:String):void {

    }

    public function signInAnonymously():void {
        if (!_auth) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AuthANEContext.context.call("signInAnonymously");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }


    public function set languageCode(value:String):void {
        if (!_auth) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AuthANEContext.context.call("setLanguageCode", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }


    public function get languageCode():String {
        var theRet:* = AuthANEContext.context.call("getLanguageCode");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as String;
    }

    // TODO signInWithCredential(AuthCredential credential)

    public function signOut():void {
        var theRet:* = AuthANEContext.context.call("signOut");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public static function dispose():void {
        if (AuthANEContext.context) {
            AuthANEContext.dispose();
        }
    }
}
}
