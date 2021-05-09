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
import com.tuarua.firebase.auth.AdditionalUserInfo;
import com.tuarua.firebase.auth.AuthError;
import com.tuarua.firebase.auth.AuthResult;
import com.tuarua.firebase.auth.FirebaseUser;
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class AuthANEContext {
    internal static const NAME:String = "AuthANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .auth";
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    private static var _isInited:Boolean = false;
    private static const EMAIL_UPDATED:String = "AuthEvent.EmailUpdated";
    private static const PASSWORD_UPDATED:String = "AuthEvent.PasswordUpdated";
    private static const PROFILE_UPDATED:String = "AuthEvent.ProfileUpdated";
    private static const SIGN_IN:String = "AuthEvent.SignIn";
    private static const PASSWORD_RESET_EMAIL_SENT:String = "AuthEvent.PasswordResetEmailSent";
    private static const USER_DELETED:String = "AuthEvent.UserDeleted";
    private static const USER_REAUTHENTICATED:String = "AuthEvent.UserReauthenticated";
    private static const USER_CREATED:String = "AuthEvent.UserCreated";
    private static const USER_UNLINKED:String = "AuthEvent.UserUnlinked";
    private static const USER_LINKED:String = "AuthEvent.UserLinked";
    private static const EMAIL_VERIFICATION_SENT:String = "AuthEvent.EmailVerificationSent";
    private static const ID_TOKEN:String = "AuthEvent.OnIdToken";
    private static const PHONE_CODE_SENT:String = "AuthEvent.PhoneCodeSent";
    private static var argsAsJSON:Object;

    public function AuthANEContext() {

    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }
        return _context;
    }

    public static function isNullOrEmpty(value:String):Boolean {
        return value == null || value == "";
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    public static function callCallback(callbackId:String, ...args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:AuthError;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case SIGN_IN:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new AuthError(argsAsJSON.error.text, argsAsJSON.error.id);
                    }
                    var authResult:AuthResult;
                    if (argsAsJSON.data) {
                        authResult = new AuthResult();
                        if (argsAsJSON.data.additionalUserInfo) {
                            authResult.additionalUserInfo = ANEUtils.map(argsAsJSON.data.additionalUserInfo,
                                    AdditionalUserInfo) as AdditionalUserInfo;
                        }
                        var userJSON:Object = argsAsJSON.data.user;
                        if (userJSON) {
                            authResult.user = new FirebaseUser(userJSON.uid,
                                    userJSON.hasOwnProperty("displayName") ? userJSON.displayName : null,
                                    userJSON.hasOwnProperty("email") ? userJSON.email : null, userJSON.isAnonymous,
                                    userJSON.isEmailVerified, userJSON.hasOwnProperty(
                                            "photoUrl") && userJSON.photoUrl != "null" ? userJSON.photoUrl : null,
                                    userJSON.hasOwnProperty("phoneNumber") ? userJSON.phoneNumber : null);
                        }
                    }
                    callCallback(argsAsJSON.callbackId, authResult, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case PASSWORD_RESET_EMAIL_SENT:
            case EMAIL_VERIFICATION_SENT:
            case USER_CREATED:
            case USER_DELETED:
            case USER_REAUTHENTICATED:
            case EMAIL_UPDATED:
            case PASSWORD_UPDATED:
            case PROFILE_UPDATED:
            case USER_UNLINKED:
            case USER_LINKED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new AuthError(argsAsJSON.error.text, argsAsJSON.error.id);
                    }
                    callCallback(argsAsJSON.callbackId, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ID_TOKEN:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var token:String;
                    if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty(
                            "token")) {
                        token = argsAsJSON.data.token;
                    }
                    callCallback(argsAsJSON.callbackId, token);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case PHONE_CODE_SENT:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new AuthError(argsAsJSON.error.text, argsAsJSON.error.id);
                    }
                    var verificationId:String;
                    if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty(
                            "verificationId")) {
                        verificationId = argsAsJSON.data.verificationId;
                    }
                    callCallback(argsAsJSON.callbackId, verificationId, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }

}
}
