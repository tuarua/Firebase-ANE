package com.tuarua.firebase.firestore

data class FirestoreEvent(val method: String, val callbackId: String, val data: Map<String, Any>? = null, val exception: String? = null)