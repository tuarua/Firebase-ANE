package com.tuarua.firebase.remoteconfig.events {
import flash.events.Event;

public class RemoteConfigEvent extends Event {
    public static const FETCH:String = "RemoteConfigEvent.Fetch";
    public function RemoteConfigEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
