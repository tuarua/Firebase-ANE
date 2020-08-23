/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.text.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.mlkit.vision.text.Text
import com.tuarua.mlkit.vision.extensions.FREArray
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.set

fun Text.Element.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.mlkit.vision.text.TextElement")
    ret["frame"] = boundingBox
    ret["text"] = text
    ret["cornerPoints"] = FREArray(cornerPoints)
    ret["recognizedLanguage"] = recognizedLanguage
    return ret
}

fun List<Text.Element>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.mlkit.vision.text.TextElement",
            size, true, this.map { it.toFREObject() })
}

operator fun FREObject?.set(name: String, value: List<Text.Element>) {
    val rv = this ?: return
    rv[name] = value.toFREObject()
}