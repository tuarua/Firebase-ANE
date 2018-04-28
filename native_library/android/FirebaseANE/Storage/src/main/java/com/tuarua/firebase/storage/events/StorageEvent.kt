package com.tuarua.firebase.storage.events

class StorageEvent(val eventId: String, val data: Map<String, Any>? = null) {
    companion object {
        const val GET_DOWNLOAD_URL: String = "StorageEvent.GetDownloadUrl"
        const val GET_METADATA: String = "StorageEvent.GetMetadata"
        const val UPDATE_METADATA: String = "StorageEvent.UpdateMetadata"
        const val COMPLETE: String = "StorageEvent.TaskComplete"
    }
}

