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
[RemoteClass(alias="com.tuarua.firebase.firestore.FirestoreSettings")]
public class FirestoreSettings {
    /** The hostname to connect to. */
    public var host:String;
    /** Set to false to disable local persistent storage. */
    public var isPersistenceEnabled:Boolean = true;
    /** Whether to use SSL when connecting. */
    public var isSslEnabled:Boolean = true;
    /**
     * Specifies whether to use FIRTimestamps for timestamp fields in FIRDocumentSnapshots. This is
     * now enabled by default and should not be disabled.
     *
     * Previously, Firestore returned timestamp fields as NSDate but NSDate is implemented as a double
     * which loses precision and causes unexpected behavior when using a timestamp from a snapshot as a
     * part of a subsequent query.
     *
     * So now Firestore returns FIRTimestamp values instead of NSDate, avoiding this kind of problem.
     *
     * To opt into the old behavior of returning NSDate objects, you can temporarily set
     * areTimestampsInSnapshotsEnabled to false.
     *
     * @deprecated This setting now defaults to true and will be removed in a future release. If you are
     * already setting it to true, just remove the setting. If you are setting it to false, you should
     * update your code to expect FIRTimestamp objects instead of NSDate and then remove the setting.
     */
    public var areTimestampsInSnapshotsEnabled:Boolean = true;

    public function FirestoreSettings() {
    }
}
}
