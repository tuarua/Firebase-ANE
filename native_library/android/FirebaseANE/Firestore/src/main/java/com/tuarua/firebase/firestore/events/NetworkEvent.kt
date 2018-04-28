package com.tuarua.firebase.firestore.events

class NetworkEvent(val eventId: String, val enabled: Boolean = false) {
    companion object {
        const val COMPLETE: String = "NetworkEvent.Complete"
    }
}
