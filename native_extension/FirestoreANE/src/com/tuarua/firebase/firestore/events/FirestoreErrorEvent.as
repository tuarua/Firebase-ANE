package com.tuarua.firebase.firestore.events {
import flash.events.ErrorEvent;

public class FirestoreErrorEvent extends ErrorEvent {
    public static const ERROR:String = "FirestoreErrorEvent.Error";

    public function FirestoreErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0) {
        super(type, bubbles, cancelable, text, id);
    }
}
}
