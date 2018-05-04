package com.tuarua.firebase {
import com.tuarua.firebase.messaging.RemoteMessage;
import com.tuarua.firebase.messaging.events.MessagingEvent;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

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
        trace(event.code);
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case MessagingEvent.ON_MESSAGE_RECEIVED:
                /*
                {"data":{"from":"743883671330","messageId":"0:1525436203436198%b8e91b2eb8e91b2e","collapseKey":"air.com.tuarua.firebaseane.example","sentTime":1525436203430,"ttl":2419200,"notification":{"body":"AIR message 2018 A","link":"null","bodyLocalizationArgs":[],"titleLocalizationArgs":[]}},"eventId":"FirebaseMessaging.OnMessageReceived"}



    public var notification:Notification;

                 */
                try {
                    pObj = JSON.parse(event.code);
                    var data:Object = pObj.data;
                    var remoteMessage:RemoteMessage = new RemoteMessage();
                    remoteMessage.from = data.from;
                    remoteMessage.messageId = data.messageId;
                    remoteMessage.messageType = data.messageType;
                    remoteMessage.to = data.to;
                    remoteMessage.collapseKey = data.collapseKey;
                    remoteMessage.sentTime = data.sentTime;
                    remoteMessage.ttl = data.ttl;
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
        }
    }

    // FirebaseMessaging.OnMessageReceived

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
