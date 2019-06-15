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

package com.tuarua.firebase.ml.vision.label {
import com.tuarua.firebase.ml.vision.common.VisionImage;
import com.tuarua.fre.ANEError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class CloudImageLabeler {
    internal static const NAME:String = "VisionCloudLabelANE";
    private static var _context:ExtensionContext;
    private var _options:CloudImageLabelerOptions = new CloudImageLabelerOptions();
    /** @private */
    public static var closures:Dictionary = new Dictionary();
    private static const RECOGNIZED:String = "CloudLabelEvent.Recognized";

    /** @private */
    public function CloudImageLabeler(options:CloudImageLabelerOptions) {
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
            trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
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

    /** @private */
    public static function gotEvent(event:StatusEvent):void {
        var pObj:Object;
        var closure:Function;
        var err:CloudImageError;
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
                        err = new CloudImageError(pObj.error.text, pObj.error.id);
                    }
                    var ret:* = _context.call("getResults", pObj.eventId);
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    closure.call(null, ret, err);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /**
     * Detects labels in a given image.
     *
     * @param image The image to use when searching labels.
     * @param listener Closure to call back on the main queue with label detected or error.
     */
    public function process(image:VisionImage, listener:Function):void {
        var ret:* = _context.call("process", image, createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Closes the cloud label detector and release its model resources. */
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
    public function reinit(options:CloudImageLabelerOptions):void {
        _context.call("init", options ? options : new CloudImageLabelerOptions());
    }

}
}
