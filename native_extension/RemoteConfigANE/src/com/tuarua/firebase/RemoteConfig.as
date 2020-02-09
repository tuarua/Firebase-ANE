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
import com.tuarua.firebase.remoteconfig.RemoteConfigInfo;
import com.tuarua.firebase.remoteconfig.RemoteConfigSettings;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.utils.ByteArray;

public class RemoteConfig extends EventDispatcher {
    private static var _shared:RemoteConfig;
    public static const ONE_DAY:int = 86400;
    /** @private */
    public function RemoteConfig() {
        if (RemoteConfigANEContext.context) {
            var ret:* = RemoteConfigANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    public static function get shared():RemoteConfig {
        if (!_shared) {
            new RemoteConfig();
        }
        return _shared;
    }

    public function set configSettings(value:RemoteConfigSettings):void {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("setConfigSettings", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Sets config defaults for parameter keys and values in the default namespace config. */
    public function setDefaults(value:Object):void {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("setDefaults", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Fetches Remote Config data and sets a duration that specifies how long config data lasts.
     * Call activateFetched to make fetched data available to your app.
     *
     * @param cacheExpirationSeconds Duration that defines how long fetched config data is available,
     * in seconds. When the config data expires, a new fetch is required.
     */
    public function fetch(cacheExpirationSeconds:int = ONE_DAY):void {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("fetch", cacheExpirationSeconds);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Gets the value as a Boolean. */
    public function getBoolean(key:String):Boolean {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getBoolean", key);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /** Gets the value as a ByteArray.
     * @deprecated */
    public function getByteArray(key:String):ByteArray {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getByteArray", key);
        if (ret is ANEError) throw ret as ANEError;
        return ret as ByteArray;
    }

    /** Gets the value as a Double. */
    public function getDouble(key:String):Number {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getDouble", key);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Number;
    }

    /** Gets the value as a Long. */
    public function getLong(key:String):int {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getLong", key);
        if (ret is ANEError) throw ret as ANEError;
        return ret as int;
    }

    /** Gets the value as a String. */
    public function getString(key:String):String {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getString", key);
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /**
     * Applies Fetched Config data to the Active Config, causing updates to the behavior and appearance of the
     * app to take effect (depending on how config data is used in the app).
     * @return true if there was a Fetched Config, and it was activated, false if no
     * Fetched Config was found, or the Fetched Config was already activated.
     * @deprecated
     */
    public function activateFetched():Boolean {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("activateFetched");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Asynchronously activates the most recently fetched configs, so that the fetched key value pairs take effect.
     */
    public function activate():void {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("activate");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Asynchronously fetches and then activates the fetched configs.
     * If the time elapsed since the last fetch from the Firebase Remote Config backend is more than the default
     * minimum fetch interval, configs are fetched from the backend.
     * After the fetch is complete, the configs are activated so that the fetched key value pairs take effect.
     */
    public function fetchAndActivate():void {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("fetchAndActivate");
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get info():RemoteConfigInfo {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getInfo");
        if (ret is ANEError) throw ret as ANEError;
        return ret as RemoteConfigInfo;
    }

    /** Returns the set of parameter keys that start with the given prefix, from the default namespace
     * in the active config.*/
    public function getKeysByPrefix(prefix:String):Vector.<String> {
        RemoteConfigANEContext.validate();
        var ret:* = RemoteConfigANEContext.context.call("getKeysByPrefix", prefix);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Vector.<String>;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (RemoteConfigANEContext.context) {
            RemoteConfigANEContext.dispose();
        }
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
                                              priority:int = 0, useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        super.removeEventListener(type, listener, useCapture);
    }

}
}
