package com.tuarua.firebase {
import com.tuarua.firebase.remoteconfig.RemoteConfigInfo;
import com.tuarua.firebase.remoteconfig.RemoteConfigSettings;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.utils.ByteArray;

public class RemoteConfigANE extends EventDispatcher {
    private static var _remoteConfig:RemoteConfigANE;
    private static const INIT_ERROR_MESSAGE:String = "RemoteConfigANE... use .firestore";
    public static const ONE_DAY:int = 86400;

    public function RemoteConfigANE() {
        if (_remoteConfig) {
            throw new Error(RemoteConfigANEContext.NAME + " use .firestore");
        }
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
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("setConfigSettings", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function setDefaults(value:Object):void {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("setDefaults", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function fetch(cacheExpirationSeconds:int = ONE_DAY):void {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("fetch", cacheExpirationSeconds);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function getBoolean(key:String):Boolean {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("getBoolean", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    public function getByteArray(key:String):ByteArray {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("getByteArray", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as ByteArray;
    }

    public function getDouble(key:String):Number {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("getDouble", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Number;
    }

    public function getLong(key:String):int {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("getLong", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as int;
    }

    public function getString(key:String):String {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("getString", key);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as String;
    }

    public function activateFetched():void {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("activateFetched");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get info():RemoteConfigInfo {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = RemoteConfigANEContext.context.call("getInfo");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as RemoteConfigInfo;
    }

    public function getKeysByPrefix(prefix:String):Vector.<String> {
        if (!_remoteConfig) throw new Error(INIT_ERROR_MESSAGE);
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
