package com.tuarua.firebase.storage {
import com.tuarua.firebase.StorageANEContext;

import flash.events.EventDispatcher;

public class StorageTask extends EventDispatcher {
    protected var _asId:String;
    protected var _referenceId:String;
    public function StorageTask(referenceId:String) {
        this._referenceId = referenceId;
        this._asId = StorageANEContext.context.call("createGUID") as String;
    }
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
                                              useWeakReference:Boolean = false):void {
        if (StorageANEContext.context) {
            StorageANEContext.listeners.push({"id": _asId, "type": type});
            if (!StorageANEContext.listenersObjects[_asId]) StorageANEContext.listenersObjects[_asId] = this;
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            StorageANEContext.context.call("addEventListener", _asId, type);
        }
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        if (StorageANEContext.context) {
            delete StorageANEContext.listenersObjects[_asId];
            var cnt:int = 0;
            for each (var item:Object in StorageANEContext.listeners) {
                if (item.type == type && item.id == _asId) StorageANEContext.listeners.removeAt(cnt);
                cnt++;
            }
            super.removeEventListener(type, listener, useCapture);
            StorageANEContext.context.call("removeEventListener", _asId, type);
        }
    }

    public function pause():void {
        StorageANEContext.context.call("pauseTask", _asId);
    }

    public function resume():void {
        StorageANEContext.context.call("resumeTask", _asId);
    }

    public function cancel():void {
        StorageANEContext.context.call("cancelTask", _asId);
    }

    public function get asId():String {
        return _asId;
    }
}
}
