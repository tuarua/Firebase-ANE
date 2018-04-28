package com.tuarua.firebase.firestore.events

class DocumentEvent(val eventId: String, val data: Map<String, Any?>? = null, val realtime: Boolean = false) {
    companion object {
        const val SNAPSHOT: String = "DocumentEvent.Snapshot"
        const val COMPLETE: String = "DocumentEvent.Complete"
    }
}
