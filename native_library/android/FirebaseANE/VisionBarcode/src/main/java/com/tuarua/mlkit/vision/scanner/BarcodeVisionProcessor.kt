/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.scanner

import com.google.android.gms.tasks.Task
import com.google.mlkit.vision.barcode.Barcode
import com.google.mlkit.vision.barcode.BarcodeScanner
import com.google.mlkit.vision.barcode.BarcodeScannerOptions
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.common.InputImage

class BarcodeVisionProcessor(formats: IntArray) : BaseVisionProcessor<List<Barcode>>() {
    private val detector: BarcodeScanner
    var visionProcessListener: VisionProcessListener? = null

    init {
        val builder = BarcodeScannerOptions.Builder()
        if (formats.size == 1) {
            builder.setBarcodeFormats(formats.first())
        } else {
            val formatsRest = formats.copyOfRange(1, formats.lastIndex)
            builder.setBarcodeFormats(formats.first(), *formatsRest)
        }

        detector = BarcodeScanning.getClient(builder.build())
    }

    override fun stop() {
        detector.close()
    }

    override fun detectInImage(image: InputImage): Task<List<Barcode>> {
        return detector.process(image)
    }

    override fun onDetectionSucceed(result: List<Barcode>) {
        if (result.isNotEmpty()) {
            visionProcessListener?.onVisionProcessSucceed(result.toMutableList())
        }
    }

    override fun onDetectionFailed(exception: Exception) {
    }
}