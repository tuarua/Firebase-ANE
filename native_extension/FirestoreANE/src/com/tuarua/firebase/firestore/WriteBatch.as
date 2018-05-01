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

import flash.events.EventDispatcher;

public class WriteBatch {
    private var _asId:String;

    public function WriteBatch() {
        this._asId = FirestoreANEContext.context.call("createGUID") as String;
    }

//aka delete
    public function clear(documentReference:DocumentReference):void {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
        var theRet:* = FirestoreANEContext.context.call("deleteBatch", documentReference.path);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function update(documentReference:DocumentReference, data:*):void {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
        var theRet:* = FirestoreANEContext.context.call("updateBatch", documentReference.path, data);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function set(documentReference:DocumentReference, data:*, merge:Boolean = false):void {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
        var theRet:* = FirestoreANEContext.context.call("setBatch", documentReference.path, data, merge);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function commit(listener:Function = null):void {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
        var eventId:String;
        if (listener) {
            eventId = this._asId;
            FirestoreANEContext.closures[eventId] = listener;
        }
        var theRet:* = FirestoreANEContext.context.call("commitBatch", eventId);
        if (theRet is ANEError) throw theRet as ANEError;
    }

}
}
