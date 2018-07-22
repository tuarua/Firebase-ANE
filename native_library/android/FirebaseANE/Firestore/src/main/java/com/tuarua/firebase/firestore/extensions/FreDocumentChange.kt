package com.tuarua.firebase.firestore.extensions

import com.google.firebase.firestore.DocumentChange

fun DocumentChange.toMap(): Map<String, Any?>? {
    return mapOf(
            "type" to this.type.ordinal,
            "newIndex" to this.newIndex,
            "oldIndex" to this.oldIndex,
            "documentId" to this.document.id)
}
