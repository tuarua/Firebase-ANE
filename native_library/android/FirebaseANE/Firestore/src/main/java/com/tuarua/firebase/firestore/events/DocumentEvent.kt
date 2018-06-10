package com.tuarua.firebase.firestore.events

data class DocumentEvent(val eventId: String, val data: Map<String, Any?>? = null,
                    val realtime: Boolean = false, val error: Map<String, Any?>? = null) {
    companion object {
        const val SNAPSHOT = "DocumentEvent.Snapshot"
        const val QUERY_SNAPSHOT = "QueryEvent.QuerySnapshot"
        const val UPDATED = "DocumentEvent.Updated"
        const val SET = "DocumentEvent.Set"
        const val DELETED = "DocumentEvent.Deleted"
    }
}
