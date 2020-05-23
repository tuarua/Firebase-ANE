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

package com.tuarua.onesignal {
/** The notification the user received */
public class OSNotification {
    /** Is app Active.*/
    public var isAppInFocus:Boolean;
    /** Was it displayed to the user. */
    public var shown:Boolean;
    /** Android notification id. Can later be used to dismiss the notification programmatically. */
    public var androidNotificationId:Number;
    public var displayType:uint;
    /** Notification payload received from OneSignal */
    public var payload:OSNotificationPayload;
    /** Will be set if a summary notification is opened.
     * The payload will be the most recent notification received.*/
    public var groupedNotifications:Vector.<OSNotificationPayload> = new Vector.<OSNotificationPayload>();
    public function OSNotification() {
    }
}
}
