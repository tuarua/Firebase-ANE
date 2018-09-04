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

@file:Suppress("unused", "FunctionName")

package com.tuarua.firebase.vision.cloudtext.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.cloud.text.FirebaseVisionCloudText
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.toFREObject

fun FirebaseVisionCloudText.Block.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.vision.CloudBlock")
    ret["confidence"] = confidence.toFREObject()
    ret["textProperty"] = textProperty?.toFREObject()
    ret["frame"] = boundingBox?.toFREObject()
    ret["paragraphs"] = paragraphs.toFREArray()
    return ret
}

fun List<FirebaseVisionCloudText.Block>.toFREArray(): FREArray? {
    val ret = FREArray("com.tuarua.firebase.vision.CloudBlock", size, true)
            ?: return null
    for (i in this.indices) {
        ret[i] = this[i].toFREObject()
    }
    return ret
}