package com.tuarua.firebase.dynamiclinks.events

data class DynamicLinkEvent(val callbackId: String,
                            val short: Boolean,
                            val data: Map<String, Any>? = null,
                            val error: Map<String, Any>? = null) {
    companion object {
        const val ON_CREATED = "DynamicLinkEvent.OnCreated"
        const val ON_LINK = "DynamicLinkEvent.OnLink"
    }
}