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

package com.tuarua.firebase.auth {
import com.tuarua.firebase.AuthANEContext;
import com.tuarua.fre.ANEError;

[RemoteClass(alias="com.tuarua.firebase.auth.FirebaseUser")]
public class FirebaseUser {
    private var _email:String;
    private var _displayName:String;
    private var _isAnonymous:Boolean;
    private var _isEmailVerified:Boolean;
    private var _photoUrl:String;
    private var _phoneNumber:String;
    private var _uid:String;

    public function FirebaseUser(uid:String, displayName:String, email:String, isAnonymous:Boolean,
                                 isEmailVerified:Boolean, photoUrl:String, phoneNumber:String) {
        this._uid = uid;
        this._displayName = displayName;
        this._email = email;
        this._isAnonymous = isAnonymous;
        this._isEmailVerified = isEmailVerified;
        this._photoUrl = photoUrl;
        this._phoneNumber = phoneNumber;
    }

    /**
     * Initiates email verification for the user.
     * @param listener Optional
     */
    public function sendEmailVerification(listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("sendEmailVerification", AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Disassociates a user account from a third-party identity provider with this user.
     * @param provider
     * @param listener Optional
     */
    public function unlink(provider:String, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("unlink", provider,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }


    /**
     * Associates a user account from a third-party identity provider with this user and
     * returns additional identity provider data.
     * @param credential
     * @param listener Optional
     */
    public function link(credential:AuthCredential, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("link", credential,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function reauthenticateWithCredential(credential:AuthCredential, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("reauthenticateWithCredential", credential,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function reauthenticateWithProvider(provider:OAuthProvider, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("reauthenticateWithProvider", provider,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Deletes the user account (also signs out the user, if this was the current user).
     * @param listener Optional
     */
    public function remove(listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("deleteUser", AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Reloads the user's profile data from the server.
     * @param listener Optional
     */
    public function reload(listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("reload", AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Retrieves the Firebase authentication token, possibly refreshing it if it has expired.
     * @param forceRefresh Forces a token refresh. Useful if the token becomes invalid for some reason
     * other than an expiration.
     * @param listener
     */
    public function getIdToken(forceRefresh:Boolean, listener:Function):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("getIdToken", forceRefresh, AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Updates the email address for the user. On success, the cached user profile data is
     * updated.
     * @param value
     * @param listener Optional
     */
    public function updateEmail(value:String, listener:Function = null):void {
        AuthANEContext.validate();
        _email = value;
        var ret:* = AuthANEContext.context.call("updateEmail", value, AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Updates the password for the user. On success, the cached user profile data is updated.
     * @param value
     * @param listener Optional
     */
    public function updatePassword(value:String, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("updatePassword", value, AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Updates the profile for the user.
     * @param displayName Optional
     * @param photoUrl Optional
     * @param listener Optional
     */
    public function updateProfile(displayName:String = null, photoUrl:String = null, listener:Function = null):void {
        AuthANEContext.validate();
        var ret:* = AuthANEContext.context.call("updateProfile", displayName, photoUrl,
                AuthANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get email():String {
        return _email;
    }

    public function get uid():String {
        return _uid;
    }

    public function get displayName():String {
        return _displayName;
    }

    public function get isAnonymous():Boolean {
        return _isAnonymous;
    }

    public function get isEmailVerified():Boolean {
        return _isEmailVerified;
    }

    public function get photoUrl():String {
        return _photoUrl;
    }

    public function get phoneNumber():String {
        return _phoneNumber;
    }


}
}