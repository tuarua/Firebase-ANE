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

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.face.FirebaseVisionFaceDetectorOptions
import com.google.firebase.ml.vision.face.FirebaseVisionFaceDetectorOptions.Builder
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.Float

@Suppress("FunctionName")
fun FirebaseVisionFaceDetectorOptions(freObject: FREObject?): FirebaseVisionFaceDetectorOptions? {
    val rv = freObject ?: return null
    val classificationType = Int(rv["classificationType"]) ?: 1
    val modeType = Int(rv["modeType"]) ?: 1
    val landmarkType = Int(rv["landmarkType"]) ?: 1
    val isTrackingEnabled = Boolean(rv["isTrackingEnabled"]) ?: false
    val minFaceSize = Float(rv["minFaceSize"]) ?: 0.1f

    // TODO naming conventions
    val builder = Builder()
    builder.setClassificationMode(classificationType)
    builder.setLandmarkMode(landmarkType)
    builder.setContourMode(modeType)
    if (isTrackingEnabled) {
        builder.enableTracking()
    }
    builder.setMinFaceSize(minFaceSize)
    return builder.build()
}