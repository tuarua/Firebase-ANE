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
package com.tuarua.firebase.ml.vision.face.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.face.FirebaseVisionFace
import com.google.firebase.ml.vision.face.FirebaseVisionFaceLandmark.*
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.toFREObject

fun FirebaseVisionFace.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.ml.vision.face.Face")
    ret["frame"] = this.boundingBox.toFREObject()
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

    val types = listOf(
            LEFT_EYE, RIGHT_EYE,
            MOUTH_BOTTOM, MOUTH_RIGHT, MOUTH_LEFT,
            LEFT_EAR, RIGHT_EAR,
            LEFT_CHEEK, RIGHT_CHEEK,
            NOSE_BASE)

    val freLandMarks = FREArray("com.tuarua.firebase.ml.vision.face.FaceLandmark",
            items = types.mapNotNull { this.getLandmark(it)?.toFREObject() }) ?: return null
    ret["landmarks"] = freLandMarks
    return ret
}

fun List<FirebaseVisionFace>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.firebase.ml.vision.face.Face",
            size, true, this.map { it.toFREObject() })
}
