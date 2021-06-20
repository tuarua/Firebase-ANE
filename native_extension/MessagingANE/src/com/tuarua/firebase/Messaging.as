package com.tuarua.firebase {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class Messaging extends EventDispatcher {
    private static var _shared:Messaging;
    private static var _channelId:String;
    private static var _channelName:String;

    /** @private */
    public function Messaging() {
        if (MessagingANEContext.context) {
            var ret:* = MessagingANEContext.context.call("init", _channelId, _channelName);
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    /** @private */
    public static function get shared():Messaging {
        if (!_shared) {
            new Messaging();
        }
        return _shared;
    }

    /**
     *  <p>The FCM token is used to identify this device so that FCM can send notifications to it.
     *  It is associated with your APNS token when the APNS token is supplied, so that sending
     *  messages to the FCM token will be delivered over APNS. </p>
     *  <p>The FCM token is sometimes refreshed automatically.</p>
     *  <p>Once you have an FCM token, you should send it to your application server, so it can use
     *  the FCM token to send notifications to your device.</p>
     */
    public function getToken(listener:Function):String {
        MessagingANEContext.validate();
        var ret:* = MessagingANEContext.context.call("getToken", MessagingANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /**
     *  Asynchronously subscribes to a topic.
     *  @param toTopic The name of the topic, for example, "sports".
     */
    public function subscribe(toTopic:String):void {
        MessagingANEContext.validate();
        var ret:* = MessagingANEContext.context.call("subscribe", toTopic);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     *  Asynchronously unsubscribe from a topic.
     *  @param fromTopic The name of the topic, for example "sports".
     */
    public function unsubscribe(fromTopic:String):void {
        MessagingANEContext.validate();
        var ret:* = MessagingANEContext.context.call("unsubscribe", fromTopic);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (MessagingANEContext.context) {
            MessagingANEContext.dispose();
        }
    }

    /** The id of the channel. Must be unique per package. The value may be truncated if
     * it is too long.
     */
    public static function set channelId(value:String):void {
        _channelId = value;
    }

    /**
     * The user visible name of the channel. The recommended maximum length is 40 characters;
     * the value may be truncated if it is too long.
     */
    public static function set channelName(value:String):void {
        _channelName = value;
    }

}
}
