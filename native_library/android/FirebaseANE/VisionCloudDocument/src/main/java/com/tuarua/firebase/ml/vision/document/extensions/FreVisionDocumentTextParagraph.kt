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

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.document.FirebaseVisionDocumentText
import com.tuarua.frekotlin.FREArray
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.geom.toFREObject
import com.tuarua.frekotlin.set
import com.tuarua.frekotlin.toFREObject
import com.tuarua.firebase.ml.vision.text.extensions.toFREObject

fun FirebaseVisionDocumentText.Paragraph.toFREObject(resultId: String, blockIndex: Int, index: Int): FREObject? {
    val ret = FREObject("com.tuarua.firebase.ml.vision.document.DocumentTextParagraph",
            resultId, blockIndex, index)
    ret["frame"] = boundingBox?.toFREObject()
    ret["text"] = text.toFREObject()
    ret["confidence"] = confidence?.toFREObject()
    ret["recognizedLanguages"] = this.recognizedLanguages.toFREObject()
    ret["recognizedBreak"] = this.recognizedBreak?.toFREObject()
    return ret
}

fun List<FirebaseVisionDocumentText.Paragraph>.toFREObject(resultId: String, blockIndex: Int): FREArray? {
    val ret = FREArray("com.tuarua.firebase.ml.vision.document.DocumentTextParagraph", size, true)
            ?: return null
    for (i in this.indices) {
        ret[i] = this[i].toFREObject(resultId, blockIndex, i)
    }
    return ret
}