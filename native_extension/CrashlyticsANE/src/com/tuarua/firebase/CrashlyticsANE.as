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
import flash.system.Capabilities;

public class CrashlyticsANE extends EventDispatcher {
    private static var _crashlytics:CrashlyticsANE;
    private static var _debug:Boolean = false;

    public function CrashlyticsANE() {
        if (CrashlyticsANEContext.context) {
            var theRet:* = CrashlyticsANEContext.context.call("init", _debug);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _crashlytics = this;
    }

    /** The ANE instance. */
    public static function get crashlytics():CrashlyticsANE {
        if (!_crashlytics) {
            new CrashlyticsANE();
        }
        return _crashlytics;
    }

    public function crash():void {
        CrashlyticsANEContext.validate();
        CrashlyticsANEContext.context.call("crash");
    }

    public function log(message:String):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("log", message);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function logException(error: Error):void {
        CrashlyticsANEContext.validate();
        var message:String = error.errorID.toString() + ": " + error.message + "\n";
        message += error.getStackTrace();
        var theRet:* = CrashlyticsANEContext.context.call("logException", message);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function set userIdentifier(value:String):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setUserIdentifier", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function set userEmail(value:String):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setUserEmail", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function setString(key:String, value:String):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setString", key, value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function setBool(key:String, value:Boolean):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setBool", key, value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function setDouble(key:String, value:Number):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setDouble", key, value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function setInt(key:String, value:int):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setInt", key, value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function set userName(value:String):void {
        CrashlyticsANEContext.validate();
        var theRet:* = CrashlyticsANEContext.context.call("setUserName", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function get debug():Boolean {
        return _debug;
    }

    public static function set debug(value:Boolean):void {
        _debug = value;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (CrashlyticsANEContext.context) {
            CrashlyticsANEContext.dispose();
        }
    }

}
}
