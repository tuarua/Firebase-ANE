package com.tuarua.firebase.firestore {
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class Query extends EventDispatcher {
    protected var _path:String;

    protected var _asId:String;
    protected var _mapTo:Class;

    protected var whereClauses:Vector.<Where> = new <Where>[];
    protected var orderClauses:Vector.<Order> = new <Order>[];
    protected var startAfters:Array = [];
    protected var startAts:Array = [];
    protected var endBefores:Array = [];
    protected var endAts:Array = [];
    protected var limitTo:int = 10000;

    public function Query() {
        _asId = FirestoreANEContext.context.call("createGUID") as String;
    }

    public function where(fieldPath:String, operator:String, value:*):Query {
        whereClauses.push(new Where(fieldPath, operator, value));
        return this;
    }

    public function order(by:String, descending:Boolean = false):Query {
        orderClauses.push(new Order(by, descending));
        return this;
    }

    public function limit(to:int):Query {
        limitTo = to;
        return this;
    }

    public function startAfter(...args):Query {
        startAfters = args;
        return this;
    }

    public function startAt(...args):Query {
        startAts = args;
        return this;
    }

    public function endAt(...args):Query {
        endAts = args;
        return this;
    }

    public function endBefore(...args):Query {
        endBefores = args;
        return this;
    }

    public function map(to:Class):void {
        _mapTo = to;
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        if (FirestoreANEContext.context) {
            FirestoreANEContext.listeners.push({"id": _asId, "type": type});
            if (!FirestoreANEContext.listenersObjects[_asId]) {
                FirestoreANEContext.listenersObjects[_asId] = this;
            }
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            FirestoreANEContext.context.call("addEventListener", _asId, type);
        }
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        // FirestoreANEContext.listenersObjects[_asId] = null;
        if (FirestoreANEContext.context) {
            delete FirestoreANEContext.listenersObjects[_asId];
            var cnt:int = 0;
            for each (var item:Object in FirestoreANEContext.listeners) {
                if (item.type == type && item.id == _asId) {
                    FirestoreANEContext.listeners.removeAt(cnt);
                }
                cnt++;
            }
            super.removeEventListener(type, listener, useCapture);
            FirestoreANEContext.context.call("removeEventListener", _asId, type);
        }
    }

    public function get():void {
        var theRet:* = FirestoreANEContext.context.call("getDocuments", _path, _asId, whereClauses,
                orderClauses, startAts, startAfters, endAts, endBefores, limitTo);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }


    public function get mapTo():Class {
        return _mapTo;
    }

}
}

