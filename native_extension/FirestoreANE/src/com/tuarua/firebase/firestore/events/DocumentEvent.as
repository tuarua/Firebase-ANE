package com.tuarua.firebase.firestore.events {
import com.tuarua.firebase.firestore.DocumentSnapshot;

import flash.events.Event;

public class DocumentEvent extends Event {
    public static const SNAPSHOT:String = "DocumentEvent.Snapshot";
    public static const COMPLETE:String = "DocumentEvent.Complete";
    public var data:DocumentSnapshot;
    public var realtime:Boolean;

    public function DocumentEvent(type:String, data:DocumentSnapshot = null, realtime:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
        this.realtime = realtime;
    }

    public override function clone():Event {
        return new DocumentEvent(type, this.data, this.realtime, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("DocumentEvent", "data", "type", "realtime", "bubbles", "cancelable");
    }
}
}
