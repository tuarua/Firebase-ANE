package com.tuarua.firebase.firestore.events

class DocumentEvent(val eventId: String, val data: Map<String, Any?>? = null,
                    val realtime: Boolean = false, val error: Map<String, Any?>? = null) {
    companion object {
        const val SNAPSHOT: String = "DocumentEvent.Snapshot"
        const val QUERY_SNAPSHOT: String = "QueryEvent.QuerySnapshot"
        const val UPDATED: String = "DocumentEvent.Updated"
        const val SET: String = "DocumentEvent.Set"
        const val DELETED: String = "DocumentEvent.Deleted"
    }
}
