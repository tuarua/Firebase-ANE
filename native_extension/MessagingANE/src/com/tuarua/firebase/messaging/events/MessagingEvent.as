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
package com.tuarua.firebase.messaging.events {
import com.tuarua.firebase.messaging.RemoteMessage;

import flash.events.Event;

public class MessagingEvent extends Event {
    public static const ON_MESSAGE_RECEIVED:String = "FirebaseMessaging.OnMessageReceived";
    public static const ON_TOKEN_REFRESHED:String = "FirebaseMessaging.OnTokenRefreshed";
    public var remoteMessage:RemoteMessage;
    public var token:String;

    public function MessagingEvent(type:String, remoteMessage:RemoteMessage = null, token:String = null,
                                   bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.remoteMessage = remoteMessage;
        this.token = token;
    }

    public override function clone():Event {
        return new MessagingEvent(type, this.remoteMessage, this.token, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("MessagingEvent", "remoteMessage", "token", "type", "bubbles", "cancelable");
    }
}
}
