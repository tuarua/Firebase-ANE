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
import flash.events.EventDispatcher;

import com.tuarua.fre.ANEError;

public final class Performance extends EventDispatcher {
    private static var _performance:Performance;
    private static var _isDataCollectionEnabled:Boolean = true;
    private static var _isInstrumentationEnabled:Boolean = true;
    /** @private */
    public function Performance() {
        if (PerformanceANEContext.context) {
            var ret:* = PerformanceANEContext.context.call("init", _isDataCollectionEnabled, _isInstrumentationEnabled);
            if (ret is ANEError) throw ret as ANEError;
        }
        _performance = this;
    }

    public static function init():void {
        if (!_performance) {
            new Performance();
        }
    }

    /**
     * Controls the capture of performance data. When this value is set to NO, none of the performance
     * data will sent to the server. Default is true.
     *
     * This setting is persisted, and is applied on future invocations of your application. Once
     * explicitly set, it overrides any settings in your Info.plist.
     */
    public static function get isDataCollectionEnabled():Boolean {
        return _isDataCollectionEnabled;
    }

    public static function set isDataCollectionEnabled(value:Boolean):void {
        _isDataCollectionEnabled = value;
        if (_performance) {
            var ret:* = PerformanceANEContext.context.call("setIsDataCollectionEnabled", _isDataCollectionEnabled);
            if (ret is ANEError) throw ret as ANEError;
        }
    }

    /**
     * Controls the instrumentation of the app to capture performance data. When this value is set to
     * NO, the app will not be instrumented to collect performance data (in scenarios like app_start,
     * networking monitoring). Default is true.
     *
     * This setting is persisted, and is applied on future invocations of your application. Once
     * explicitly set, it overrides any settings in your Info.plist.
     */
    public static function get isInstrumentationEnabled():Boolean {
        return _isInstrumentationEnabled;
    }

    public static function set isInstrumentationEnabled(value:Boolean):void {
        _isInstrumentationEnabled = value;
        if (_performance) {
            var ret:* = PerformanceANEContext.context.call("setIsInstrumentationEnabled", _isInstrumentationEnabled);
            if (ret is ANEError) throw ret as ANEError;
        }
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (PerformanceANEContext.context) {
            PerformanceANEContext.dispose();
        }
    }
}
}
