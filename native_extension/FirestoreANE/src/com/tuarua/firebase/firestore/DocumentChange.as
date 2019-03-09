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
public class DocumentChange {
    /**
     * The index of the changed document in the result set immediately after this DocumentChange
     * (i.e. supposing that all prior DocumentChange objects and the current DocumentChange object
     * have been applied).
     */
    public var newIndex:int;
    /**
     * The index of the changed document in the result set immediately prior to this DocumentChange
     * (i.e. supposing that all prior DocumentChange objects have been applied).
     */
    public var oldIndex:int;
    /** The ID of the document for which this <code>DocumentSnapshot</code> contains data. */
    public var documentId:String;
    /** The type of change that occurred (added, modified, or removed). */
    public var type:int;
    public function DocumentChange() {
    }
}
}
