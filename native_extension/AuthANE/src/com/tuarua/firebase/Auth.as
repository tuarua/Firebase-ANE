/*
 * Copyright 2021 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.firebase {
import com.tuarua.firebase.auth.AuthCredential;
import com.tuarua.firebase.auth.FirebaseUser;
import com.tuarua.firebase.auth.OAuthProvider;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public final class Auth extends EventDispatcher {
    private static var _shared:Auth;

    /** @private */
    public function Auth() {
        if (AuthANEContext.context) {
            var ret:* = AuthANEContext.context.call("init");
            if (ret is ANEError) {
                throw ret as ANEError;
            }
        }
        _shared = this;
    }

    /** @private */
    public static function get shared():Auth {
        if (!_shared) {
            new Auth();
        }
        return _shared;
    }

    /** Synchronously gets the cached current user, or null if there is none. */
    public function get currentUser():FirebaseUser {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("getCurrentUser");
        if (ret is ANEError) throw ret as ANEError;
        return ret as FirebaseUser;
    }

    /** Initiates a password reset for the given email address.
     * @param email
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:AuthError):void {
     *
     * }
     * </listing>
     */
    public function sendPasswordResetEmail(email:String, listener:Function = null):void {
        AuthANEContext.validate();
        if (AuthANEContext.isNullOrEmpty(email)) throw ArgumentError("email is null or empty");
        var ret:* = AuthANEContext.context.call("sendPasswordResetEmail", email,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates and, on success, signs in a user with the given email address and password.
     * @param email
     * @param password
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:AuthError):void {
     *
     * }
     * </listing>
     */
    public function createUserWithEmailAndPassword(email:String, password:String, listener:Function = null):void {
        AuthANEContext.validate();
        if (AuthANEContext.isNullOrEmpty(email) || AuthANEContext.isNullOrEmpty(password)) {
            throw ArgumentError("email or password is null or empty");
        }
        var ret:* = AuthANEContext.context.call("createUserWithEmailAndPassword", email, password,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Asynchronously signs in to Firebase with the given Auth token.
     * @param token A self-signed custom auth token.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:AuthError):void {
     *
     * }
     * </listing>
     */
    public function signInWithCustomToken(token:String, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("signInWithCustomToken", token,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Asynchronously creates and becomes an anonymous user.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:AuthError):void {
     *
     * }
     * </listing>
     */
    public function signInAnonymously(listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("signInAnonymously", AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**The current user language code.*/
    public function set languageCode(value:String):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("setLanguageCode", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get languageCode():String {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("getLanguageCode");
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }


    /** Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. a Facebook
     * login Access Token, a Google ID Token/Access Token pair, etc.) and returns additional
     * identity provider data.
     * @param credential
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:AuthError):void {
     *
     * }
     * </listing>
     */
    public function signInWithCredential(credential:AuthCredential, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("signInWithCredential", credential,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    // TODO docs
    public function signInWithProvider(provider:OAuthProvider, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("signInWithProvider", provider,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Starts the phone number authentication flow by sending a verifcation code to the
     * specified phone number.
     *
     * @param phoneNumber The phone number to be verified.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:AuthError):void {
     *
     * }
     * </listing>
     */
    public function verifyPhoneNumber(phoneNumber:String, listener:Function):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("verifyPhoneNumber", phoneNumber,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Signs out the current user.*/
    public function signOut():void {
        var ret:* = AuthANEContext.context.call("signOut");
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (AuthANEContext.context) {
            AuthANEContext.dispose();
        }
    }

}
}
