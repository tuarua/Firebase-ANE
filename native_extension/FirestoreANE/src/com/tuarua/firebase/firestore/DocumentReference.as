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

    /**
     * Returns a DocumentReference pointing to a new document with an auto-generated ID.
     *
     * @return A DocumentReference pointing to a new document with an auto-generated ID.
     */
    public function DocumentReference(path:String) {
        this._path = path;
        FirestoreANEContext.validate();
        this._asId = FirestoreANEContext.context.call("createGUID") as String;
        var ret:* = FirestoreANEContext.context.call("initDocumentReference", path);
        if (ret is ANEError) throw ret as ANEError;
        this._id = ret as String;
    }

    /**
     * @return A CollectionReference pointing to the document at the specified path
     */
    public function collection(collectionPath:String):CollectionReference {
        FirestoreANEContext.validate();
        return new CollectionReference(_path + "/" + collectionPath);
    }

    /**
     * Attaches a listener for DocumentSnapshot events.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(snapshot:DocumentSnapshot, error:FirestoreError, realtime:Boolean):void {
     *
     * }
     * </listing>
     */
    public function addSnapshotListener(listener:Function):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("addSnapshotListenerDocument", _path,
                FirestoreANEContext.createEventId(listener, this), _asId);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Detaches a listener for DocumentSnapshot events.
     * @param listener
     */
    public function removeSnapshotListener(listener:Function):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("removeSnapshotListener", _asId);
        if (ret is ANEError) throw ret as ANEError;
        for (var k:String in FirestoreANEContext.closures) {
            var value:Function = FirestoreANEContext.closures[k];
            if (value == listener) {
                delete FirestoreANEContext.closures[k];
                delete FirestoreANEContext.closureCallers[k];
                return;
            }
        }
    }

    /**
     * Reads the document referenced by this `DocumentReference`.
     *
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(snapshot:DocumentSnapshot, error:FirestoreError, realtime:Boolean):void {
     *
     * }
     * </listing>
     */
    public function getDocument(listener:Function):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("getDocumentReference", _path,
                FirestoreANEContext.createEventId(listener, this));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Converts the Document into an as3 Class with properties mapped to the Document's fields.
     * @param to AS3 class to map to
     */
    public function map(to:Class):void {
        _mapTo = to;
    }

    /**
     * Writes to the document referred to by this DocumentReference. If the document does not yet
     * exist, it will be created.
     *
     * @param data
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(path:String, error:FirestoreError):void {
     *
     * }
     * </listing>
     * @param merge
     */
    public function setData(data:*, listener:Function = null, merge:Boolean = false):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("setDocumentReference", _path,
                FirestoreANEContext.createEventId(listener), data, merge);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Updates fields in the document referred to by this `DocumentReference`. If the document
     * does not exist, the update fails and the specified completion block receives an error.
     *
     * @param data
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(path:String, error:FirestoreError):void {
     *
     * }
     * </listing>
     */
    public function updateData(data:*, listener:Function = null):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("updateDocumentReference", _path,
                FirestoreANEContext.createEventId(listener), data);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Deletes the document referred to by this `DocumentReference`.
     *
     * @param listener
     */
    public function remove(listener:Function = null):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("deleteDocumentReference", _path,
                FirestoreANEContext.createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** A reference to the collection to which this `DocumentReference` belongs. */
    public function get parent():CollectionReference {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("getDocumentParent", _path);
        if (ret is ANEError) throw ret as ANEError;
        return new CollectionReference(ret as String);
    }

    /**@private */
    public function get id():String {
        return _id;
    }

    public function get path():String {
        return _path;
    }

    /**@private */
    public function get mapTo():Class {
        return _mapTo;
    }
}
}
