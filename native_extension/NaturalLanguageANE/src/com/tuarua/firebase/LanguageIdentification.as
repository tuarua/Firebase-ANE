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

package com.tuarua.firebase {
import com.tuarua.firebase.naturalLanguage.LanguageIdentificationOptions;
import com.tuarua.fre.ANEError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class LanguageIdentification {
    internal static const NAME:String = "NaturalLanguageANE";
    private static var _context:ExtensionContext;
    public static var closures:Dictionary = new Dictionary();
    private static const RECOGNIZED:String = "LanguageEvent.Recognized";
    private static const RECOGNIZED_MULTI:String = "LanguageEvent.RecognizedMulti";

    public function LanguageIdentification(options:LanguageIdentificationOptions, isStatsCollectionEnabled:Boolean) {
        try {
            _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
            _context.addEventListener(StatusEvent.STATUS, gotEvent);
            _context.call("init", options, isStatsCollectionEnabled);
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
        var err:LanguageIdentificationError;
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
                        err = new LanguageIdentificationError(pObj.error.text, pObj.error.id);
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
            case RECOGNIZED_MULTI:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new LanguageIdentificationError(pObj.error.text, pObj.error.id);
                    }
                    var ret2:* = _context.call("getResultsMulti", pObj.eventId);
                    if (ret2 is ANEError) {
                        printANEError(ret2 as ANEError);
                        return;
                    }
                    closure.call(null, ret2, err);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /**
     * Identifies the main language for the given text.
     *
     * @param text The input text to use for identifying the language. Inputs longer than 200 characters
     * are truncated to 200 characters, as longer input does not improve the detection accuracy.
     * @param listener Closure to call back on the main queue with the identified language code or error.
     */
    public function identifyLanguage(text:String, listener:Function):void {
        var ret:* = _context.call("identifyLanguage", text, createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Identifies possible languages for the given text.
     *
     * @param text The input text to use for identifying the language. Inputs longer than 200 characters
     * are truncated to 200 characters, as longer input does not improve the detection accuracy.
     * @param listener Closure to call back on the main queue with the identified languages or error.
     */
    public function identifyPossibleLanguages(text:String, listener:Function):void {
        var ret:* = _context.call("identifyPossibleLanguages", text, createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Closes the language identification and release its model resources. */
    public function close():void {
        if (_context == null) return;
        _context.call("close");
    }

    /** @private */
    internal function reinit(options:LanguageIdentificationOptions, isStatsCollectionEnabled:Boolean):void {
        if (_context == null) return;
        _context.call("init", options, isStatsCollectionEnabled);
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
