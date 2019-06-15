/*
 * Copyright 2019 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.firebase.ml.custom {
import com.tuarua.fre.ANEError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class ModelInterpreterANEContext {
    internal static const NAME:String = "ModelInterpreterANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .firestore";
    internal static const OUTPUT:String = "ModelInterpreterEvent.Result";
    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    public static var closures:Dictionary = new Dictionary();
    public static var closureCallers:Dictionary = new Dictionary();

    private static var pObj:Object;
    public function ModelInterpreterANEContext() {
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

    public static function createEventId(listener:Function, listenerCaller:Object = null):String {
        var eventId:String;
        if (listener != null) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
            if (listenerCaller) {
                closureCallers[eventId] = listenerCaller;
            }
        }
        return eventId;
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:Error;
        var closure:Function;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case OUTPUT:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    var ret:* = null;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new ModelInterpreterError(pObj.error.text, pObj.error.id);
                    } else {
                        ret = pObj.data;
                    }
                    closure.call(null, ret, err);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    public static function dispose():void {
        if (_context == null) return;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }

}
}
