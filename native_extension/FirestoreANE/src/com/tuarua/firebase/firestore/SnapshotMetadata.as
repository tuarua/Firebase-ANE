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
public class SnapshotMetadata {
    /**
     * Returns true if the snapshot was created from cached data rather than guaranteed up-to-date server
     * data. If your listener has opted into metadata updates you will receive another snapshot
     * with <code>isFromCache</code> equal to NO once
     * the client has received up-to-date data from the backend.
     */
    public var isFromCache:Boolean;
    /**
     * Returns true if the snapshot contains the result of local writes (e.g. set() or update() calls)
     * that have not yet been committed to the backend. If your listener has opted into metadata updates
     * you will receive another snapshot with <code>hasPendingWrites</code> equal to NO once the writes have
     * been committed to the backend.
     */
    public var hasPendingWrites:Boolean;

    public function SnapshotMetadata() {
    }
}
}
