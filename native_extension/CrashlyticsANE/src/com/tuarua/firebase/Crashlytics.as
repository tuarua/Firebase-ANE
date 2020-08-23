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
package com.tuarua.firebase {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class Crashlytics extends EventDispatcher {
    private static var _shared:Crashlytics;
    private static var _enabled:Boolean = true;

    public function Crashlytics() {
        if (CrashlyticsANEContext.context) {
            var ret:* = CrashlyticsANEContext.context.call("init", _enabled);
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    /** @private */
    public static function get shared():Crashlytics {
        if (!_shared) {
            new Crashlytics();
        }
        return _shared;
    }

    /**
     *  The easiest way to cause a crash - great for testing!
     */
    public function crash():void {
        CrashlyticsANEContext.validate();
        CrashlyticsANEContext.context.call("crash");
    }

    /**
     *  This method can be used to record a non-fatal error message. Android Only.
     *
     *  @param message The message
     */
    public function log(message:String):void {
        CrashlyticsANEContext.validate();
        var ret:* = CrashlyticsANEContext.context.call("log", message);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     *  This method can be used to record a single exception structure in a report.
     *
     *  @param error The custom Error
     */
    public function recordException(error:Error):void {
        CrashlyticsANEContext.validate();
        var message:String = error.errorID.toString() + ": " + error.message + "\n";
        message += error.getStackTrace();
        var ret:* = CrashlyticsANEContext.context.call("recordException", message);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     *  Specify a user identifier which will be visible in the Crashlytics UI.
     *
     *  Many of our customers have requested the ability to tie crashes to specific end-users of their
     *  application in order to facilitate responses to support requests or permit the ability to reach
     *  out for more information. We allow you to specify up to three separate values for display within
     *  the Crashlytics UI - but please be mindful of your end-user's privacy.
     *
     *  We recommend specifying a user identifier - an arbitrary string that ties an end-user to a record
     *  in your system. This could be a database id, hash, or other value that is meaningless to a
     *  third-party observer but can be indexed and queried by you.
     *
     *  Optionally, you may also specify the end-user's name or username, as well as email address if you
     *  do not have a system that works well with obscured identifiers.
     *
     *  Pursuant to our EULA, this data is transferred securely throughout our system and we will not
     *  disseminate end-user data unless required to by law. That said, if you choose to provide end-user
     *  contact information, we strongly recommend that you disclose this in your application's privacy
     *  policy. Data privacy is of our utmost concern.
     *
     *  @param value An arbitrary user identifier string which ties an end-user to a record in your system.
     */
    public function set userId(value:String):void {
        CrashlyticsANEContext.validate();
        var ret:* = CrashlyticsANEContext.context.call("setUserId", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function setCustomKey(key:String, value:*):void {
        CrashlyticsANEContext.validate();
        var ret:* = CrashlyticsANEContext.context.call("setCustomKey", key, value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function didCrashOnPreviousExecution():Boolean {
        CrashlyticsANEContext.validate();
        var ret:* = CrashlyticsANEContext.context.call("didCrashOnPreviousExecution");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     *  This Boolean enables or disables logging. The default value is true.
     */
    public static function get enabled():Boolean {
        return _enabled;
    }

    public static function set enabled(value:Boolean):void {
        _enabled = value;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (CrashlyticsANEContext.context) {
            CrashlyticsANEContext.dispose();
        }
    }

}
}
