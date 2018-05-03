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
import com.tuarua.fre.ANEError;

public class DocumentReference {
    private var _path:String;
    private var _id:String;
    private var _asId:String;
    private var _mapTo:Class;

    public function DocumentReference(path:String) {
        this._path = path;
        FirestoreANEContext.validate();
        this._asId = FirestoreANEContext.context.call("createGUID") as String;
        var theRet:* = FirestoreANEContext.context.call("initDocumentReference", path);
        if (theRet is ANEError) throw theRet as ANEError;
        this._id = theRet as String;
    }

    public function addSnapshotListener(listener:Function):void {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("addSnapshotListenerDocument", _path, FirestoreANEContext.createEventId(listener, this), _asId);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function removeSnapshotListener(listener:Function):void {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("removeSnapshotListener", _asId);
        if (theRet is ANEError) throw theRet as ANEError;
        for (var k:String in FirestoreANEContext.closures) {
            var value:Function = FirestoreANEContext.closures[k];
            if (value == listener) {
                delete FirestoreANEContext.closures[k];
                delete FirestoreANEContext.closureCallers[k];
                return;
            }
        }
    }

    public function getDocument(listener:Function):void {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("getDocumentReference", _path, FirestoreANEContext.createEventId(listener, this));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function map(to:Class):void {
        _mapTo = to;
    }

    public function set(data:*, listener:Function = null, merge:Boolean = false):void {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("setDocumentReference", _path, FirestoreANEContext.createEventId(listener), data, merge);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function update(data:*, listener:Function = null):void {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("updateDocumentReference", _path, FirestoreANEContext.createEventId(listener), data);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    //aka delete
    public function remove(listener:Function = null):void {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("deleteDocumentReference", _path, FirestoreANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get parent():CollectionReference {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("getDocumentParent", _path);
        if (theRet is ANEError) throw theRet as ANEError;
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
