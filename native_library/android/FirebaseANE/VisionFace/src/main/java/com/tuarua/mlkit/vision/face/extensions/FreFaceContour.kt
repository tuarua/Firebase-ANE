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

package com.tuarua.mlkit.vision.face.extensions

import android.graphics.PointF
import com.adobe.fre.FREArray
import com.google.mlkit.vision.face.FaceContour
import com.tuarua.frekotlin.FREArray
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.geom.toFREObject
import com.tuarua.frekotlin.toFREObject

fun FaceContour.toFREObject() =
        FREObject("com.tuarua.mlkit.vision.face.FaceContour",
                points.toFREObject(), faceContourTypeString(faceContourType)?.toFREObject())

private fun faceContourTypeString(value: Int): String? {
    return when (value) {
        2 -> "Face"
        3 -> "LeftEyebrowTop"
        4 -> "LeftEyebrowBottom"
        5 -> "RightEyebrowTop"
        6 -> "RightEyebrowBottom"
        7 -> "LeftEye"
        8 -> "RightEye"
        9 -> "UpperLipTop"
        10 -> "UpperLipBottom"
        11 -> "LowerLipTop"
        12 -> "LowerLipBottom"
        13 -> "NoseBridge"
        14 -> "NoseBottom"
        else -> null
    }
}

fun List<PointF>.toFREObject(): FREArray? {
    return FREArray("flash.geom.Point",
            size, true, this.map { it.toFREObject() })
}