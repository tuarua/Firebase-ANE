@file:Suppress("FunctionName")

package com.tuarua.firebase.firestore.extensions

import com.adobe.fre.FREObject
import com.google.firebase.firestore.FirebaseFirestoreSettings
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.setProp

fun FirebaseFirestoreSettings(freObject: FREObject?): FirebaseFirestoreSettings? {
    val rv = freObject ?: return null
    val isSSLEnabled = Boolean(rv["isSSLEnabled"])
    val isPersistenceEnabled = Boolean(rv["isPersistenceEnabled"])
    val builder = FirebaseFirestoreSettings.Builder()
    if (isPersistenceEnabled != null) {
        builder.setPersistenceEnabled(isPersistenceEnabled)
    }
    if (isSSLEnabled != null) {
        builder.setSslEnabled(isSSLEnabled)
    }
    return builder.build()
}

fun FirebaseFirestoreSettings.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.firestore.FirestoreSettings")
    ret.setProp("host", this.host)
    ret.setProp("isPersistenceEnabled", this.isPersistenceEnabled)
    ret.setProp("isSslEnabled", this.isSslEnabled)
    return ret
}