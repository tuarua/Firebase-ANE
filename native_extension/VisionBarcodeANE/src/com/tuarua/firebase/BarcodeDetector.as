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
import com.tuarua.firebase.vision.BarcodeDetectorOptions;
import com.tuarua.firebase.vision.VisionImage;
import com.tuarua.fre.ANEError;

import flash.display.BitmapData;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

[RemoteClass(alias="com.tuarua.firebase.vision.BarcodeDetector")]
public class BarcodeDetector extends EventDispatcher {
    internal static const NAME:String = "VisionBarcodeANE";
    private static var _context:ExtensionContext;
    private var _options:BarcodeDetectorOptions = new BarcodeDetectorOptions();
    public static var closures:Dictionary = new Dictionary();
    private static const DETECTED:String = "BarcodeEvent.Detected";

    public function BarcodeDetector(options:BarcodeDetectorOptions) {
        try {
            if (options) {
                _options = options;
            }
            _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
            _context.addEventListener(StatusEvent.STATUS, gotEvent);
            _context.call("init", _options);
        } catch (e:Error) {
            trace(e.name);
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    private function createEventId(listener:Function):String {
        var eventId:String;
        if (listener != null) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    public function detect(image:VisionImage, listener:Function):void {
        var theRet:* = _context.call("detect", image, createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

//    public function inputFromCamera(listener:Function, mask:BitmapData):void {
//        var theRet:* = _context.call("inputFromCamera", createEventId(listener), mask);
//        if (theRet is ANEError) throw theRet as ANEError;
//    }
//
//    public function closeCamera():void {
//        var theRet:* = _context.call("closeCamera");
//        if (theRet is ANEError) throw theRet as ANEError;
//    }

    /** @private */
    public static function gotEvent(event:StatusEvent):void {
        var pObj:Object;
        var closure:Function;
        var err:BarcodeError;
        switch (event.level) {
            case "TRACE":
                trace("[" + NAME + "]", event.code);
                break;
            case DETECTED:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new BarcodeError(pObj.error.text, pObj.error.id);
                    }
                    var theRet:* = _context.call("getResults", pObj.eventId);
                    if (theRet is ANEError) throw theRet as ANEError;
                    closure.call(null, theRet, err);
                    if (!pObj.continuous) delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /** @private */
    public static function get context():ExtensionContext {
        return _context;
    }

    public static function dispose():void {
        if (!_context) {
            trace("[" + NAME + "] Error. ANE Already in a disposed or failed state...");
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }

    public function set options(options:BarcodeDetectorOptions):void {
        _options = options ? options : new BarcodeDetectorOptions();
    }
}
}
