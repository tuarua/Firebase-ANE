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

package com.tuarua {
import com.tuarua.fre.ANEError;
import com.tuarua.onesignal.OSNotificationDisplayType;
import com.tuarua.onesignal.OSPermissionSubscriptionState;

import flash.events.EventDispatcher;

public class OneSignal extends EventDispatcher {
    private static var _shared:OneSignal;

    /** @private */
    public function OneSignal() {
        _shared = this;
    }

    public function init(appId:String, autoPromptLocation:Boolean = false,
                         disableGmsMissingPrompt:Boolean = false,
                         filterOtherGCMReceivers:Boolean = false,
                         unsubscribeWhenNotificationsAreDisabled:Boolean = false,
                         inFocusDisplaying:int = OSNotificationDisplayType.inAppAlert):void {
        if (OneSignalANEContext.context) {
            var ret:* = OneSignalANEContext.context.call("init", appId, autoPromptLocation, disableGmsMissingPrompt,
                    filterOtherGCMReceivers, unsubscribeWhenNotificationsAreDisabled, inFocusDisplaying);
            if (ret is ANEError) throw ret as ANEError;
        }
    }

    /** The ANE instance. */
    public static function shared():OneSignal {
        if (!_shared) {
            new OneSignal();
        }
        return _shared;
    }

    public static function get version():String {
        var ret:* = OneSignalANEContext.context.call("getVersion");
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    public static function get sdkType():String {
        var ret:* = OneSignalANEContext.context.call("getSdkType");
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /** Enable logging to help debug if you run into an issue setting up OneSignal.
     * This selector is static, so you can call it before OneSignal init.
     *
     * @param logLevel Sets the logging level to print to the Android LogCat log or Xcode log.
     * @param visualLevel Sets the logging level to show as alert dialogs.
     *
     * */
    public function setLogLevel(logLevel:int, visualLevel:int):void {
        var ret:* = OneSignalANEContext.context.call("setLogLevel", logLevel, visualLevel);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Setting to control how OneSignal notifications will be shown when one is received while
     * your app is in focus. */
    public function setInFocusDisplaying(type:int):void {
        var ret:* = OneSignalANEContext.context.call("setInFocusDisplaying", type);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * For GDPR users, your application should call this method before initialization of the SDK.
     *
     * <p>If you pass in true, your application will need to call provideConsent(true) before the OneSignal
     * SDK gets fully initialized. Until this happens, you can continue to call methods
     * (such as sendTags()), but nothing will happen.</p>
     */
    public function setRequiresUserPrivacyConsent(value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("setRequiresUserPrivacyConsent", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** If your application is set to require the user's privacy consent, you can provide this consent using this
     * method. Until you call provideUserConsent(true), the SDK will not fully initialize, and will not send
     * any data to OneSignal.*/
    public function consentGranted(value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("consentGranted", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get userProvidedPrivacyConsent():Boolean {
        var ret:* = OneSignalANEContext.context.call("userProvidedPrivacyConsent");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /** Disable or enable location collection (defaults to enabled if your app has location permission).
     * <p>Note: This method must be called before OneSignal init on iOS.</p>*/
    public function setLocationShared(value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("setLocationShared", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Prompts the user for location permissions to allow geotagging from the OneSignal dashboard.
     * This lets you send notifications based on the device's location.
     * See Location-Triggered Notifications for more details.
     * Make sure you add location permissions in your AndroidManifest.xml and/or info.plist.
     * */
    public function promptLocation():void {
        var ret:* = OneSignalANEContext.context.call("promptLocation");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Tag a user based on an app event of your choosing so later you can later create segments to target these users.
     * Use sendTags if you need to set more than one tag on a user at a time.
     *
     * @param key Key of your choosing to create or update
     * @param value Value to set on the key. NOTE: Passing in a blank String deletes the key,
     * you can also call deleteTag or deleteTags.
     */
    public function sendTag(key:String, value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("sendTag", key, value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Tag a user based on an app event of your choosing, so that later you can create segments to target these users.
     *
     * @param json
     */
    public function sendTags(json:String):void {
        var ret:* = OneSignalANEContext.context.call("sendTags", json);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Retrieve a list of tags that have been set on the user from the OneSignal server.
     * Android will provide a cached copy if there is no network connection.
     * @param listener
     */
    public function getTags(listener:Function):void {
        var ret:* = OneSignalANEContext.context.call("getTags", OneSignalANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Deletes a single tag that was previously set on a user with sendTag or sendTags.
     * Use deleteTags if you need to delete more than one.
     *
     * @param key Key to remove
     */
    public function deleteTag(key:String):void {
        var ret:* = OneSignalANEContext.context.call("deleteTag", key);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Deletes one or more tags that were previously set on a user with sendTag or sendTags.
     *
     * @param keys Keys to remove
     */
    public function deleteTags(keys:Vector.<String>):void {
        var ret:* = OneSignalANEContext.context.call("deleteTags", keys);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Set an email for the device to later send emails to this address
     * @param email The email that you want subscribe and associate with the device
     * @param emailAuthHash Generated auth hash from your server to authorize. (Recommended)
     *                      Create and send this hash from your backend to your app after
     *                          the user logs into your app.
     *                      DO NOT generate this from your app!
     *                      Omit this value if you do not have a backend to authenticate the user.
     * @param onSuccess if the update succeeds
     * @param onFailure if the update fails
     *
     */
    public function setEmail(email:String, emailAuthHash:String = null, onSuccess:Function = null, onFailure:Function = null):void {
        var ret:* = OneSignalANEContext.context.call("setEmail", email, emailAuthHash,
                OneSignalANEContext.createCallback(onSuccess), OneSignalANEContext.createCallback(onFailure));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Call when user logs out of their account.
     * This dissociates the device from the email address.
     * This does not effect the subscription status of the email address itself.
     */
    public function logoutEmail():void {
        var ret:* = OneSignalANEContext.context.call("logoutEmail");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Allows you to set an individual trigger key/value pair for in-app message targeting
     */
    public function addTrigger(key:String, value:*):void {
        var ret:* = OneSignalANEContext.context.call("addTrigger", key, value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Allows you to set multiple trigger key/value pairs simultaneously with a Map
     * Triggers are used for targeting in-app messages.
     */
    public function addTriggers(json:String):void {
        var ret:* = OneSignalANEContext.context.call("addTriggers", json);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Removes a single trigger for the given key */
    public function removeTriggerForKey(key:String):void {
        var ret:* = OneSignalANEContext.context.call("removeTriggerForKey", key);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Removes a list/collection of triggers from their keys with a Collection of Strings */
    public function removeTriggersForKeys(keys:Vector.<String>):void {
        var ret:* = OneSignalANEContext.context.call("removeTriggersForKeys", keys);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Returns a single trigger value for the given key (if it exists, otherwise returns null) */
    public function getTriggerValueForKey(key:String):String {
        var ret:* = OneSignalANEContext.context.call("getTriggerValueForKey", key);
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /***
     * Can temporarily pause in-app messaging on this device.
     * Useful if you don't want to interrupt a user while playing a match in a game.
     *
     * @param pause The boolean that pauses/resumes in-app messages
     */
    public function pauseInAppMessages(pause:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("pauseInAppMessages", pause);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Get the current notification and permission state.
     */
    public function getPermissionSubscriptionState():OSPermissionSubscriptionState {
        var ret:* = OneSignalANEContext.context.call("getPermissionSubscriptionState");
        if (ret is ANEError) throw ret as ANEError;
        return ret as OSPermissionSubscriptionState;
    }

    /**
     * The user must first subscribe through the native prompt or app settings. It does not officially
     * subscribe or unsubscribe them from the app settings, it unsubscribes them from receiving push from OneSignal.
     * You can only call this method with false to opt out users from receiving notifications through OneSignal.
     * You can pass true later to opt users back into notifications.
     * @param value
     */
    public function setSubscription(value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("setSubscription", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * If your system assigns unique identifiers to users, it can be to have to also remember their OneSignal
     * Player Id's as well. To make things easier, OneSignal now allows you to set an external_user_id for your users.
     * Simply call this method, pass in your custom user Id (as a string), and from now on when you send a push
     * notification, you can use include_external_user_ids instead of include_player_ids.
     *
     * @param userId
     * @param listener
     */
    public function setExternalUserId(userId:String, listener:Function = null):void {
        var ret:* = OneSignalANEContext.context.call("setExternalUserId", userId,
                OneSignalANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * If your user logs out of your app, and you would like to disassociate their custom User ID
     * rom your system with their OneSignal User ID, you will want to call this method.
     *
     * @param listener
     */
    public function removeExternalUserId(listener:Function = null):void {
        var ret:* = OneSignalANEContext.context.call("removeExternalUserId",
                OneSignalANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Allows you to send notifications from user to user or schedule ones in the future to be delivered
     * to the current device.
     * <p><b>Note:</b> You can only use include_player_ids as a targeting parameter from your app.
     * Other target options such as tags and included_segments require your OneSignal
     * App REST API key which can only be used from your server.</p>
     *
     * @param json Contains notification options, see <a href="https://documentation.onesignal.com/reference#create-notification">OneSignal | Create Notification</a>
     *              POST call for all options.
     * @param onSuccess
     * @param onFailure
     */
    public function postNotification(json:String, onSuccess:Function = null, onFailure:Function = null):void {
        var ret:* = OneSignalANEContext.context.call("postNotification", json,
                OneSignalANEContext.createCallback(onSuccess), OneSignalANEContext.createCallback(onFailure));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Cancels a single OneSignal notification based on its Android notification integer ID.
     * @param id
     */
    public function cancelNotification(id:int):void {
        var ret:* = OneSignalANEContext.context.call("cancelNotification", id);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Removes all OneSignal notifications from the Notification Shade.
     */
    public function clearOneSignalNotifications():void {
        var ret:* = OneSignalANEContext.context.call("clearOneSignalNotifications");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * By default OneSignal always vibrates the device when a notification is displayed unless the
     * device is in a total silent mode.
     * <p>If true(default) - Device will always vibrate unless the device is in silent mode.</p>
     * <p>If false - Device will only vibrate when the device is set on it's vibrate only mode.</p>
     * <p><i>You can link this action to a UI button to give your user a vibration option for your notifications.</i></p>
     * @param value Passing false means that the device will only vibrate lightly when the device is in it's vibrate only mode.
     */
    public function enableVibrate(value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("enableVibrate", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * By default OneSignal plays the system's default notification sound when the
     * device's notification system volume is turned on.
     * <p>If true(default) - Sound plays when receiving notification. Vibrates when device is on vibrate only mode.</p>
     * <p>If false - Only vibrates unless EnableVibrate(false) was set.</p>
     * <p><i>You can link this action to a UI button to give your user a different sound option for your notifications.</i></p>
     * @param value Passing false means that the device will only vibrate unless the device is set to a total silent mode.
     */
    public function enableSound(value:Boolean):void {
        var ret:* = OneSignalANEContext.context.call("enableSound", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (OneSignalANEContext.context) {
            OneSignalANEContext.dispose();
        }
    }
}
}
