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

package com.tuarua.firebase.vision.cloudlabel.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.cloud.label.FirebaseVisionCloudLabel
import com.tuarua.frekotlin.*

fun FirebaseVisionCloudLabel.toFREObject(): FREObject? {
    try {
        val ret = FREObject("com.tuarua.firebase.vision.CloudLabel")
        ret["confidence"] = confidence.toFREObject()
        ret["label"] = label.toFREObject()
        ret["entityId"] = entityId.toFREObject()
        return ret
    } catch (e: FreException) {

    }
    return null
}

fun List<FirebaseVisionCloudLabel>.toFREArray(): FREArray? {
    val ret = FREArray("com.tuarua.firebase.vision.CloudLabel", this.size, true)
    for (i in this.indices) {
        ret[i] = this[i].toFREObject()
    }
    return ret
}