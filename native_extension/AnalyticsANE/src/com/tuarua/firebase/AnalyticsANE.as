package com.tuarua.firebase {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class AnalyticsANE extends EventDispatcher {
    private static var _analytics:AnalyticsANE;

    /** @private */
    public function AnalyticsANE() {
        if (AnalyticsANEContext.context) {
            var theRet:* = AnalyticsANEContext.context.call("init");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _analytics = this;
    }

    /** The ANE instance. */
    public static function get analytics():AnalyticsANE {
        if (!_analytics) {
            new AnalyticsANE();
        }
        return _analytics;
    }

    /**
     * @param name <p>The name of the event. Should contain 1 to 40 alphanumeric characters or
     * underscores. The name must start with an alphabetic character. Some event names are
     * reserved.</p>
     * @param params <p>The Object of event parameters. Passing null indicates that the event has
     * no parameters. Parameter names can be up to 40 characters long and must start with an
     * alphabetic character and contain only alphanumeric characters and underscores. Only String
     * and Number parameter types are
     * supported.</p>
     */
    public function logEvent(name:String, params:Object):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("logEvent", name, params);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /** The unique ID for this instance of the application. */
    public function get appInstanceId():String {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("getAppInstanceId");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as String;
    }

    /**
     * Sets whether analytics collection is enabled for this app on this device. This setting is
     * persisted across app sessions. By default it is enabled.
     */
    public function set analyticsCollectionEnabled(value:Boolean):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("setAnalyticsCollectionEnabled", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /**
     * The name of the current screen. Should contain 1 to 100 characters.
     * Set to null to clear the current screen name.
     * */
    public function set currentScreen(screenName:String):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("setCurrentScreen", screenName);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /**
     * Sets the minimum engagement time in seconds required to start a new session. The default value
     * is 10000 milliseconds.
     * @deprecated
     */
    public function set minimumSessionDuration(milliseconds:Number):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("setMinimumSessionDuration", milliseconds);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /**
     * Sets the interval of inactivity in seconds that terminates the current session. The default
     * value is 1800000 milliseconds (30 minutes).
     */
    public function set sessionTimeoutDuration(milliseconds:Number):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("setSessionTimeoutDuration", milliseconds);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /**
     * The user ID to ascribe to the user of this app on this device, which must be
     * non-empty and no more than 256 characters long. Setting userID to null removes the user ID.
     */
    public function set userId(value:String):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("setUserId", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /**
     * @param name <p>The name of the user property to set. Should contain 1 to 24 alphanumeric characters
     * or underscores and must start with an alphabetic character. The "firebase_", "google_", and
     * "ga_" prefixes are reserved and should not be used for user property names.</p>
     * @param value <p>The value of the user property. Values can be up to 36 characters long. Setting the
     * value to null removes the user property.</p>
     */
    public function setUserProperty(name:String, value:String):void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("setUserProperty", name, value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /** Clears all analytics data for this app from the device and resets the app instance id.
     * Android only.*/
    public function resetAnalyticsData():void {
        AnalyticsANEContext.validate();
        var theRet:* = AnalyticsANEContext.context.call("resetAnalyticsData");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (AnalyticsANEContext.context) {
            AnalyticsANEContext.dispose();
        }
    }
}
}
