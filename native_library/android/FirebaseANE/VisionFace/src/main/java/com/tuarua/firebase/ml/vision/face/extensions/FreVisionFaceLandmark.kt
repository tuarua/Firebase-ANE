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

import com.google.firebase.ml.vision.face.FirebaseVisionFaceLandmark
import com.tuarua.firebase.ml.vision.common.extensions.toFREObject
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.toFREObject

fun FirebaseVisionFaceLandmark.toFREObject() =
        FREObject("com.tuarua.firebase.ml.vision.face.FaceLandmark",
                    position.toFREObject(), landmarkTypeString(landmarkType)?.toFREObject())

private fun landmarkTypeString(value: Int): String? {
    return when (value) {
        0 -> "MouthBottom"
        1 -> "LeftCheek"
        3 -> "LeftEar"
        4 -> "LeftEye"
        5 -> "MouthLeft"
        6 -> "NoseBase"
        7 -> "RightCheek"
        9 -> "RightEar"
        10 -> "RightEye"
        11 -> "MouthRight"
        else -> null
    }
}