package com.tuarua.firebase.firestore {
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class WriteBatch extends EventDispatcher {
    private var _asId:String;

    public function WriteBatch() {
        this._asId = FirestoreANEContext.context.call("createGUID") as String;
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        if (FirestoreANEContext.context) {
            FirestoreANEContext.listeners.push({"id": _asId, "type": type});
            if (!FirestoreANEContext.listenersObjects[_asId]) FirestoreANEContext.listenersObjects[_asId] = this;
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            FirestoreANEContext.context.call("addEventListener", _asId, type);
        }
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        if (FirestoreANEContext.context) {
            delete FirestoreANEContext.listenersObjects[_asId];
            var cnt:int = 0;
            for each (var item:Object in FirestoreANEContext.listeners) {
                if (item.type == type && item.id == _asId) FirestoreANEContext.listeners.removeAt(cnt);
                cnt++;
            }
            super.removeEventListener(type, listener, useCapture);
            FirestoreANEContext.context.call("removeEventListener", _asId, type);
        }
    }

//aka delete
    public function clear(documentReference:DocumentReference):void {
        var theRet:* = FirestoreANEContext.context.call("deleteBatch", documentReference.path);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function update(documentReference:DocumentReference, data:*):void {
        var theRet:* = FirestoreANEContext.context.call("updateBatch", documentReference.path, data);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set(documentReference:DocumentReference, data:*, merge:Boolean = false):void {
        var theRet:* = FirestoreANEContext.context.call("setBatch", documentReference.path, data, merge);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function commit():void {
        var theRet:* = FirestoreANEContext.context.call("commitBatch", this._asId); //TODO can I send as null if no listener attached
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }


}
}
