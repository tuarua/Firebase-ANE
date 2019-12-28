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
import com.tuarua.firebase.invites.DynamicLinkError;
import com.tuarua.firebase.invites.DynamicLinkResult;
import com.tuarua.firebase.invites.events.InvitesEvent;
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class InvitesANEContext {
    internal static const NAME:String = "InvitesANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .invites";

    public static var callbacks:Dictionary = new Dictionary();
    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    private static const ON_LINK:String = "FirebaseInvites.OnLink";

    public function InvitesANEContext() {
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

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    public static function callCallback(callbackId:String, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:DynamicLinkError;
        var dynamicLinkResult:DynamicLinkResult;
        var argsAsJSON:Object;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case InvitesEvent.SUCCESS:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    InvitesANE.invites.dispatchEvent(new InvitesEvent(event.level, argsAsJSON.data.ids));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case InvitesEvent.ERROR:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    InvitesANE.invites.dispatchEvent(new InvitesEvent(event.level, null,
                            new Error(argsAsJSON.error.text, argsAsJSON.error.id)));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ON_LINK:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new DynamicLinkError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty("url")) {
                        dynamicLinkResult = ANEUtils.map(argsAsJSON.data, DynamicLinkResult) as DynamicLinkResult;
                    }
                    callCallback(argsAsJSON.callbackId, dynamicLinkResult, err);
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
