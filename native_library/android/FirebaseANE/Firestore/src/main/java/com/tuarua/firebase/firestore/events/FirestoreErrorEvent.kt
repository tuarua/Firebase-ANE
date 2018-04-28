package com.tuarua.firebase.firestore.events

class FirestoreErrorEvent(val eventId: String, val text: String? = null, val id: Int = 0) {
    companion object {
        const val ERROR: String = "FirestoreErrorEvent.Error"
    }
}