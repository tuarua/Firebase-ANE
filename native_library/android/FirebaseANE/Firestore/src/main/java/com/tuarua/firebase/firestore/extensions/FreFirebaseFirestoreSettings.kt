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

package com.tuarua.firebase.firestore.extensions

import com.adobe.fre.FREObject
import com.google.firebase.firestore.FirebaseFirestoreSettings
import com.google.firebase.firestore.ktx.firestoreSettings
import com.tuarua.frekotlin.*

fun FirebaseFirestoreSettings(freObject: FREObject?): FirebaseFirestoreSettings? {
    val rv = freObject ?: return null
    return firestoreSettings {
        isSslEnabled = Boolean(rv["isSslEnabled"]) == true
        host = String(rv["host"]) ?: host
        isPersistenceEnabled = Boolean(rv["isPersistenceEnabled"]) == true
    }
}

fun FirebaseFirestoreSettings.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.firestore.FirestoreSettings")
    ret["host"] = host
    ret["isPersistenceEnabled"] = isPersistenceEnabled
    ret["isSslEnabled"] = isSslEnabled
    return ret
}