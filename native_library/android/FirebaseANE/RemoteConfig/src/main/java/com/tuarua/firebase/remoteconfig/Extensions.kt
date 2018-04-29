@file:Suppress("FunctionName")

package com.tuarua.firebase.remoteconfig

import com.adobe.fre.FREObject
import com.google.firebase.remoteconfig.FirebaseRemoteConfigInfo
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.setProp

fun FirebaseRemoteConfigInfo.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.remoteconfig.RemoteConfigInfo")
    ret.setProp("fetchTime", this.fetchTimeMillis)
    ret.setProp("lastFetchStatus", this.lastFetchStatus)
    ret.setProp("configSettings", this.configSettings.toFREObject())
    return ret
}

fun FirebaseRemoteConfigSettings(freObject: FREObject?): FirebaseRemoteConfigSettings? {
    val rv = freObject ?: return null
    return FirebaseRemoteConfigSettings.Builder()
            .setDeveloperModeEnabled(Boolean(rv["developerModeEnabled"]) == true)
            .build()
}

fun FirebaseRemoteConfigSettings.toFREObject(): FREObject? {
    return FREObject("com.tuarua.firebase.remoteconfig.RemoteConfigSettings",
            args = *arrayOf(this.isDeveloperModeEnabled))
}