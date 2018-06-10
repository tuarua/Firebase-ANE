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

public class CollectionReference extends Query {
    private var _id:String;

    /**
     * Gets a `CollectionReference` referring to the collection at the specified path within the
     * database.
     * @param path
     */
    public function CollectionReference(path:String) {
        _path = path;
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("initCollectionReference", path);
        if (theRet is ANEError) throw theRet as ANEError;
        _id = theRet as String;
    }

    /**
     * Add a new document to this collection with the specified data, assigning it a document ID automatically.
     * @return A DocumentReference pointing to a new document with an auto-generated ID.
     * @param data
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(path:String, error:FirestoreError):void {
     *
     * }
     * </listing>
     */
    public function addDocument(data:*, listener:Function = null):DocumentReference {
        FirestoreANEContext.validate();
        var doc:DocumentReference = this.document();
        doc.setData(data, listener);
        return doc;
    }

    /**
     * @return A DocumentReference pointing to the document at the specified path or if documentPath is null a
     * new document with an auto-generated ID.
     */
    public function document(documentPath:String = null):DocumentReference {
        FirestoreANEContext.validate();
        if (documentPath) {
            return new DocumentReference(_path + "/" + documentPath);
        } else {
            var theRet:* = FirestoreANEContext.context.call("documentWithAutoId", _path);
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
            var docPath:String = theRet as String;
            return new DocumentReference(docPath);
        }
    }

    /**
     * For subcollections, `parent` returns the containing `DocumentReference`.  For root
     * collections, null is returned.
     */
    public function get parent():DocumentReference {
        FirestoreANEContext.validate();
        var theRet:* = FirestoreANEContext.context.call("getCollectionParent", _path);
        if (theRet is ANEError) throw theRet as ANEError;
        return new DocumentReference(theRet as String);
    }

    public function get path():String {
        return _path;
    }

    public function get id():String {
        return _id;
    }
}
}
