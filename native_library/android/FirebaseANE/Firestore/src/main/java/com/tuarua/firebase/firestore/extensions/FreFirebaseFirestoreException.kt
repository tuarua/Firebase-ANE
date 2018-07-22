package com.tuarua.firebase.firestore.extensions

import com.google.firebase.firestore.FirebaseFirestoreException

fun FirebaseFirestoreException.toMap(): Map<String, Any?>? {
    return mapOf(
            "text" to this.message.toString(),
            "id" to this.code.ordinal)
}