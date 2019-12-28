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

package com.tuarua.firebase.ml.vision.face {
import com.tuarua.firebase.ml.vision.common.VisionImage;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class FaceDetector extends EventDispatcher {
    internal static const NAME:String = "VisionFaceANE";
    private static var _context:ExtensionContext;
    /** @private */
    public static var callbacks:Dictionary = new Dictionary();
    private static const DETECTED:String = "FaceEvent.Detected";

    /** @private */
    public function FaceDetector(options:FaceDetectorOptions) {
        try {
            _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
            _context.addEventListener(StatusEvent.STATUS, gotEvent);
            _context.call("init", options ? options : new FaceDetectorOptions());
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

    /**
     * Detects faces in a given image.
     *
     * @param image The image to use for detecting faces.
     * @param listener Closure to call back on the main queue with faces detected or error.
     */
    public function detect(image:VisionImage, listener:Function):void {
        var ret:* = _context.call("detect", image, createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Closes the face detector and release its model resources. */
    public function close():void {
        if (_context == null) return;
        _context.call("close");
    }

    /** @private */
    public static function gotEvent(event:StatusEvent):void {
        var argsAsJSON:Object;
        var err:FaceError;
        switch (event.level) {
            case "TRACE":
                trace("[" + NAME + "]", event.code);
                break;
            case DETECTED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new FaceError(argsAsJSON.error.text, argsAsJSON.error.id);
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
    public function reinit(options:FaceDetectorOptions):void {
        _context.call("init", options ? options : new FaceDetectorOptions());
    }
}
}
