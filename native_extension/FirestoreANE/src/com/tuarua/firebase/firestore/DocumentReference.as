/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua.firebase.firestore {
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.firebase.firestore.events.DocumentEvent;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class DocumentReference extends EventDispatcher {
    private var _path:String;
    private var _id:String;
    private var _asId:String;
    private var _mapTo:Class;

    public function DocumentReference(path:String) {
        this._path = path;
        this._asId = FirestoreANEContext.context.call("createGUID") as String;
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("initDocumentReference", path);
            if (theRet is ANEError) throw theRet as ANEError;
            this._id = theRet as String;
        }
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
                                              priority:int = 0, useWeakReference:Boolean = false):void {
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

    public function addSnapshotListener(listener:Function):void {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("addSnapshotListenerDocument", _path, _asId);
            if (theRet is ANEError) throw theRet as ANEError;
            if (!this.hasEventListener(DocumentEvent.SNAPSHOT)) this.addEventListener(DocumentEvent.SNAPSHOT, listener);
        }
    }

    public function removeSnapshotListener(listener:Function):void {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("removeSnapshotListener", _asId);
            if (theRet is ANEError) throw theRet as ANEError;
            this.removeEventListener(DocumentEvent.SNAPSHOT, listener);
        }
    }

    public function get():void {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("getDocumentReference", _path, _asId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function map(to:Class):void {
        _mapTo = to;
    }

    public function set(data:*, merge:Boolean = false):void {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("setDocumentReference", _path, _asId, data, merge);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function update(data:*):void {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("updateDocumentReference", _path, _asId, data);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    //aka delete
    public function remove():void {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("deleteDocumentReference", _path, _asId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function get parent():CollectionReference {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("getDocumentParent", _path);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        return new CollectionReference(theRet as String);
    }

    public function get id():String {
        return _id;
    }

    public function get path():String {
        return _path;
    }

    public function get mapTo():Class {
        return _mapTo;
    }
}
}
