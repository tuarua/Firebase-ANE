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
package com.tuarua.firebase.vision.barcode.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetectorOptions
import com.tuarua.frekotlin.IntArray
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseVisionBarcodeDetectorOptions(freObject: FREObject?): FirebaseVisionBarcodeDetectorOptions? {
    val rv = freObject ?: return null
    val formats = IntArray(rv["formats"]) ?: return null
    if (formats.isEmpty()) return null

    val builder = FirebaseVisionBarcodeDetectorOptions.Builder()
    if (formats.size == 1) {
        builder.setBarcodeFormats(formats.first())
    } else {
        val formatsRest = formats.copyOfRange(1, formats.lastIndex)
        builder.setBarcodeFormats(formats.first(), *formatsRest)
    }

    return builder.build()
}