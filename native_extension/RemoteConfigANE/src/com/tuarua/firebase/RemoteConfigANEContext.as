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
import com.tuarua.firebase.remoteconfig.events.RemoteConfigErrorEvent;
import com.tuarua.firebase.remoteconfig.events.RemoteConfigEvent;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
/** @private */
public class RemoteConfigANEContext {
    internal static const NAME:String = "RemoteConfigANE";
    internal static const TRACE:String = "TRACE";
    private static const INIT_ERROR_MESSAGE:String = NAME + "... use .remoteConfig";
    private static var _context:ExtensionContext;
    private static var _isInited:Boolean = false;
    public function RemoteConfigANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }
        return _context;
    }

    private static function gotEvent(event:StatusEvent):void {
        var argsAsJSON:Object;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case RemoteConfigEvent.FETCH:
                RemoteConfig.shared.dispatchEvent(new RemoteConfigEvent(event.level));
                break;
            case RemoteConfigErrorEvent:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    RemoteConfig.shared.dispatchEvent(new RemoteConfigErrorEvent(event.level, true, false, argsAsJSON.text));
                } catch (e:Error) {
                    trace(event.code, e.message);
                }
                break;
        }
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }


    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }
}
}
