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
@file:Suppress("FunctionName")

package com.tuarua.firebase.firestore

import com.adobe.fre.FREObject
import com.google.firebase.firestore.*
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.setProp

@Throws(FreException::class)
//only handles String, Double, Int, Long, FREObject, Short, Boolean, Date
fun FREObject(name: String, mapFrom: Map<String, Any>): FREObject? {
    val argsArr = arrayOfNulls<FREObject>(0)
    return try {
        val v = FREObject.newObject(name, argsArr)
        for (k in mapFrom.keys) {
            v.setProp(k, mapFrom[k])
        }
        v
    } catch (e: FreException) {
        e.getError(Thread.currentThread().stackTrace)
    } catch (e: Exception) {
        throw FreException(e, "cannot create new object named $name")
    }
}

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

fun FirebaseFirestoreException.toMap(): Map<String, Any?>? {
    return mapOf(
            "text" to this.message.toString(),
            "id" to this.code.ordinal)
}

fun DocumentSnapshot.toMap(): Map<String, Any?>? {
    return mapOf("id" to this.id,
            "data" to this.data,
            "exists" to this.exists(),
            "metadata" to mapOf("isFromCache" to this.metadata.isFromCache,
                    "hasPendingWrites" to this.metadata.hasPendingWrites())
    )
}

fun DocumentChange.toMap(): Map<String, Any?>? {
    return mapOf(
            "type" to this.type.ordinal,
            "newIndex" to this.newIndex,
            "oldIndex" to this.oldIndex,
            "documentId" to this.document.id)
}

fun QueryDocumentSnapshot.toMap(): Map<String, Any?>? {
    return mapOf(
            "id" to this.id,
            "data" to this.data,
            "exists" to this.exists(),
            "metadata" to mapOf(
                    "isFromCache" to this.metadata.isFromCache,
                    "hasPendingWrites" to this.metadata.hasPendingWrites()
            )
    )
}

fun FirebaseFirestoreSettings.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.firestore.FirestoreSettings")
    ret.setProp("host", this.host)
    ret.setProp("isPersistenceEnabled", this.isPersistenceEnabled)
    ret.setProp("isSslEnabled", this.isSslEnabled)
    return ret
}