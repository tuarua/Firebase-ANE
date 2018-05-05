package com.tuarua.firebase {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class MessagingANE extends EventDispatcher {
    private static var _messaging:MessagingANE;

    private static var _channelId:String;
    private static var _channelName:String;

    public function MessagingANE() {
        if (MessagingANEContext.context) {
            var theRet:* = MessagingANEContext.context.call("init", _channelId, _channelName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _messaging = this;
    }

    public function get token():String {
        MessagingANEContext.validate();
        var theRet:* = MessagingANEContext.context.call("getToken");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as String;
    }

    public function subscribe(toTopic:String, listener:Function = null):void {
        MessagingANEContext.validate();
        var theRet:* = MessagingANEContext.context.call("subscribe", MessagingANEContext.createEventId(listener), toTopic);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function unsubscribe(fromTopic:String, listener:Function = null):void {
        MessagingANEContext.validate();
        var theRet:* = MessagingANEContext.context.call("unsubscribe", MessagingANEContext.createEventId(listener), fromTopic);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function get messaging():MessagingANE {
        if (!_messaging) {
            new MessagingANE();
        }
        return _messaging;
    }

    public static function dispose():void {
        if (MessagingANEContext.context) {
            MessagingANEContext.dispose();
        }
    }

    public static function set channelId(value:String):void {
        _channelId = value;
    }

    public static function set channelName(value:String):void {
        _channelName = value;
    }
}
}
