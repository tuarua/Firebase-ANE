/*
 * Copyright 2019 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.firebase.modelinterpreter.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.custom.FirebaseModelOptions
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseModelOptions(freObject: FREObject?): FirebaseModelOptions? {
    val rv = freObject ?: return null
    val cloudModelName = String(rv["cloudModelName"])
    val localModelName = String(rv["localModelName"])
    val builder = FirebaseModelOptions.Builder()
    if (cloudModelName != null) {
        builder.setCloudModelName(cloudModelName)
    }
    if (localModelName != null) {
        builder.setLocalModelName(localModelName)
    }
    return builder.build()
}