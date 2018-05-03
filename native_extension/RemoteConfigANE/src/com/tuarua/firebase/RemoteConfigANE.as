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

public class RemoteConfigANE extends EventDispatcher {
    private static var _remoteConfig:RemoteConfigANE;

    public static const ONE_DAY:int = 86400;

    public function RemoteConfigANE() {
        if (RemoteConfigANEContext.context) {
            var theRet:* = RemoteConfigANEContext.context.call("init");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _remoteConfig = this;
    }

    public static function get remoteConfig():RemoteConfigANE {
        if (!_remoteConfig) {
            new RemoteConfigANE();
        }
        return _remoteConfig;
    }

    public function set configSettings(value:RemoteConfigSettings):void {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("setConfigSettings", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function setDefaults(value:Object):void {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("setDefaults", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function fetch(cacheExpirationSeconds:int = ONE_DAY):void {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("fetch", cacheExpirationSeconds);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function getBoolean(key:String):Boolean {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getBoolean", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    public function getByteArray(key:String):ByteArray {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getByteArray", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as ByteArray;
    }

    public function getDouble(key:String):Number {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getDouble", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Number;
    }

    public function getLong(key:String):int {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getLong", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as int;
    }

    public function getString(key:String):String {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getString", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as String;
    }

    public function activateFetched():void {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("activateFetched");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get info():RemoteConfigInfo {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getInfo");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as RemoteConfigInfo;
    }

    public function getKeysByPrefix(prefix:String):Vector.<String> {
        RemoteConfigANEContext.validate();
        var theRet:* = RemoteConfigANEContext.context.call("getKeysByPrefix", prefix);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Vector.<String>;
    }

    public static function dispose():void {
        if (RemoteConfigANEContext.context) {
            RemoteConfigANEContext.dispose();
        }
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        super.removeEventListener(type, listener, useCapture);
    }
}
}
