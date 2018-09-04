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
package com.tuarua.firebase.vision.face.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.google.firebase.ml.vision.face.FirebaseVisionFace
import com.google.firebase.ml.vision.face.FirebaseVisionFaceLandmark.*
import com.tuarua.firebase.vision.extensions.toFREObject
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.Rect
import com.tuarua.frekotlin.geom.toFREObject

fun FirebaseVisionFace.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.vision.Face")
    ret["frame"] = this.boundingBox?.toFREObject()
    ret["hasTrackingId"] = true.toFREObject()
    ret["trackingId"] = this.trackingId.toFREObject()
    ret["hasHeadEulerAngleY"] = true.toFREObject()
    ret["headEulerAngleY"] = this.headEulerAngleY.toFREObject()
    ret["hasHeadEulerAngleZ"] = true.toFREObject()
    ret["headEulerAngleZ"] = this.headEulerAngleZ.toFREObject()
    ret["hasSmilingProbability"] = true.toFREObject()
    ret["smilingProbability"] = this.smilingProbability.toFREObject()
    ret["hasLeftEyeOpenProbability"] = true.toFREObject()
    ret["leftEyeOpenProbability"] = this.leftEyeOpenProbability.toFREObject()
    ret["hasRightEyeOpenProbability"] = true.toFREObject()
    ret["rightEyeOpenProbability"] = this.rightEyeOpenProbability.toFREObject()

    var cnt = 0
    val freLandMarks = FREArray("com.tuarua.firebase.vision.FaceLandmark") ?: return null
    val types = listOf(
            LEFT_EYE, RIGHT_EYE,
            BOTTOM_MOUTH, RIGHT_MOUTH, LEFT_MOUTH,
            LEFT_EAR, RIGHT_EAR,
            LEFT_CHEEK, RIGHT_CHEEK,
            NOSE_BASE)
    for (type in types) {
        val lm = this.getLandmark(type) ?: continue
        freLandMarks[cnt] = lm.toFREObject()
        cnt += 1
    }
    ret["landmarks"] = freLandMarks
    return ret
}

fun List<FirebaseVisionFace>.toFREArray(): FREArray? {
    val ret = FREArray("com.tuarua.firebase.vision.Face", size, true)
            ?: return null
    for (i in this.indices) {
        ret[i] = this[i].toFREObject()
    }
    return ret
}
