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
package com.tuarua.google {
import com.tuarua.fre.ANEUtils;
import com.tuarua.google.signin.GoogleSignInAccount;
import com.tuarua.google.signin.events.GoogleSignInEvent;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class GoogleSignInANEContext {
    internal static const NAME:String = "GoogleSignInANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .googleSignIn";
    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    private static var argsAsJSON:Object;

    public function GoogleSignInANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.google." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case GoogleSignInEvent.ERROR:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var error:Error = new Error(argsAsJSON.data.text, argsAsJSON.data.id);
                    GoogleSignIn.shared().dispatchEvent(new GoogleSignInEvent(event.level, null, error));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case GoogleSignInEvent.SIGN_IN:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    GoogleSignIn.shared().dispatchEvent(new GoogleSignInEvent(event.level,
                            ANEUtils.map(argsAsJSON.data,
                                    GoogleSignInAccount) as GoogleSignInAccount));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
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

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }

}
}
