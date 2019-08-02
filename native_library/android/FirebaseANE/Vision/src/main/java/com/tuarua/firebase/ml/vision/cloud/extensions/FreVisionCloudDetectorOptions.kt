/*
 * Copyright 2018 Tua Rua Ltd.
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

package com.tuarua.firebase.ml.vision.cloud.extensions

import com.google.firebase.ml.vision.cloud.FirebaseVisionCloudDetectorOptions
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseVisionCloudDetectorOptions(freObject: FREObject?): FirebaseVisionCloudDetectorOptions? {
    val rv = freObject ?: return null
    val maxResults = Int(rv["maxResults"]) ?: 10
    val modelType = Int(rv["modelType"]) ?: return null
    val enforceCertFingerprintMatch = Boolean(rv["enforceCertFingerprintMatch"]) ?: false
    val builder = FirebaseVisionCloudDetectorOptions.Builder()
    builder.setModelType(modelType + 1)
    builder.setMaxResults(maxResults)
    if (enforceCertFingerprintMatch) {
        builder.enforceCertFingerprintMatch()
    }
    return builder.build()
}