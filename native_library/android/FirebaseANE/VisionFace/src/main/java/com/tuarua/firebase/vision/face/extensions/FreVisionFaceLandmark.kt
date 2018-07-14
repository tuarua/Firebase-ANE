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
import com.google.firebase.ml.vision.face.FirebaseVisionFaceLandmark
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.toFREObject

fun FirebaseVisionFaceLandmark.toFREObject(): FREObject? {
    try {
        return FREObject("com.tuarua.firebase.vision.FaceLandmark",
                position.toFREObject(), faceLandmarkType.toFREObject())
    } catch (e: FreException) {
    }
    return null
}