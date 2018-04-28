package com.tuarua.firebase {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class AnalyticsANE extends EventDispatcher {
    private static var _analytics:AnalyticsANE;
    private static const INIT_ERROR_MESSAGE:String = AnalyticsANEContext.NAME + "... use .analytics";

    public function AnalyticsANE() {
        if (_analytics) {
            throw new Error(INIT_ERROR_MESSAGE);
        }
        if (AnalyticsANEContext.context) {
            var theRet:* = AnalyticsANEContext.context.call("init");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _analytics = this;
    }

    public static function get analytics():AnalyticsANE {
        if (!_analytics) {
            new AnalyticsANE();
        }
        return _analytics;
    }

    public function logEvent(name:String, params:Object):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("logEvent", name, params);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set analyticsCollectionEnabled(value:Boolean):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("setAnalyticsCollectionEnabled", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set currentScreen(screenName:String):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("setCurrentScreen", screenName);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set minimumSessionDuration(milliseconds:Number):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("setMinimumSessionDuration", milliseconds);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set sessionTimeoutDuration(milliseconds:Number):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("setSessionTimeoutDuration", milliseconds);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set userId(value:String):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("setUserId", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function setUserProperty(name:String, value:String):void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("setUserProperty", name, value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function resetAnalyticsData():void {
        if (!_analytics) throw new Error(INIT_ERROR_MESSAGE);
        var theRet:* = AnalyticsANEContext.context.call("resetAnalyticsData");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public static function dispose():void {
        if (AnalyticsANEContext.context) {
            AnalyticsANEContext.dispose();
        }
    }
}
}
