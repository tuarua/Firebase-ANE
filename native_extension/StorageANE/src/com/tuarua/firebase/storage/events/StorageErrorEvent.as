package com.tuarua.firebase.storage.events {
import flash.events.ErrorEvent;

public class StorageErrorEvent extends ErrorEvent {
    public static const ERROR:String = "StorageErrorEvent.Error";
    public function StorageErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0) {
        super(type, bubbles, cancelable, text, id);
    }
}
}
