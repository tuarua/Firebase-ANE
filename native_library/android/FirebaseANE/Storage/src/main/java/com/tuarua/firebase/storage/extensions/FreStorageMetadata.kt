/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

@file:Suppress("unused")

package com.tuarua.firebase.storage.extensions

import com.adobe.fre.FREObject
import com.google.firebase.storage.StorageMetadata
import com.google.firebase.storage.ktx.storageMetadata
import com.tuarua.frekotlin.Map
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun StorageMetadata(freObject: FREObject?): StorageMetadata? {
    val rv = freObject ?: return null
    return storageMetadata {
        cacheControl = String(rv["cacheControl"]) ?: cacheControl
        contentDisposition = String(rv["contentDisposition"]) ?: contentDisposition
        contentEncoding = String(rv["contentEncoding"]) ?: contentEncoding
        contentLanguage = String(rv["contentLanguage"]) ?: contentLanguage
        contentType = String(rv["contentType"]) ?: contentType
        val cmd: Map<String, Any>? = Map(rv["customMetadata"])
        cmd?.keys?.forEach { k ->
            val v = cmd[k]
            when {
                v != null -> setCustomMetadata(k, v as String?)
            }
        }
    }
}

fun StorageMetadata.toMap(): Map<String, Any?> {
    val cmd: MutableMap<String, String?> = mutableMapOf()
    this.customMetadataKeys.forEach { customMetadataKey ->
        cmd[customMetadataKey] = getCustomMetadata(customMetadataKey)
    }
    return mapOf("bucket" to bucket,
            "cacheControl" to cacheControl,
            "contentDisposition" to contentDisposition,
            "contentEncoding" to contentEncoding,
            "contentLanguage" to contentLanguage,
            "contentType" to contentType,
            "creationTime" to creationTimeMillis,
            "updatedTime" to updatedTimeMillis,
            "generation" to generation,
            "md5Hash" to md5Hash,
            "metadataGeneration" to metadataGeneration,
            "name" to name,
            "path" to path,
            "size" to sizeBytes,
            "customMetadata" to cmd
    )
}