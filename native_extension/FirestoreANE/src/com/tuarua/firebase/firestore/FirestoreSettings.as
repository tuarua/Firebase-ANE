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
     * Enables the use of FIRTimestamps for timestamp fields in FIRDocumentSnapshots.
     *
     * Currently, Firestore returns timestamp fields as an NSDate but NSDate is implemented as a double
     * which loses precision and causes unexpected behavior when using a timestamp from a snapshot as
     * a part of a subsequent query.
     *
     * Setting timestampsInSnapshotsEnabled to true will cause Firestore to return FIRTimestamp values
     * instead of NSDate, avoiding this kind of problem. To make this work you must also change any code
     * that uses NSDate to use FIRTimestamp instead.
     *
     * NOTE: in the future timestampsInSnapshotsEnabled = true will become the default and this option
     * will be removed so you should change your code to use FIRTimestamp now and opt-in to this new
     * behavior as soon as you can.
     */
    public var areTimestampsInSnapshotsEnabled:Boolean = true;

    public function FirestoreSettings() {
    }
}
}
