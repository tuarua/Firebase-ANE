package com.tuarua.firebase.storage.events

class StorageErrorEvent(val eventId: String, val text: String? = null, val id: Int = 0) {
    companion object {
        const val ERROR:String = "StorageErrorEvent.Error"
    }
}