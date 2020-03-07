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

package com.tuarua.firebase.ml.vision.label.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabel
import com.tuarua.frekotlin.*

fun FirebaseVisionImageLabel.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.ml.vision.label.VisionImageLabel")
    ret["confidence"] = confidence
    ret["text"] = text
    ret["entityId"] = entityId
    return ret
}

fun List<FirebaseVisionImageLabel>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.firebase.ml.vision.label.VisionImageLabel",
            size, true, this.map { it.toFREObject() })
}