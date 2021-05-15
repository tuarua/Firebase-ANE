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
package com.tuarua.firebase.firestore.extensions

import com.google.firebase.firestore.QueryDocumentSnapshot

fun QueryDocumentSnapshot.toMap(): Map<String, Any?> {
    return mapOf(
            "id" to id,
            "data" to data,
            "exists" to exists(),
            "metadata" to mapOf(
                    "isFromCache" to metadata.isFromCache,
                    "hasPendingWrites" to metadata.hasPendingWrites()
            )
    )
}
