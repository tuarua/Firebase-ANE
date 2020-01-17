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

package com.tuarua.firebase.ml.vision.document.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.document.FirebaseVisionDocumentText
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.set

fun FirebaseVisionDocumentText.RecognizedBreak.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.ml.vision.document.RecognizedBreak")
    ret["isPrefix"] = isPrefix
    ret["type"] = detectedBreakType
    return ret
}

operator fun FREObject?.set(name: String, value: FirebaseVisionDocumentText.RecognizedBreak?) {
    val rv = this ?: return
    rv[name] = value?.toFREObject()
}