package com.tuarua.firebase.firestore.events

data class NetworkEvent(val callbackId: String, val error: Map<String, Any?>? = null) {
    companion object {
        const val ENABLED = "NetworkEvent.Enabled"
        const val DISABLED = "NetworkEvent.Disabled"
    }
}
