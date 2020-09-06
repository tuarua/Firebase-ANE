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
public class OSNotificationPayload {
    /** OneSignal notification UUID. */
    public var notificationID:String;
    /** Title text of the notification. */
    public var title:String;
    /** iOS subtitle text of the notification. */
    public var subtitle:String;
    /** Body text of the notification. */
    public var body:String;
    /** Android small icon resource name set on the notification. */
    public var smallIcon:String;
    /** Android large icon set on the notification. */
    public var largeIcon:String;
    /** iOS - Provided key with a value of 1 to indicate that new content is available.
     * Including this key and value means that when your app is launched in the background or resumed
     * application:didReceiveRemoteNotification:fetchCompletionHandler: is called.*/
    public var contentAvailable:uint;
    /** iOS attachments sent as part of the rich notification.*/
    public var attachments:Object;
    /** Android big picture image set on the notification.*/
    public var bigPicture:String;
    /** Accent color shown around small notification icon on Android 5+ devices. ARGB format.*/
    public var smallIconAccentColor:String;
    /** URL to open when opening the notification.*/
    public var launchURL:String;
    /** Sound resource parameter to play when the notification is shown.
     * iOS default set to UILocalNotificationDefaultSoundName.
     * */
    public var sound:String;
    /** Devices that have a notification LED will blink in this color. ARGB format.*/
    public var ledColor:String;
    /** Notifications with this same key will be grouped together as a single summary notification.*/
    public var groupKey:String;
    /** Summary text displayed in the summary notification.*/
    public var groupMessage:String;
    /** Privacy setting for how the notification should be shown on the lockscreen of Android 5+ devices.
     * <br/><br/>
     * 1 (Default) - Public (fully visible)
     * <br/><br/>
     * 0 - Private (Contents are hidden)
     * <br/><br/>
     * -1 - Secret (not shown).*/
    public var lockScreenVisibility:uint;
    /** The Google project number the notification was sent under.*/
    public var fromProjectNumber:String;
    public var collapseId:String;
    public var priority:uint;
    /** Raw JSON payload string received from OneSignal. */
    public var rawPayload:String;
    /** Custom additional data that was sent with the notification.
     * Set on the dashboard under Options > Additional Data or with the 'data' field on the REST API.
     * */
    public var additionalData:Object;
    /** List of action buttons on the notification. */
    public var actionButtons:Vector.<ActionButton> = new Vector.<ActionButton>();

    public var badge:uint;
    public var badgeIncrement:int;
    public var category:String;
    public var mutableContent:Boolean;
    public var templateID:String;
    public var templateName:String;

    public function OSNotificationPayload() {
    }
}
}