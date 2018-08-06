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

package com.tuarua.firebase.vision.text.extensions
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.text.FirebaseVisionText
import com.tuarua.firebase.vision.extensions.FREArray
import com.tuarua.firebase.vision.extensions.toFREObject
import com.tuarua.frekotlin.*

fun FirebaseVisionText.Block.toFREObject(): FREObject? {
    try {
        val ret = FREObject("com.tuarua.firebase.vision.TextBlock")

        ret["lines"] = lines.toFREArray()
        ret["frame"] = boundingBox?.toFREObject()
        ret["text"] = text.toFREObject()
        ret["cornerPoints"] = FREArray(cornerPoints)
        return ret
    } catch (e: FreException) {

    }
    return null
}