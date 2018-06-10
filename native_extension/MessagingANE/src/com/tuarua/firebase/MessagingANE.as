package com.tuarua.firebase {
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class MessagingANE extends EventDispatcher {
    private static var _messaging:MessagingANE;
    private static var _channelId:String;
    private static var _channelName:String;
    /** @private */
    public function MessagingANE() {
        if (MessagingANEContext.context) {
            var theRet:* = MessagingANEContext.context.call("init", _channelId, _channelName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _messaging = this;
    }

    /**
     *  <p>The FCM token is used to identify this device so that FCM can send notifications to it.
     *  It is associated with your APNS token when the APNS token is supplied, so that sending
     *  messages to the FCM token will be delivered over APNS. </p>
     *  <p>The FCM token is sometimes refreshed automatically.</p>
     *  <p>Once you have an FCM token, you should send it to your application server, so it can use
     *  the FCM token to send notifications to your device.</p>
     */
    public function get token():String {
        MessagingANEContext.validate();
        var theRet:* = MessagingANEContext.context.call("getToken");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as String;
    }

    /**
     *  Asynchronously subscribes to a topic.
     *  @param toTopic The name of the topic, for example, "sports".
     */
    public function subscribe(toTopic:String):void {
        MessagingANEContext.validate();
        var theRet:* = MessagingANEContext.context.call("subscribe", toTopic);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     *  Asynchronously unsubscribe from a topic.
     *  @param fromTopic The name of the topic, for example "sports".
     */
    public function unsubscribe(fromTopic:String):void {
        MessagingANEContext.validate();
        var theRet:* = MessagingANEContext.context.call("unsubscribe", fromTopic);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** The ANE instance. */
    public static function get messaging():MessagingANE {
        if (!_messaging) {
            new MessagingANE();
        }
        return _messaging;
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
