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

package com.tuarua.mlkit.nl.languageid {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class LanguageIdentifier extends EventDispatcher {
    internal static const NAME:String = "LanguageIdentificationANE";
    private static var _context:ExtensionContext;
    /** @private */
    public static var callbacks:Dictionary = new Dictionary();
    private static const RECOGNIZED:String = "LanguageEvent.Recognized";
    private static const RECOGNIZED_MULTI:String = "LanguageEvent.RecognizedMulti";
    public function LanguageIdentifier(options:LanguageIdentificationOptions) {
        try {
            _context = ExtensionContext.createExtensionContext("com.tuarua.mlkit.nl." + NAME, null);
            _context.addEventListener(StatusEvent.STATUS, gotEvent);
            _context.call("init", options ? options : new LanguageIdentificationOptions());
        } catch (e:Error) {
            trace(e.name);
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
        }
    }

    private function createCallback(listener:Function):String {
        if (!_context) return null;
        var id:String;
        if (listener != null) {
            id = _context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    private static function callCallback(callbackId:String, clear:Boolean, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        if (clear) delete callbacks[callbackId];
    }

    /** @private */
    public static function gotEvent(event:StatusEvent):void {
        var argsAsJSON:Object;
        var err:LanguageIdentificationError;
        switch (event.level) {
            case "TRACE":
                trace("[" + NAME + "]", event.code);
                break;
            case RECOGNIZED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new LanguageIdentificationError(argsAsJSON.error.text, argsAsJSON.error.id);
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
            case RECOGNIZED_MULTI:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new LanguageIdentificationError(argsAsJSON.error.text, argsAsJSON.error.id);
                    }
                    var ret2:* = _context.call("getResultsMulti", argsAsJSON.callbackId);
                    if (ret2 is ANEError) {
                        printANEError(ret2 as ANEError);
                        return;
                    }
                    callCallback(argsAsJSON.callbackId, ret2, err);
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
        var ret:* = _context.call("identifyLanguage", text, createCallback(listener));
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
        var ret:* = _context.call("identifyPossibleLanguages", text, createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Closes the language identification and release its model resources. */
    public function close():void {
        if (_context == null) return;
        _context.call("close");
    }

    /** @private */
    public function reinit(options:LanguageIdentificationOptions):void {
        if (_context == null) return;
        _context.call("init", options ? options : new LanguageIdentificationOptions());
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
