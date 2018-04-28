@file:Suppress("FunctionName")

package com.tuarua.firebase.storage

import com.adobe.fre.FREObject
import com.google.firebase.storage.StorageMetadata
import com.google.firebase.storage.StorageReference
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.Map
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.setProp
import com.tuarua.frekotlin.String

fun StorageMetadata(freObject: FREObject?): StorageMetadata? {
    val rv = freObject ?: return null
    val builder = StorageMetadata.Builder()
    val cacheControl = String(rv["cacheControl"])
    val contentDisposition = String(rv["contentDisposition"])
    val contentEncoding = String(rv["contentEncoding"])
    val contentLanguage = String(rv["contentLanguage"])
    val contentType = String(rv["contentType"])
    if (cacheControl != null) {
        builder.setCacheControl(cacheControl)
    }
    if (contentDisposition != null) {
        builder.setContentDisposition(contentDisposition)
    }
    if (contentEncoding != null) {
        builder.setContentEncoding(contentEncoding)
    }
    if (contentLanguage != null) {
        builder.setContentLanguage(contentLanguage)
    }
    if (contentType != null) {
        builder.setContentType(contentType)
    }

    val customMetadata: Map<String, Any>? = Map(rv["customMetadata"])
    customMetadata?.keys?.forEach { k ->
        val v = customMetadata[k]
        when {
            v != null -> builder.setCustomMetadata(k, v as String?)
        }
    }
    return builder.build()
}

fun StorageReference.toFREObject(): FREObject? {
    val ret = FREObject("Object")
    ret.setProp("bucket", this.bucket)
    ret.setProp("name", this.name)
    ret.setProp("path", this.path)
    return ret
}