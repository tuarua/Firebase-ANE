package com.tuarua.firebase.firestore.events

data class BatchEvent(val callbackId: String) {
    companion object {
        const val COMPLETE = "BatchEvent.Complete"
    }
}
