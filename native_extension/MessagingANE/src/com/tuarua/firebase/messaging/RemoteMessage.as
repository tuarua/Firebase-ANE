package com.tuarua.firebase.messaging {
public class RemoteMessage {
    public var from:String;
    public var messageId:String;
    public var messageType:String;
    public var to:String;
    public var collapseKey:String;
    public var sentTime:Number;
    public var ttl:int;
    public var notification:Notification;
    public var data:Object;

    public function RemoteMessage() {
    }
}
}