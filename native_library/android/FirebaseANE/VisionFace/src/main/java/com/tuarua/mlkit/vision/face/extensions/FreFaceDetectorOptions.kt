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
package com.tuarua.mlkit.vision.face.extensions

import com.adobe.fre.FREObject
import com.google.mlkit.vision.face.FaceDetectorOptions
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.Float

@Suppress("FunctionName")
fun FaceDetectorOptions(freObject: FREObject?): FaceDetectorOptions? {
    val rv = freObject ?: return null
    val classificationMode = Int(rv["classificationMode"]) ?: 1
    val contourMode = Int(rv["contourMode"]) ?: 1
    val performanceMode = Int(rv["performanceMode"]) ?: 1
    val landmarkMode = Int(rv["landmarkMode"]) ?: 1
    val isTrackingEnabled = Boolean(rv["isTrackingEnabled"]) ?: false
    val minFaceSize = Float(rv["minFaceSize"]) ?: 0.1f
    val builder = FaceDetectorOptions.Builder()
    builder.setPerformanceMode(performanceMode)
    builder.setClassificationMode(classificationMode)
    builder.setLandmarkMode(landmarkMode)
    builder.setContourMode(contourMode)
    if (isTrackingEnabled) {
        builder.enableTracking()
    }
    builder.setMinFaceSize(minFaceSize)
    return builder.build()
}