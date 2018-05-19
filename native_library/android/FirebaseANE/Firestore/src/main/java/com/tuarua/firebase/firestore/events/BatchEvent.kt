package com.tuarua.firebase.firestore.events

class BatchEvent(val eventId: String) {
    companion object {
        const val COMPLETE = "BatchEvent.Complete"
    }
}
