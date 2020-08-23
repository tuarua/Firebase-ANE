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
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.common.InputImage.IMAGE_FORMAT_NV21
import java.nio.ByteBuffer
import java.util.concurrent.atomic.AtomicBoolean

abstract class BaseVisionProcessor<T>: VisionImageProcessor {

    private val shouldThrottle = AtomicBoolean(false)

    override fun process(data: ByteBuffer, width: Int, height: Int, rotation: Int) {
        if (shouldThrottle.get()) {
            return
        }
        detectInVisionImage(InputImage.fromByteBuffer(data, width, height,rotation, IMAGE_FORMAT_NV21))
    }

    override fun process(byteArray: ByteArray, width: Int, height: Int, rotation: Int) {
        if (shouldThrottle.get()) {
            return
        }
        detectInVisionImage(InputImage.fromByteArray(byteArray, width, height, rotation, IMAGE_FORMAT_NV21))
    }

    override fun stop() {
    }

    private fun detectInVisionImage(image: InputImage) {
        detectInImage(image).addOnSuccessListener {
            shouldThrottle.set(false)
            onDetectionSucceed(it)
        }.addOnFailureListener {
            shouldThrottle.set(false)
            onDetectionFailed(it)
        }
        // Start throttle until this frame of input has been processed.
        shouldThrottle.set(true)
    }

    protected abstract fun detectInImage(image: InputImage): Task<T>
    protected abstract fun onDetectionSucceed(result: T)
    protected abstract fun onDetectionFailed(exception: Exception)
}