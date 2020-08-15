/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.label {
import com.tuarua.fre.ANEError;
import com.tuarua.mlkit.vision.common.InputImage;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class ImageLabeler {
    internal static const NAME:String = "LabelANE";
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    private static const RECOGNIZED:String = "LabelEvent.Recognized";

    public function ImageLabeler(options:ImageLabelerOptions) {
        try {
            _context = ExtensionContext.createExtensionContext("com.tuarua.mlkit.vision." + NAME, null);
            _context.addEventListener(StatusEvent.STATUS, gotEvent);
            _context.call("init", options ? options : new ImageLabelerOptions());
        } catch (e:Error) {
            trace(e.name);
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
        }
    }

    private function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    private static function callCallback(callbackId:String, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    /** @private */
    public static function gotEvent(event:StatusEvent):void {
        var argsAsJSON:Object;
        var err:ImageError;
        switch (event.level) {
            case "TRACE":
                trace("[" + NAME + "]", event.code);
                break;
            case RECOGNIZED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new ImageError(argsAsJSON.error.text, argsAsJSON.error.id);
                    }
                    var ret:* = _context.call("getResults", argsAsJSON.callbackId);
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    callCallback(argsAsJSON.callbackId, ret, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /**
     * Detects labels in a given image.
     *
     * @param image The image to use for detecting labels.
     * @param listener Closure to call back on the main queue with labels detected or error.
     */
    public function process(image:InputImage, listener:Function):void {
        var ret:* = _context.call("process", image, createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Closes the label detector and release its model resources. */
    public function close():void {
        if (_context == null) return;
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

    /** @private */
    public function reinit(options:ImageLabelerOptions):void {
        _context.call("init", options ? options : new ImageLabelerOptions());
    }

}
}
