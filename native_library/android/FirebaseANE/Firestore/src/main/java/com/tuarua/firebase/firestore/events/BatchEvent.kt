package com.tuarua.firebase.firestore.events

data class BatchEvent(val eventId: String) {
    companion object {
        const val COMPLETE = "BatchEvent.Complete"
    }
}
