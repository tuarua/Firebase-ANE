package com.tuarua.firebase.storage.events {
import flash.events.Event;
import flash.events.ProgressEvent;

public class StorageProgressEvent extends ProgressEvent {
    //public static const GET_FILE_PROGRESS:String = "StorageProgressEvent.GetFileProgress";
    //public static const PUT_FILE_PROGRESS:String = "StorageProgressEvent.PutFileProgress";
    public static const PROGRESS:String = "StorageProgressEvent.Progress";
    public function StorageProgressEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, bytesLoaded:Number = 0, bytesTotal:Number = 0) {
        super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
    }

    override public function clone():Event {
        return new StorageProgressEvent(type, bubbles, cancelable, bytesTotal, bytesLoaded);
    }

    override public function toString():String {
        return formatToString("StorageProgressEvent", "type", "bubbles", "cancelable", "bytesLoaded", "bytesTotal");
    }
}
}