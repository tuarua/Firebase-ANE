package com.tuarua.firebase.storage.events

class StorageProgressEvent(val eventId: String, val bytesLoaded: Long, val bytesTotal: Long) {
    companion object {
        //const val GET_FILE_PROGRESS:String = "StorageProgressEvent.GetFileProgress"
        //const val PUT_FILE_PROGRESS:String = "StorageProgressEvent.PutFileProgress"
        //const val PUT_BYTES_PROGRESS:String = "StorageProgressEvent.PutBytesProgress"
        const val PROGRESS: String = "StorageProgressEvent.Progress"
    }
}