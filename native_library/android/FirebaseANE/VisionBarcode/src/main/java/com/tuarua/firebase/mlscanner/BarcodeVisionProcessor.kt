/*
 * Copyright 2018 Tua Rua Ltd.
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

package com.tuarua.firebase.mlscanner

import com.google.android.gms.tasks.Task
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetector
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetectorOptions
import com.google.firebase.ml.vision.common.FirebaseVisionImage

class BarcodeVisionProcessor(formats: IntArray) : BaseVisionProcessor<List<FirebaseVisionBarcode>>() {
    private val detector: FirebaseVisionBarcodeDetector
    var visionProcessListener: VisionProcessListener? = null

    init {
        val builder = FirebaseVisionBarcodeDetectorOptions.Builder()
        if (formats.size == 1) {
            builder.setBarcodeFormats(formats.first())
        } else {
            val formatsRest = formats.copyOfRange(1, formats.lastIndex)
            builder.setBarcodeFormats(formats.first(), *formatsRest)
        }
        val options = builder.build()
        detector = FirebaseVision.getInstance().getVisionBarcodeDetector(options)
    }

    override fun stop() {
        detector.close()
    }

    override fun detectInImage(image: FirebaseVisionImage): Task<List<FirebaseVisionBarcode>> {
        return detector.detectInImage(image)
    }

    override fun onDetectionSucceed(result: List<FirebaseVisionBarcode>, frameMetadata: FrameMetadata) {
        if (!result.isEmpty()) {
            visionProcessListener?.onVisionProcessSucceed(result.toMutableList())
        }
    }

    override fun onDetectionFailed(exception: Exception) {
        // Log.e("EOIN VisionProcessor", Log.getStackTraceString(exception))
    }
}