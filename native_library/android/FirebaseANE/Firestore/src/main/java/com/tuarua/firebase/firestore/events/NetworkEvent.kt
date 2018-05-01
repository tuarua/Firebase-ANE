package com.tuarua.firebase.firestore.events

class NetworkEvent(val eventId: String, val error: Map<String, Any?>? = null) {
    companion object {
        const val ENABLED: String = "NetworkEvent.Enabled"
        const val DISABLED: String = "NetworkEvent.Disabled"
    }
}
