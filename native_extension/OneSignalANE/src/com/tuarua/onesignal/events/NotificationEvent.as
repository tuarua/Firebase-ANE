/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.onesignal.events {
import com.tuarua.onesignal.OSNotification;
import com.tuarua.onesignal.OSNotificationOpenResult;

import flash.events.Event;

public class NotificationEvent extends Event {
    public static const OPENED:String = "NotificationEvent.Opened";
    public static const RECEIVED:String = "NotificationEvent.Received";
    public var result:OSNotificationOpenResult;
    public var notification:OSNotification;

    public function NotificationEvent(type:String, result:OSNotificationOpenResult = null,
                                      notification:OSNotification = null,
                                      bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.result = result;
        this.notification = notification;
    }

    public override function clone():Event {
        return new NotificationEvent(type, this.result, this.notification, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("NotificationEvent", "userId", "registrationId", "type", "bubbles", "cancelable");
    }
}
}
