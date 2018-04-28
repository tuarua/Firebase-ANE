package com.tuarua.firebase.remoteconfig.events {
import flash.events.ErrorEvent;

public class RemoteConfigErrorEvent extends ErrorEvent {
    public static const FETCH_ERROR:String = "RemoteConfigErrorEvent.FetchError";
    public function RemoteConfigErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0) {
        super(type, bubbles, cancelable, text, id);
    }
}
}
