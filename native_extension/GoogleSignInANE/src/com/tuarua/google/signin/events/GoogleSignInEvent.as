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
import com.tuarua.firebase.auth.GoogleAuthCredential;

import flash.events.Event;

public class GoogleSignInEvent extends Event {
    public static const SIGN_IN:String = "GoogleSignInEvent.SignIn";
    public static const ERROR:String = "GoogleSignInEvent.Error";
    public var credential:GoogleAuthCredential;
    public var error:Error;

    public function GoogleSignInEvent(type:String, credential:GoogleAuthCredential = null, error:Error = null,
                                      bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.credential = credential;
        this.error = error;
    }

    public override function clone():Event {
        return new GoogleSignInEvent(type, this.credential, this.error, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("MessagingEvent", "credential", "error", "type", "bubbles", "cancelable");
    }
}
}
