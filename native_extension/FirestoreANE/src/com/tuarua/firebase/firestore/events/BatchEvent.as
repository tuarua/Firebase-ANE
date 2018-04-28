package com.tuarua.firebase.firestore.events {
import flash.events.Event;

public class BatchEvent extends Event {
    public static const COMPLETE:String = "BatchEvent.Complete";

    public function BatchEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }

    public override function clone():Event {
        return new BatchEvent(type, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("BatchEvent", "type", "bubbles", "cancelable");
    }
}
}
