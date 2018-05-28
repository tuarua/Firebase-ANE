package com.tuarua.firebase {
import com.tuarua.firebase.messaging.RemoteMessage;
import com.tuarua.firebase.messaging.events.MessagingEvent;
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;
/** @private */
public class MessagingANEContext {
    internal static const NAME:String = "MessagingANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .messaging";

    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    public static var closures:Dictionary = new Dictionary();
    public static var closureCallers:Dictionary = new Dictionary();
    private static var pObj:Object;

    public function MessagingANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createEventId(listener:Function, listenerCaller:Object = null):String {
        var eventId:String;
        if (listener) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
            if (closureCallers) {
                closureCallers[eventId] = listenerCaller;
            }
        }
        return eventId;
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case MessagingEvent.ON_MESSAGE_RECEIVED:
                try {
                    pObj = JSON.parse(event.code);
                    MessagingANE.messaging.dispatchEvent(new MessagingEvent(event.level,
                            ANEUtils.map(pObj.data, RemoteMessage) as RemoteMessage));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case MessagingEvent.ON_TOKEN_REFRESHED:
                try {
                    pObj = JSON.parse(event.code);
                    MessagingANE.messaging.dispatchEvent(new MessagingEvent(event.level, null, pObj.data.token));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case MessagingEvent.ON_DEBUG:
                MessagingANE.messaging.dispatchEvent(new MessagingEvent(event.level, null, event.code));
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
