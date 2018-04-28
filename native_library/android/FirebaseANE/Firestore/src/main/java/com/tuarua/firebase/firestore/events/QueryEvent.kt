package com.tuarua.firebase.firestore.events

class QueryEvent(val eventId: String, val data: Map<String, Any>? = null) {
    companion object {
        const val QUERY_SNAPSHOT: String = "QueryEvent.QuerySnapshot"
    }
}