package com.tuarua.firebase.invites

import com.adobe.fre.FREObject
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.String

class InviteOptions(freObject: FREObject?) {
    var title: String? = null
    var message: String? = null
    var deepLink: String? = null
    var customImageUrl: String? = null
    var action: String? = null
    var androidClientID: String? = null
    var iOSClientID: String? = null

    init {
        if (freObject != null) {
            title = String(freObject["title"])
            message = String(freObject["message"])
            deepLink = String(freObject["deepLink"])
            customImageUrl = String(freObject["customImageUrl"])
            action = String(freObject["action"])
            androidClientID = String(freObject["androidClientID"])
            iOSClientID = String(freObject["iOSClientID"])
        }

    }
}
