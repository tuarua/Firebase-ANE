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

@file:Suppress("FunctionName")

package com.tuarua.firebase.ml.vision.text.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.text.FirebaseVisionCloudTextRecognizerOptions
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.List
import com.tuarua.frekotlin.get

fun FirebaseVisionCloudTextRecognizerOptions(freObject: FREObject?): FirebaseVisionCloudTextRecognizerOptions? {
    val rv = freObject ?: return null
    val modelType = Int(rv["modelType"]) ?: return null
    val languageHints = List<String>(rv["languageHints"])
    val enforceCertFingerprintMatch = Boolean(rv["enforceCertFingerprintMatch"]) ?: false
    val builder = FirebaseVisionCloudTextRecognizerOptions.Builder()

    if (languageHints.isNotEmpty()) {
        builder.setLanguageHints(languageHints)
    }
    builder.setModelType(modelType + 1)
    if (enforceCertFingerprintMatch) {
        builder.enforceCertFingerprintMatch()
    }
    return builder.build()
}