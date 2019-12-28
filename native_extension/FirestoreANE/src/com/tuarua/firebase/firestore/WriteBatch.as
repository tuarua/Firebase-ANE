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

public class WriteBatch {
    /** Creates a new write batch */
    public function WriteBatch() {
    }

    /**
     * Deletes the document referred to by <code>documentReference</code>.
     *
     * @param documentReference
     */
    public function deleteDocument(documentReference:DocumentReference):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("deleteBatch", documentReference.path);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Updates fields in the document referred to by <code>documentReference</code>.
     * If document does not exist, the write batch will fail.
     *
     * @param forDocument A reference to the document whose data should be overwritten.
     * @param data
     */
    public function updateData(data:*, forDocument:DocumentReference):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("updateBatch", forDocument.path, data);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Writes to the document referred to by <code>documentReference</code>. If the document doesn't yet exist,
     * this method creates it and then sets the data. If the document exists, this method overwrites
     * the document data with the new values.
     *
     * @param data
     * @param forDocument A reference to the document whose data should be overwritten.
     * @param merge Whether to merge the provided data into any existing document.
     * @return This <code>WriteBatch</code> instance. Used for chaining method calls.
     */
    public function setData(data:*, forDocument:DocumentReference, merge:Boolean = false):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("setBatch", forDocument.path, data, merge);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Commits all of the writes in this write batch as a single atomic unit.
     *
     * @param listener Optional This function will only execute
     * when the client is online and the commit has completed against the server. The
     * completion handler will not be called when the device is offline, though local
     * changes will be visible immediately.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:FirestoreError):void {
     *
     * }
     * </listing>
     */
    public function commit(listener:Function = null):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("commitBatch", FirestoreANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

}
}

