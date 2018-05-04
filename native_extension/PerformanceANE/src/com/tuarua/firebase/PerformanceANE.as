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

public final class PerformanceANE extends EventDispatcher {
    private static var _performance:PerformanceANE;
    private static var _isDataCollectionEnabled:Boolean = true;

    public function PerformanceANE() {
        if (PerformanceANEContext.context) {
            var theRet:* = PerformanceANEContext.context.call("init", _isDataCollectionEnabled);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _performance = this;
    }

    public static function init():void {
        if (!_performance) {
            new PerformanceANE();
        }
    }

    public static function get isDataCollectionEnabled():Boolean {
        return _isDataCollectionEnabled;
    }

    public static function set isDataCollectionEnabled(value:Boolean):void {
        _isDataCollectionEnabled = value;
        if (_performance) {
            var theRet:* = PerformanceANEContext.context.call("setIsDataCollectionEnabled", _isDataCollectionEnabled);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public static function dispose():void {
        if (PerformanceANEContext.context) {
            PerformanceANEContext.dispose();
        }
    }
}
}
