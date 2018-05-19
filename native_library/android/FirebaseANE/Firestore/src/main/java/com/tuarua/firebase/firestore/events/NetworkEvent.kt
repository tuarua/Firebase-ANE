package com.tuarua.firebase.firestore.events

class NetworkEvent(val eventId: String, val error: Map<String, Any?>? = null) {
    companion object {
        const val ENABLED = "NetworkEvent.Enabled"
        const val DISABLED = "NetworkEvent.Disabled"
    }
}
