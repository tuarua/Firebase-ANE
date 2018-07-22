package com.tuarua.firebase.firestore.extensions

import com.google.firebase.firestore.DocumentSnapshot


fun DocumentSnapshot.toMap(): Map<String, Any?>? {
    return mapOf(
            "id" to this.id,
            "data" to this.data,
            "exists" to this.exists(),
            "metadata" to mapOf(
                    "isFromCache" to this.metadata.isFromCache,
                    "hasPendingWrites" to this.metadata.hasPendingWrites()
            )
    )
}
