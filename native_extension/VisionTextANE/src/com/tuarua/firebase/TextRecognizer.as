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

import com.tuarua.firebase.vision.TextError;
import com.tuarua.firebase.vision.VisionImage;
import com.tuarua.fre.ANEError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class TextRecognizer {
    internal static const NAME:String = "VisionTextANE";
    private static var _context:ExtensionContext;
    /** @private */
    public static var closures:Dictionary = new Dictionary();
    private static const RECOGNIZED:String = "TextEvent.Recognized";

    /** @private */
    public function TextRecognizer() {
        try {
            _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
            _context.addEventListener(StatusEvent.STATUS, gotEvent);
            _context.call("init");
        } catch (e:Error) {
            trace(e.name);
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
        }
    }

    private function createEventId(listener:Function):String {
        var eventId:String;
        if (listener != null) {
            eventId = _context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    /** @private */
    public static function gotEvent(event:StatusEvent):void {
        var pObj:Object;
        var closure:Function;
        var err:TextError;
        switch (event.level) {
            case "TRACE":
                trace("[" + NAME + "]", event.code);
                break;
            case RECOGNIZED:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new TextError(pObj.error.text, pObj.error.id);
                    }
                    var theRet:* = _context.call("getResults", pObj.eventId);
                    if (theRet is ANEError) {
                        printANEError(theRet as ANEError);
                        return;
                    }
                    closure.call(null, theRet, err);
                    delete closures[pObj.eventId]; // TODO don't delete if we are running camera detection continuously
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /**
     * Detects texts in the given image.
     *
     * @param image The image to use for detecting texts.
     * @param listener Closure to call back on the main queue with texts detected or error.
     */
    public function process(image:VisionImage, listener:Function):void {
        if (!_context) return;
        var theRet:* = _context.call("detect", image, createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** Closes the text detector and release its model resources. */
    public function close():void {
        if (!_context) return;
        _context.call("close");
    }

    /** @private */
    public static function get context():ExtensionContext {
        return _context;
    }

    /** @private */
    private static function printANEError(error:ANEError):void {
        trace("[" + NAME + "] Error: ", error.type, error.errorID, "\n", error.source, "\n", error.getStackTrace());
    }

    /** @private */
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

}
}
