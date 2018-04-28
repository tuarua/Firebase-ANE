package com.tuarua.firebase.firestore.events {
import com.tuarua.firebase.firestore.DocumentSnapshot;
import com.tuarua.firebase.firestore.QuerySnapshot;

import flash.events.Event;

public class QueryEvent extends Event {
    public static const QUERY_SNAPSHOT:String = "QueryEvent.QuerySnapshot";
    public var snapshot:QuerySnapshot;
    public function QueryEvent(type:String, snapshot:QuerySnapshot, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.snapshot = snapshot;
    }
    public override function clone():Event {
        return new QueryEvent(type, this.snapshot, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("QueryEvent", "snapshot", "type", "bubbles", "cancelable");
    }
}
}
