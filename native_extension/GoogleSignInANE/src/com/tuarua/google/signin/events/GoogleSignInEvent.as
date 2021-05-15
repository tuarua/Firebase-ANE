/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.google.signin.events {
import com.tuarua.firebase.auth.AuthCredential;
import com.tuarua.firebase.auth.GoogleAuthCredential;
import com.tuarua.firebase.auth.PlayGamesAuthCredential;
import com.tuarua.google.signin.GoogleSignInAccount;

import flash.events.Event;

public class GoogleSignInEvent extends Event {
    public static const SIGN_IN:String = "GoogleSignInEvent.SignIn";
    public static const ERROR:String = "GoogleSignInEvent.Error";
    public var account:GoogleSignInAccount;
    public var credential:AuthCredential;
    public var error:Error;

    public function GoogleSignInEvent(type:String, account:GoogleSignInAccount = null, error:Error = null,
                                      bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.account = account;
        if (account) {
            if (account.idToken) {
                credential = new GoogleAuthCredential(account.idToken, account.accessToken);
            } else if (account.serverAuthCode && account.hasScope("https://www.googleapis.com/auth/games_lite")) {
                credential = new PlayGamesAuthCredential(account.serverAuthCode);
            }
        }
        this.error = error;
    }

    public override function clone():Event {
        return new GoogleSignInEvent(type, this.account, this.error, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("GoogleSignInEvent", "account", "error", "type", "bubbles", "cancelable");
    }
}
}
