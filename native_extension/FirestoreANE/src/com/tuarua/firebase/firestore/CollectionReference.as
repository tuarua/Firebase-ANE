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
import com.tuarua.firebase.FirestoreANE;
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.fre.ANEError;

public class CollectionReference extends Query {
    private var _id:String;

    public function CollectionReference(path:String) {
        _path = path;
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
        var theRet:* = FirestoreANEContext.context.call("initCollectionReference", path);
        if (theRet is ANEError) throw theRet as ANEError;
        _id = theRet as String;
    }

    public function add(data:*):CollectionReference {
        var doc:DocumentReference = this.document();
        doc.set(data);
        return this;
    }

    public function document(documentPath:String = null):DocumentReference {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
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
        return null;
    }

    public function get parent():DocumentReference {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
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
