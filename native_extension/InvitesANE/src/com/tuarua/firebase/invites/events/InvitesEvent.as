package com.tuarua.firebase.invites.events {
import flash.events.Event;

public class InvitesEvent extends Event {
    public static const SUCCESS:String = "FirebaseInvites.Success";
    public static const ERROR:String = "FirebaseInvites.Error";
    public var error:Error;
    public var ids:Array = [];

    public function InvitesEvent(type:String, ids:Array = null, error:Error = null,
                                 bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.error = error;
        if (ids != null) {
            this.ids = ids;
        }
    }

    public override function clone():Event {
        return new InvitesEvent(type, this.ids, this.error, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("InvitesEvent", "type", "ids", "error", "bubbles", "cancelable");
    }
}
}
