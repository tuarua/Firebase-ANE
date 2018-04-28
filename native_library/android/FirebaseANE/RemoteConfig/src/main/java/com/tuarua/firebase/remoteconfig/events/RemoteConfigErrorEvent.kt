package com.tuarua.firebase.remoteconfig.events


class RemoteConfigErrorEvent(val text: String? = null, val id: Int = 0) {
    companion object {
        const val FETCH_ERROR:String = "RemoteConfigErrorEvent.FetchError"
    }
}